FactoryBot.define do
  factory :game_state do
    association :user
    generation { 1 }
    rows { 4 }
    cols { 8 }
    state { Array.new(rows) { Array.new(cols, ".") } }
    initial_file_data { {} }
  end
end
