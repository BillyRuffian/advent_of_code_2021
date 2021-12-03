values = File.readlines('input.txt').map(&:chomp)

## part 1

gamma = values
          .map(&:chars)
          .transpose
          .map(&:tally)
          .map { |digit| digit.max_by { |k,v| v } }
          .map(&:first)
          .join
          .to_i(2)

epsilon = gamma ^ ('1' * values.first.length).to_i(2)

puts gamma * epsilon

## part 2

def filter( values, high, ptr = 0)
  counter = values.map { |v| v[ptr] }.tally
  keep = if counter['0'] == counter['1']
           high ? '1' : '0'
         else
           if counter['0'] > counter['1']
              high ? '0' : '1'
           else
              high ? '1' : '0'
           end
         end

  filtered_values = values.select { |v| v[ptr] == keep }

  filtered_values.length == 1 ? filtered_values.first.to_i(2) : filter( filtered_values, high, ptr += 1 )
end

pp filter(values, true) * filter(values, false)
