class GameState < ApplicationRecord
  validates :generation, presence: true
  validates :rows, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :cols, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validate :state_matches_dimensions

  private

  def state_matches_dimensions
    return if state.blank?

    # Esperamos que state seja algo como um array de arrays de caracteres
    # Certifique-se que `state` é um array do tamanho `rows`
    unless state.is_a?(Array) && state.size == rows && state.all? { |row| row.is_a?(Array) && row.size == cols }
      errors.add(:state, "does not match the specified rows and cols")
    end
  end
end
