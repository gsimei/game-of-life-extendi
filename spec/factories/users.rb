FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }        # Gera um email aleatório
    password { 'password123' }             # Senha padrão
    password_confirmation { 'password123' }
  end
end
