# GameStateUploadService is responsible for processing the uploaded game state file.
# It parses the file content to extract the generation, dimensions, and state of the game.
class GameStateUploadService
  # Initializes the service with the given file content.
  #
  # @param file_content [String] the content of the uploaded file
  def initialize(file_content)
    @file_content = file_content
    @lines = []
    @grid_rows = nil
    @grid_cols = nil
  end

  # Processes the file content to parse game state attributes.
  #
  # @return [Hash] A hash containing:
  #   - :generation [Integer] The generation number.
  #   - :rows [Integer] The number of rows in the grid.
  #   - :cols [Integer] The number of columns in the grid.
  #   - :state [Array<Array<String>>] The grid represented as an array of rows.
  def call
    parse_file
    {
      generation: @generation,
      rows: @grid_rows,
      cols: @grid_cols,
      state: parse_grid
    }
  end

  private

  # Splits the file content into processed lines.
  #
  # @return [void]
  # @raise [StandardError] if the file is empty or invalid
  def parse_file
    @lines = @file_content.lines.map(&:strip).reject(&:empty?)
    raise "File is empty or invalid" if @lines.empty?

    parse_generation
    parse_dimensions
  end

  # Extracts the generation from the file.
  #
  # @return [void]
  # @raise [StandardError] if the generation line is missing or malformed
  def parse_generation
    unless @lines.first =~ /^Generation\s+(\d+):\s*$/
      raise "Missing or malformed generation line"
    end
    @generation = $1.to_i
    @lines.shift
  end

  # Extracts the dimensions of the grid from the file.
  #
  # @return [void]
  # @raise [StandardError] if the dimensions line is missing or malformed
  def parse_dimensions
    unless @lines.first =~ /^(\d+)\s+(\d+)$/
      raise "Missing or malformed dimensions line"
    end
    @grid_rows, @grid_cols = @lines.shift.split.map(&:to_i)
  end

  # Converts the remaining lines into a grid.
  #
  # @return [Array<Array<String>>] the parsed grid
  # @raise [StandardError] if the grid dimensions do not match the specified rows and columns
  def parse_grid
    grid = @lines.map { |line| line.chars }
    validate_grid(grid)
    grid
  end

  # Validates that the grid has the correct dimensions.
  #
  # @param grid [Array<Array<String>>] the grid to validate
  # @return [void]
  # @raise [StandardError] if the grid dimensions do not match the specified rows and columns
  def validate_grid(grid)
    unless grid.size == @grid_rows && grid.all? { |row| row.size == @grid_cols }
      raise "Grid dimensions do not match the specified rows and columns"
    end
  end
end
