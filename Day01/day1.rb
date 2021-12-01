values = File.open('input.txt', 'r').read.split("\n")

## part 1

pp values
     .map(&:to_i)
     .each_cons(2)
     .inject(0) { |memo, (first, second)| second > first ? memo + 1 : memo }


## part 2

pp values
     .map(&:to_i)
     .each_cons(3)
     .each_cons(2)
     .inject(0) { |memo, (first, second)| second.sum > first.sum ? memo + 1 : memo}
