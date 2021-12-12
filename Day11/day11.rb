require 'pastel'

values = File.readlines('input.txt', chomp: true)

class Day11
  attr_reader :octopii, :rows, :cols
  attr_accessor :flashes
  
  def initialize(values)
    @rows = values.length
    @cols = values.first.length
    @octopii = {}
    @flashes = 0

    values.each_with_index { |row, r_idx| row.chars.each_with_index { |val, c_idx| @octopii[[r_idx, c_idx]] = val.to_i } }
  end
  
  def part1
    draw
    100.times { tick; draw }
  end
  
  def part2
    counter = 1
    loop do
      break if octopii.values.all?(0)
      puts counter
      
      tick
      counter += 1
    end
  end
  
  def tick
    octopii.each_pair { |k,v| octopii[k] += 1 }
    flash
  end
  
  def flash
    flashed = []
    loop do
      powered_up = octopii.select { |_, v| v > 9 }
      
      powered_up.keys.each do |location|
        near_by = neighbours(location)
        octopii[location] = 0
        flashed << location
        near_by
          .filter { |near_location| !flashed.include?(near_location) }
          .each { |k|   octopii[k] += 1 }
  
      end
      break if powered_up.empty?
    end
        
    @flashes += flashed.count
    
  end
  
  def neighbours(location)
    r, c = location
    [[-1, -1], [-1,  0], [-1,  1],
     [ 0, -1], [ 0 , 0], [ 0,  1],
     [ 1, -1], [ 1,  0], [ 1,  1]].map { |dr, dc| [r + dr, c + dc] }
                                  .filter { |nr, nc| (0...rows).include?(nr) && (0...cols).include?(nc) }
                                  .filter { |nl| nl != location }
  end

  def draw
    pastel = Pastel.new
    puts "\e[H\e[2J"

    (0...rows).each do |r|
      (0...cols).each do |c|
        case octopii[[r,c]]
        when (1..5)
          print pastel.yellow(" #{octopii[[r,c]]} ")
        when (5..9)
          print pastel.yellow.bold(" #{octopii[[r,c]]} ")
        else
          print pastel.black.on_bright_yellow(" #{octopii[[r,c]]} ")
        end
      end
      puts
    end
    puts
    puts pastel.green("#{flashes} flashes")
#     sleep 5
  end

end
 


d = Day11.new(values)
d.part2

