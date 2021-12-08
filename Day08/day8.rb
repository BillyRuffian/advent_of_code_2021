values = File.readlines('input.txt', chomp: true)

## part 1
output_values = values.map { |v| v.split( ' | ').last }

pp output_values
     .flat_map { |v| v.split(' ') }
     .count { |v| [2, 3, 4, 7].include?(v.length) }

## part 2
## this is so ugly it's painful

def segment_map(inputs, outputs)
  signals = inputs.map(&:chars).map(&:sort)
  segments = outputs.map(&:chars).map(&:sort)

  signal_1 = signals.filter { |s| s.length == 2 }.first
  signal_4 = signals.filter { |s| s.length == 4 }.first
  signal_7 = signals.filter { |s| s.length == 3 }.first
  signal_8 = signals.filter { |s| s.length == 7 }.first

  signal_3 = signals.filter { |s| s.length == 5 && s.intersection(signal_1) == signal_1 }.first
  signal_9 = signals.filter { |s| s.length == 6 && s.intersection(signal_3) == signal_3 }.first
  signal_0 = signals.filter { |s| s.length == 6 && s.intersection(signal_1) == signal_1 && s != signal_9}.first
  signal_6 = signals.filter { |s| s.length == 6 && ![signal_0, signal_9].include?(s)  }.first
  signal_5 = signals.filter { |s| signal_9.union & signal_6 == s }.first
  signal_2 = signals.filter { |s| s.length == 5 && ![signal_3, signal_5].include?(s) }.first

  segments.map do |value|
    case value
    when signal_0 then 0
    when signal_1 then 1
    when signal_2 then 2
    when signal_3 then 3
    when signal_4 then 4
    when signal_5 then 5
    when signal_6 then 6
    when signal_7 then 7
    when signal_8 then 8
    when signal_9 then 9
    end
  end
end

pp mapped = values
  .map { |v| v.split( ' | ') }
  .map { |inputs, outputs| [inputs.split, outputs.split] }
  .map { |inputs, outputs| segment_map(inputs, outputs) }
  .map(&:join)
  .map(&:to_i)
  .sum

# I'm glad that was over -- I'm not confident this works on every possible input and there
# has to be a better pattern matching way but my lunchtime is nearly over