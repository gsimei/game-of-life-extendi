class GameState < ApplicationRecord
  belongs_to :user

  attr_accessor :input_file

  before_validation :process_file, if: :input_file

  def next_generation!
    GameStateProgressionService.new(self).next_generation!
  end

  def alived_cells
    state.flatten.count { |cell| cell == "*" }
  end

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
