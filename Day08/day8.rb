values = File.readlines('input.txt', chomp: true)

## part 1
output_values = values.map { |v| v.split( ' | ').last }

pp output_values
     .flat_map { |v| v.split(' ') }
     .count { |v| [2, 3, 4, 7].include?(v.length) }