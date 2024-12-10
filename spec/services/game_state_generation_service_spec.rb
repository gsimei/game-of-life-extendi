require 'rails_helper'

RSpec.describe GameStateGenerationService do
  let(:user) { build(:user) }

  describe "Game of Life progression" do
    context "Rule 1: Any live cell with fewer than two live neighbours dies (underpopulation)" do
      it "kills a live cell with no live neighbours" do
        game_state = build(:game_state, user: user, rows: 3, cols: 3, state: [
          [ ".", ".", "." ],
          [ ".", "*", "." ],
          [ ".", ".", "." ]
        ])

        allow(game_state).to receive(:save!).and_return(true)

        GameStateGenerationService.new(game_state).next_generation!

        expect(game_state.generation).to eq(2)
        expect(game_state.state).to eq([
          [ ".", ".", "." ],
          [ ".", ".", "." ],
          [ ".", ".", "." ]
        ])
      end
    end

    context "Rule 2: Any live cell with two or three live neighbours survives" do
      it "keeps a live cell alive with two live neighbours" do
        game_state = build(:game_state, user: user, rows: 3, cols: 3, state: [
          [ ".", "*", "." ],
          [ "*", "*", "." ],
          [ ".", ".", "." ]
        ])

        allow(game_state).to receive(:save!).and_return(true)

        GameStateGenerationService.new(game_state).next_generation!

        expect(game_state.generation).to eq(2)
        expect(game_state.state[1][1]).to eq("*")
      end

      it "keeps a live cell alive with three live neighbours" do
        game_state = build(:game_state, user: user, rows: 3, cols: 3, state: [
          [ "*", "*", "." ],
          [ ".", "*", "." ],
          [ ".", ".", "." ]
        ])

        allow(game_state).to receive(:save!).and_return(true)

        GameStateGenerationService.new(game_state).next_generation!

        expect(game_state.generation).to eq(2)
        expect(game_state.state[1][1]).to eq("*")
      end
    end

    context "Rule 3: Any live cell with more than three live neighbours dies (overpopulation)" do
      it "kills a live cell with four live neighbours" do
        game_state = build(:game_state, user: user, rows: 3, cols: 3, state: [
          [ "*", "*", "*" ],
          [ "*", "*", "." ],
          [ ".", ".", "." ]
        ])

        allow(game_state).to receive(:save!).and_return(true)

        GameStateGenerationService.new(game_state).next_generation!

        expect(game_state.generation).to eq(2)
        expect(game_state.state[1][1]).to eq(".") # A célula central deve morrer
      end
    end

    context "Rule 4: Any dead cell with exactly three live neighbours becomes a live cell (reproduction)" do
      it "creates a new live cell if it has exactly three live neighbours" do
        game_state = build(:game_state, user: user, rows: 3, cols: 3, state: [
          [ ".", "*", "." ],
          [ ".", "*", "." ],
          [ ".", "*", "." ]
        ])

        allow(game_state).to receive(:save!).and_return(true)

        GameStateGenerationService.new(game_state).next_generation!

        expect(game_state.generation).to eq(2)
        expect(game_state.state).to eq([
          [ ".", ".", "." ],
          [ "*", "*", "*" ],
          [ ".", ".", "." ]
        ])
      end
    end
  end
end
