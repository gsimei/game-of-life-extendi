FactoryBot.define do
  factory :game_state do
    association :user
    generation { 1 }
    rows { 4 }
    cols { 8 }
    state { Array.new(rows) { Array.new(cols, ".") } } # Estado inicial vazio
    initial_file_data { {} }

    # Trait para um estado inicial progressivo (ex: padrão 'blinker')
    trait :blinker do
      rows { 5 }
      cols { 5 }
      state do
        [
          [ ".", ".", ".", ".", "." ],
          [ ".", ".", "*", ".", "." ],
          [ ".", ".", "*", ".", "." ],
          [ ".", ".", "*", ".", "." ],
          [ ".", ".", ".", ".", "." ]
        ]
      end
    end

    # Trait para um estado estável (ex: padrão 'block')
    trait :block do
      rows { 4 }
      cols { 4 }
      state do
        [
          [ ".", ".", ".", "." ],
          [ ".", "*", "*", "." ],
          [ ".", "*", "*", "." ],
          [ ".", ".", ".", "." ]
        ]
      end
    end
  end
end
