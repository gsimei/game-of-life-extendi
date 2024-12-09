class GameStateUploadService
  def initialize(file_content)
    @file_content = file_content
    @lines = []
    @rows = nil
    @cols = nil
  end

  def call
    parse_file
    {
      generation: @generation, # Valor já obtido em parse_file
      rows: @rows,
      cols: @cols,
      state: parse_grid
    }
  end

  private

  # Divide o conteúdo do arquivo em linhas tratadas
  def parse_file
    @lines = @file_content.lines.map(&:strip).reject(&:empty?)
    raise "File is empty or invalid" if @lines.empty?

    # Primeiro, parseamos a geração
    parse_generation
    # Depois, parseamos as dimensões
    parse_dimensions
  end

  # Extrai a geração do arquivo
  def parse_generation
    unless @lines.first =~ /^Generation\s+(\d+):\s*$/
      raise "Missing or malformed generation line"
    end
    @generation = $1.to_i
    @lines.shift # Remove a linha processada
  end

  # Extrai as dimensões da matriz
  def parse_dimensions
    unless @lines.first =~ /^(\d+)\s+(\d+)$/
      raise "Missing or malformed dimensions line"
    end
    @rows, @cols = @lines.shift.split.map(&:to_i) # Remove a linha processada
  end

  # Converte as linhas restantes em uma matriz
  def parse_grid
    grid = @lines.map { |line| line.chars }
    validate_grid(grid)
    grid
  end

  # Validação para garantir que a matriz tem as dimensões corretas
  def validate_grid(grid)
    unless grid.size == @rows && grid.all? { |row| row.size == @cols }
      raise "Grid dimensions do not match the specified rows and columns"
    end
  end
end
