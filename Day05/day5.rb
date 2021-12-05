values = File.readlines('input.txt', chomp: true)

directions = values
               .map(&:split)
               .map { |start, *, stop| [start, stop] }
               .map { |start, stop| [start.split(',').map(&:to_i), stop.split(',').map(&:to_i)] }

def coordinates(x1, y1, x2, y2)
    dx = x2 <=> x1
    dy = y2 <=> y1

    if dx == 0
      y1.step(y2, dy).map { |y| [x1, y] }
    elsif dy == 0
      x1.step(x2, dx).map { |x| [x, y1] }
    else
      # part 2
      x1.step(x2,dx).zip(y1.step(y2, dy))
    end
end

pp directions
     .flat_map { |start, stop| coordinates(*start, *stop) }
     .tally
     .values
     .count { |v| v > 1 } 

