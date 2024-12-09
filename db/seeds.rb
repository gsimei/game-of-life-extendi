# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
User.destroy_all
GameState.destroy_all

# Criamos um usuário de teste
user = User.create!(
  email: "test@example.com",
  password: "password123",
  password_confirmation: "password123"
)

# Criar 10 GameStates com tamanhos aleatórios e padrões aleatórios
10.times do
  rows = rand(3..10)
  cols = rand(3..10)

  # Criar um grid com '.' ou '*' aleatoriamente (20% de chance de vida)
  random_state = Array.new(rows) do
    Array.new(cols) { rand < 0.2 ? '*' : '.' }
  end

  GameState.create!(
    user: user,
    generation: rand(1..10),
    rows: rows,
    cols: cols,
    state: random_state
  )
end
