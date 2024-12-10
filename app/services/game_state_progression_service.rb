class GameStateProgressionService
  def initialize(game_state)
    @game_state = game_state
    @rows = game_state.rows
    @cols = game_state.cols
    @current_state = game_state.state
  end

  def next_generation!
    next_state = Array.new(@rows) { Array.new(@cols, ".") }

    (0...@rows).each do |row|
      (0...@cols).each do |col|
        is_currently_alive = (@current_state[row][col] == "*")
        number_of_live_neighbors = count_live_neighbors(row, col)

        next_state[row][col] = determine_next_cell_state(is_currently_alive, number_of_live_neighbors)
      end
    end

    @game_state.state = next_state
    @game_state.generation += 1
    @game_state.save!
  end

  private

  def count_live_neighbors(row, col)
    neighbors = [ -1, 0, 1 ]
    live_neighbor_count = 0

    neighbors.each do |row_offset|
      neighbors.each do |col_offset|
        next if row_offset == 0 && col_offset == 0

        neighboring_row = row + row_offset
        neighboring_column = col + col_offset

        if neighboring_row.between?(0, @rows - 1) && neighboring_column.between?(0, @cols - 1)
          live_neighbor_count += 1 if @current_state[neighboring_row][neighboring_column] == "*"
        end
      end
    end

    live_neighbor_count
  end

  def determine_next_cell_state(is_currently_alive, number_of_live_neighbors)
    if is_currently_alive
      (number_of_live_neighbors == 2 || number_of_live_neighbors == 3) ? "*" : "."
    else
      (number_of_live_neighbors == 3) ? "*" : "."
    end
  end
end
