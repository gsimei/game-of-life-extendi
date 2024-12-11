class GameState < ApplicationRecord
  has_paper_trail on: :create, only: %i[ generation rows cols state ]

  belongs_to :user

  attr_accessor :input_file

  before_validation :process_file, if: :input_file

  def next_generation!
    GameStateProgressionService.new(self).next_generation!
  end

  def alived_cells
    state.flatten.count { |cell| cell == "*" }
  end

  def restore_initial_state
    initial_state_str = versions.first.object_changes

    # Parse the string into a hash
    initial_state = YAML.safe_load(initial_state_str)

    initial_state.each do |attribute, (old_value, new_value)|
      if attribute == "state"
        # Parse the new_value from a string to an array
        new_state = JSON.parse(new_value)
        send("#{attribute}=", new_state)
      else
        send("#{attribute}=", new_value)
      end
    end

    save
  end

  private

  def process_file
    validate_file_type

    parsed = GameStateUploadService.new(input_file.read).call
    self.attributes = parsed
  rescue => e
    errors.add(:base, "Invalid file format: #{e.message}")
  end

  def validate_file_type
    unless input_file.content_type == "text/plain"
      errors.add(:input_file, "must be a .txt file")
      throw :abort
    end
  end
end
