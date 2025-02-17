# GameState represents the state of the game for a particular user.
# It includes functionality to process uploaded files, progress to the next generation,
# and restore the initial state.
#
# @!attribute [rw] input_file
#   @return [ActionDispatch::Http::UploadedFile] the uploaded file containing the initial game state
class GameState < ApplicationRecord
  belongs_to :user

  attr_accessor :input_file

  before_validation :process_file, if: :input_file
  before_save :update_alived_cells_count
  before_create :store_initial_file_data

  # Progresses the game state to the next generation.
  #
  # @return [void]
  def next_generation!
    begin
      GameStateProgressionService.new(self).next_generation!
      true
    rescue GameStateProgressionError => e
      errors.add(:base, e.message)
      false
    end
  end

  # Restores the game state to its initial state.
  #
  # @return [Boolean] true if the state was successfully restored, false otherwise
  def restore_initial_state!
    return false if initial_file_data.blank?

    self.generation = initial_file_data["generation"]
    self.rows = initial_file_data["rows"]
    self.cols = initial_file_data["cols"]
    self.state = initial_file_data["state"]
    save
  end

  private

  # Processes the uploaded file and sets the game state attributes.
  #
  # @return [void]
  # @raise [StandardError] if the file format is invalid
  def process_file
    validate_file_type

    parsed = GameStateUploadService.new(input_file.read).call
    self.attributes = parsed
  rescue => e
    errors.add(:base, "Invalid file format: #{e.message}")
  end

  # Validates the type of the uploaded file.
  #
  # @return [void]
  # @raise [StandardError] if the file is not a text file
  def validate_file_type
    unless input_file.content_type == "text/plain"
      errors.add(:input_file, "must be a .txt file")
      throw :abort
    end
  end

  # Updates the count of alive cells in the game state.
  #
  # @return [void]
  def update_alived_cells_count
    self.alived_cells_count = state.flatten.count { |cell| cell == "*" }
  end

  # Stores the initial file data for the game state.
  #
  # @return [void]
  def store_initial_file_data
    self.initial_file_data = {
      generation: generation,
      rows: rows,
      cols: cols,
      state: state
    }
  end
end
