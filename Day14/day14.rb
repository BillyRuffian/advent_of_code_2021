data = File.read('input.txt')

pattern, translation_rules = data.split("\n\n")
translations = translation_rules.split("\n").map { |r| r.split(' -> ') }.to_h




[10, 40].each_with_index do |count, part|
  pairs = Hash.new(0)

  (0...pattern.length-1).each do |i|
    pairs[pattern[i,2]] += 1
  end

  count.times do

    new_pairs = Hash.new(0)

    pairs.clone.keys.each do |k|
      pair_count = pairs[k]
      trans = translations[k]
      first, second = k.chars

      puts "!!!!" if trans.nil?

      new_pairs["#{first}#{trans}"] += pair_count
      new_pairs["#{trans}#{second}"] += pair_count
    end

    pairs = new_pairs

  end


  letters = Hash.new(0)
  pairs.each_pair do |pair, count|
    letters[pair[0]] += count 
  end

  letters_ary = letters.to_a

  puts "Part #{part+1}"
  max = letters_ary.max { |a,b| a.last <=> b.last }.last + 1
  min = letters_ary.max { |a,b| b.last <=> a.last }.last
  puts "max #{max} : min #{min} = #{max - min}"

end