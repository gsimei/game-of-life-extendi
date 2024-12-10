class GameState < ApplicationRecord
  belongs_to :user

  attr_accessor :input_file

  before_validation :process_file, if: :file_present?

  def file_present?
    input_file.present?
  end

  def process_file
    return file_type_error_message unless input_file.content_type == "text/plain"

    parsed = GameStateUploadService.new(input_file.read).call
    self.attributes = parsed
  rescue => e
    errors.add(:base, "Invalid file format: #{e.message}")
  end

  private

  def file_type_error_message
    errors.add(:input_file, "must be a .txt file")
  end
end
