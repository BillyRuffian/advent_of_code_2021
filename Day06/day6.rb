values = File.readlines('input.txt', chomp: true)

fish = values.first.split(',').map(&:to_i).tally
fish.default = 0


# part 1 & part 2

[80, 256].each do |days|

  fishes = fish.clone

  days.times do 

    fishes.transform_keys! { |key| key -= 1 }

    fishes[6] += fishes[-1]
    fishes[8] += fishes[-1]
    fishes.delete(-1)

  end

  pp fishes.values.sum
end
