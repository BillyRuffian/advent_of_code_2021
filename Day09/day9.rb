values = File.readlines('input.txt', chomp: true)

area = values.map { |row| row.chars.map(&:to_i) }


# part 1 - overcomplicated and ugly
# took an unreasonable amount of time to get rows / cols references the right way around


neighbours = -> (row, col) do
  coords = []
  coords << [row-1, col] if row > 0
  coords << [row, col-1] if col > 0
  coords << [row+1, col] if row < area.length-1
  coords << [row, col+1] if col < area.first.length-1

  coords
end

walk = -> (from_row, from_col) do
  lowest = neighbours.(from_row, from_col)
             .inject([from_row, from_col]) { |(r, c), (mr, mc)| area[r][c] < area[mr][mc] ? [r,c] : [mr, mc] }

  if area[lowest.first][lowest.last] < area[from_row][from_col]
    walk.(lowest.first, lowest.last)
  else
    [from_row, from_col]
  end
end


low_points = []
area.each_with_index do |row, row_idx|
  row.each_with_index do |cell, col_idx|
    next if cell == 9

    low_points << walk.(row_idx, col_idx)
  end
end

pp low_points
     .filter { |row, col| area[row][col] < 9}
     .uniq.sort
     .map { |row, col| area[row][col] + 1 }
     .sum


# part 2 - need a different approach
# let's leave the recursive lambda smart arsery behind and just loop

basins = Hash.new(0) # { |h, k| h[k] = Set.new }

area.each_with_index do |row, row_start_idx|
  row.each_with_index do |cell, col_start_idx|
    next if cell == 9

    current_cell = [row_start_idx, col_start_idx]
    while current_cell
      row_idx, col_idx = current_cell
      nearby = neighbours.(row_idx, col_idx)

      current_cell = nearby.filter { |r, c| area[r][c] < area[row_idx][col_idx] }.first
    end

    basins[[row_idx, col_idx]] += 1
  end
end

pp basins.values.max(3).inject(:*)