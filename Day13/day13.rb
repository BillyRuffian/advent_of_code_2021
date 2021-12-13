
class Day13

  attr_accessor :coords, :instructions, :grid

  def initialize
    @coords = []
    @instructions = []
    @grid = []
    parse
    format_grid
  end

  def parse
    File.foreach('input.txt', chomp: true) do |line|
      next if line.empty? 

      if line.match?(/\d+,\d+/)
        line.split(',').map(&:to_i).then { |x,y| coords << [y,x] }
      elsif
        matches = /fold along (x|y)=(\d+)/.match(line)
        instructions << [matches[1], matches[2].to_i] if matches
      end
    end
  end

  def format_grid
    max_x = instructions.filter { |orientation, _| orientation == 'x' }.map { |_, v| v }.max * 2 
    max_y = instructions.filter { |orientation, _| orientation == 'y' }.map { |_, v| v }.max * 2 

    (0..max_y).each do |y|
      @grid[y] ||= []
      (0..max_x).each do |x|
        @grid[y][x] = ' '
      end
    end

    coords.each { |y, x| grid[y][x] = '#' }
  end

  def fold_all
    while !instructions.empty?
      fold
    end
    display
  end

  def fold
    orientation, location = instructions.shift

    if orientation == 'x'
      fold_x(location)
    else
      fold_y(location)
    end
  end

  def fold_y(location)
    max_y = grid.length - 1
    max_x = grid.first.length - 1
    ((location+1)..max_y).each do |y|
      (0..max_x).each do |x|
        grid[max_y-y][x] = '#' if grid[y][x] == '#'
      end
    end

    @grid = grid[0, location]
  end

  def fold_x(location)
    max_y = grid.length - 1
    max_x = grid.first.length - 1

    (0..max_y).each do |y|
      ((location+1)..max_x).each do |x|
        grid[y][max_x-x] = '#' if grid[y][x] == '#' 
      end

      grid[y] = grid[y][0, location]
    end
  end

  def dots
    puts grid.flatten.count('#')
  end

  def display
    puts 
    grid.each { |r| puts r.join }
  end

end

## part 1

d = Day13.new
d.fold

puts d.dots

## part 2

d.fold_all