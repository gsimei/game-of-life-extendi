# GameStateProgressionService is responsible for progressing the game state
# to the next generation based on the rules of Conway's Game of Life.
#
# @example Usage
#   game_state = GameState.find(1)
#   GameStateProgressionService.new(game_state).next_generation!
class GameStateProgressionService
  # Represents a live cell in the game grid
  ALIVE = "*".freeze

  # Represents a dead cell in the game grid
  DEAD = ".".freeze

  # Offsets for the eight neighboring cells in a 2D grid
  NEIGHBOR_OFFSETS = [
    [ -1, -1 ], [ -1, 0 ], [ -1, 1 ],
    [ 0, -1 ],          [ 0, 1 ],
    [ 1, -1 ], [ 1, 0 ], [ 1, 1 ]
  ].freeze

  # Initializes the progression service with a game state.
  #
  # @param game_state [GameState] the game state to be progressed
  def initialize(game_state)
    @game_state = game_state
    @rows = game_state.rows
    @cols = game_state.cols
    @current_state = game_state.state
  end

  # Progresses the game state to the next generation and saves it.
  #
  # This method calculates the next generation based on Conway's Game of Life
  # rules and updates the state and generation count of the game.
  #
  # @return [void]
  def next_generation!
    validate_current_state!

    # Create an empty grid with DEAD cells for the next state
    next_state = Array.new(@rows) { Array.new(@cols, DEAD) }

    # Calculate the next state of each cell
    (0...@rows).each do |row|
      (0...@cols).each do |col|
        is_currently_alive = @current_state[row][col] == ALIVE
        neighbors = count_live_neighbors(row, col)

        next_state[row][col] = determine_next_cell_state(is_currently_alive, neighbors)
      end
    end

    # Update and save the game state transactionally
    GameState.transaction do
      @game_state.state = next_state
      @game_state.generation += 1
      @game_state.save!
    end

  rescue ActiveRecord::RecordInvalid => e
    # If save! fails due to ActiveRecord validations, raise a custom exception
    raise GameStateProgressionError, "Failed to save the game state: #{e.record.errors.full_messages.join(', ')}"
  rescue StandardError => e
    # Any other unexpected errors are encapsulated
    raise GameStateProgressionError, "Error while progressing to the next generation: #{e.message}"
  end

  private

  # Counts the number of live neighbors for a given cell.
  #
  # @param row [Integer] the row index of the cell
  # @param col [Integer] the column index of the cell
  #
  # @return [Integer] the number of live neighbors
  def count_live_neighbors(row, col)
    NEIGHBOR_OFFSETS.count do |row_offset, col_offset|
      valid_position?(row + row_offset, col + col_offset) &&
        @current_state[row + row_offset][col + col_offset] == ALIVE
    end
  end

  # Determines the next state of a cell based on its current state
  # and the number of live neighbors.
  #
  # @param is_alive [Boolean] whether the cell is currently alive
  # @param neighbors [Integer] the number of live neighbors
  #
  # @return [String] the next state of the cell ("*" for alive, "." for dead)
  def determine_next_cell_state(is_alive, neighbors)
    return ALIVE if is_alive && [ 2, 3 ].include?(neighbors)
    return ALIVE if !is_alive && neighbors == 3

    DEAD
  end

  # Checks if a given position is within the grid boundaries.
  #
  # @param row [Integer] the row index to check
  # @param col [Integer] the column index to check
  #
  # @return [Boolean] true if the position is valid, false otherwise
  def valid_position?(row, col)
    row.between?(0, @rows - 1) && col.between?(0, @cols - 1)
  end

  # Validates whether the current game state has the correct format before progressing.
  def validate_current_state!
    # Checks if the number of rows matches @rows
    unless @current_state.is_a?(Array) && @current_state.size == @rows
      raise GameStateProgressionError, "The number of rows does not match the expected #{@rows}"
    end

    # Checks if each row has the correct number of columns (@cols) and contains valid symbols
    @current_state.each_with_index do |row_array, i|
      unless row_array.is_a?(Array) && row_array.size == @cols
        raise GameStateProgressionError, "Row #{i} does not match the expected #{@cols} columns"
      end

      row_array.each_with_index do |cell, j|
        unless [ ALIVE, DEAD ].include?(cell)
          raise GameStateProgressionError, "Invalid cell at position (#{i},#{j}): #{cell.inspect}"
        end
      end
    end
  end
end
