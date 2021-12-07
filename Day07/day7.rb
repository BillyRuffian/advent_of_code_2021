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

## part 2

## so aparently I need triangular numbers
## take this as a reference: https://www.mathsisfun.com/algebra/triangular-numbers.html
## First one, I'm not confident in my approach, let's have a go

def triangle(number)= number * (number+1) / 2
triangles = Hash.new { |h, k| h[k] = triangle(k) } # caching might be nice

pp crabs
    .min
    .upto(crabs.max).map { |value| crabs.map { |c| triangles[(c - value).abs] }.sum }
    .min

## oh, that worked, waddyaknow