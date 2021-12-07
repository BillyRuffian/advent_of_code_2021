values = File.readlines('input.txt', chomp: true)

crabs = values.first.split(',').map(&:to_i)

## part 1

def median(values)
  elements = values.count
  sorted_values = values.sort
  centre = elements / 2
  elements.odd? ? sorted_values[centre] : (sorted_values[centre-1] + sorted_values[centre]) / 2
end

median_position = median(crabs)

pp crabs
     .map { |c| (c - median_position).abs }
     .sum

