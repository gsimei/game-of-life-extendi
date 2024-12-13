require 'rails_helper'

##
# Test suite for the GameStateProgressionService.
#
# This test suite validates the progression rules of Conway's Game of Life,
# ensuring that the game state transitions correctly according to the rules.
#
# @example Run this test suite with:
#   bundle exec rspec spec/services/game_state_progression_service_spec.rb
RSpec.describe GameStateProgressionService do
  let(:user) { build(:user) }

  ##
  # Test suite for the progression rules of Conway's Game of Life.
  #
  # Ensures that the game state transitions correctly according to the rules.
  describe "Game of Life progression" do
    context "Rule 1: Any live cell with fewer than two live neighbours dies (underpopulation)" do
      ##
      # Validates that a live cell with no live neighbours dies.
      #
      # @example Test output:
      #   game_state.generation => 2
      #   game_state.state => [
      #     [ ".", ".", "." ],
      #     [ ".", ".", "." ],
      #     [ ".", ".", "." ]
      #   ]
      it "kills a live cell with no live neighbours" do
        game_state = build(:game_state, user: user, rows: 3, cols: 3, state: [
          [ ".", ".", "." ],
          [ ".", "*", "." ],
          [ ".", ".", "." ]
        ])

        allow(game_state).to receive(:save!).and_return(true)

        GameStateProgressionService.new(game_state).next_generation!

        expect(game_state.generation).to eq(2)
        expect(game_state.state).to eq([
          [ ".", ".", "." ],
          [ ".", ".", "." ],
          [ ".", ".", "." ]
        ])
      end
    end

    context "Rule 2: Any live cell with two or three live neighbours survives" do
      ##
      # Validates that a live cell with two live neighbours survives.
      #
      # @example Test output:
      #   game_state.generation => 2
      #   game_state.state[1][1] => "*"
      it "keeps a live cell alive with two live neighbours" do
        game_state = build(:game_state, user: user, rows: 3, cols: 3, state: [
          [ ".", "*", "." ],
          [ "*", "*", "." ],
          [ ".", ".", "." ]
        ])

        allow(game_state).to receive(:save!).and_return(true)

        GameStateProgressionService.new(game_state).next_generation!

        expect(game_state.generation).to eq(2)
        expect(game_state.state[1][1]).to eq("*")
      end

      ##
      # Validates that a live cell with three live neighbours survives.
      #
      # @example Test output:
      #   game_state.generation => 2
      #   game_state.state[1][1] => "*"
      it "keeps a live cell alive with three live neighbours" do
        game_state = build(:game_state, user: user, rows: 3, cols: 3, state: [
          [ "*", "*", "." ],
          [ ".", "*", "." ],
          [ ".", ".", "." ]
        ])

        allow(game_state).to receive(:save!).and_return(true)

        GameStateProgressionService.new(game_state).next_generation!

        expect(game_state.generation).to eq(2)
        expect(game_state.state[1][1]).to eq("*")
      end
    end

    context "Rule 3: Any live cell with more than three live neighbours dies (overpopulation)" do
      ##
      # Validates that a live cell with four live neighbours dies.
      #
      # @example Test output:
      #   game_state.generation => 2
      #   game_state.state[1][1] => "."
      it "kills a live cell with four live neighbours" do
        game_state = build(:game_state, user: user, rows: 3, cols: 3, state: [
          [ "*", "*", "*" ],
          [ "*", "*", "." ],
          [ ".", ".", "." ]
        ])

        allow(game_state).to receive(:save!).and_return(true)

        GameStateProgressionService.new(game_state).next_generation!

        expect(game_state.generation).to eq(2)
        expect(game_state.state[1][1]).to eq(".") # The central cell should die
      end
    end

    context "Rule 4: Any dead cell with exactly three live neighbours becomes a live cell (reproduction)" do
      ##
      # Validates that a dead cell with exactly three live neighbours becomes a live cell.
      #
      # @example Test output:
      #   game_state.generation => 2
      #   game_state.state => [
      #     [ ".", ".", "." ],
      #     [ "*", "*", "*" ],
      #     [ ".", ".", "." ]
      #   ]
      it "creates a new live cell if it has exactly three live neighbours" do
        game_state = build(:game_state, user: user, rows: 3, cols: 3, state: [
          [ ".", "*", "." ],
          [ ".", "*", "." ],
          [ ".", "*", "." ]
        ])

        allow(game_state).to receive(:save!).and_return(true)

        GameStateProgressionService.new(game_state).next_generation!

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
