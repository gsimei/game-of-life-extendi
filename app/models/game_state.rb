class GameState < ApplicationRecord
  belongs_to :user

  attr_accessor :input_file

  before_validation :process_file, if: :file_present?

  def file_present?
    input_file.present?
  end

  def process_file
    parsed = GameStateUploadService.new(input_file.read).call
    self.attributes = parsed
  rescue => e
    errors.add(:base, "Invalid file format: #{e.message}")
  end
end
