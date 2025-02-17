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

  describe "Validation and error handling" do
    ##
    # Validates that the service raises an error if the number of
    # rows in the game state does not match the expected count.
    #
    # @example Expected output:
    #   raise GameStateProgressionError with message containing "number of rows"
    it "raises an error when the row count is incorrect" do
      game_state = build(:game_state, user: user, rows: 3, cols: 3, state: [
        [ ".", ".", "." ],
        [ ".", "*", "." ]  # Missing third row
      ])

      service = GameStateProgressionService.new(game_state)
      expect { service.next_generation! }
        .to raise_error(GameStateProgressionError, /number of rows/)
    end

    ##
    # Validates that the service raises an error if a row contains
    # an incorrect number of columns.
    #
    # @example Expected output:
    #   raise GameStateProgressionError with message containing "row 1"
    it "raises an error when a row has an incorrect column count" do
      game_state = build(:game_state, user: user, rows: 3, cols: 3, state: [
        [ ".", ".", "." ],
        [ ".", "*" ],  # Invalid row (only 2 columns instead of 3)
        [ ".", ".", "." ]
      ])

      service = GameStateProgressionService.new(game_state)
      expect { service.next_generation! }
      .to raise_error(GameStateProgressionError, /Row 1 does not match the expected \d+ columns/)
    end

    ##
    # Validates that the service raises an error if the game state
    # contains an invalid character.
    #
    # @example Expected output:
    #   raise GameStateProgressionError with message containing "Invalid cell"
    it "raises an error when an invalid character is present in the grid" do
      game_state = build(:game_state, user: user, rows: 3, cols: 3, state: [
        [ ".", ".", "." ],
        [ ".", "X", "." ],  # Invalid character "X"
        [ ".", ".", "." ]
      ])

      service = GameStateProgressionService.new(game_state)
      expect { service.next_generation! }
        .to raise_error(GameStateProgressionError, /Invalid cell/)
    end

    ##
    # Validates that the service raises an error if saving the new game
    # state fails due to a database validation error.
    #
    # @example Expected output:
    #   raise GameStateProgressionError with message containing "Failed to save"
    it "raises an error when saving the game state fails" do
      game_state = build(:game_state, user: user, rows: 3, cols: 3, state: [
        [ ".", "*", "." ],
        [ "*", "*", "." ],
        [ ".", ".", "." ]
      ])

      # Simulates a database validation failure
      allow(game_state).to receive(:save!).and_raise(ActiveRecord::RecordInvalid.new(game_state))

      service = GameStateProgressionService.new(game_state)
      expect { service.next_generation! }
        .to raise_error(GameStateProgressionError, /Failed to save/)
    end
  end
end
