values = File.readlines('input.txt', chomp: true)

closing_pairs = {
  ')' => '(',
  ']' => '[',
  '}' => '{',
  '>' => '<',
}

opening_pairs = closing_pairs.invert

scores = {
  ')' => 3,
  ']' => 57,
  '}' => 1197,
  '>' => 25137,
}

openers = closing_pairs.values
closers = closing_pairs.keys

## part 1

acc = 0

values.each_with_index do |line, line_idx|
  # puts "\nLINE #{line}"
  stack = []
  line.chars.each_with_index do |bracket, pos_idx|
    # puts stack.join
    if openers.include?(bracket)
      stack << bracket
    else
      head = stack.pop
      if head != closing_pairs[bracket]
        # puts "#{line_idx+1}: char #{pos_idx+1}: #{head} did not match '#{bracket}'"
        acc += scores[bracket]
        break
      end
    end
  end
end


puts acc

closing_scores = {
  ')' => 1,
  ']' => 2,
  '}' => 3,
  '>' => 4,
}

## part 2

incomplete = -> (line) do
  stack = []
  line.chars.each_with_index do |bracket, pos_idx|
    if openers.include?(bracket)
      stack << bracket
    else
      head = stack.pop
      if head != closing_pairs[bracket]
        return nil
      end
    end
  end
  stack
end



pp values
     .map { |l| incomplete.(l) }
     .compact
     .tap { pp _1 }
     .map { |l| l.map { |b| opening_pairs[b] } }
     .map { |l| l.map { |b| closing_scores[b] }.reverse }
     .tap { pp _1 }
     .map { |l| l.inject(0) { |memo, s|  (5 * memo) + s } }
     .sort
     .then { |arr| arr[arr.length/2] }

