values = File.readlines('input.txt')
instructions = values.map(&:split).map { |d, q| [d, q.to_i] } 

## part 1

horiz, depth = 0, 0

instructions.each do |instruction|
  
  case instruction
  in 'forward', val
    horiz += val
  in 'up', val
    depth -= val
  in 'down', val
    depth += val
  end

end

pp depth * horiz

## part 2

horiz, depth, aim = 0, 0, 0

instructions.each do |instruction|
  
  case instruction
  in 'forward', val
    horiz += val
    depth += (val * aim)
  in 'up', val
    aim -= val
  in 'down', val
    aim += val
  end

end

pp depth * horiz