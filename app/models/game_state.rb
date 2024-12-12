class GameState < ApplicationRecord
  belongs_to :user

  attr_accessor :input_file

  before_validation :process_file, if: :input_file

  before_save :update_alived_cells_count
  after_create :store_initial_file_data


  def next_generation!
    GameStateProgressionService.new(self).next_generation!
  end

  def restore_initial_state!
    return false if initial_file_data.blank?

    self.generation = initial_file_data["generation"]
    self.rows = initial_file_data["rows"]
    self.cols = initial_file_data["cols"]
    self.state = initial_file_data["state"]
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

  def update_alived_cells_count
    self.alived_cells_count = state.flatten.count { |cell| cell == "*" }
  end

  def store_initial_file_data
    update_column(:initial_file_data, {
      generation: generation,
      rows: rows,
      cols: cols,
      state: state
    })
  end
end
