values = File.readlines('input.txt').map(&:chomp)

draws = values.shift.split(',').map(&:to_i)
boards = values.each_slice(6).map do |slice|
           slice[1,5].map { |row| row.split.map(&:to_i) }
         end

# pp draws

has_won = ->(board) { (board + board.transpose).any? { |row| row.all? { |col| col == -1 } } }
sum = -> (board) { board.flatten.filter { |v| v != -1 }.sum }

## part 1

score = catch(:won) do
  draws.each do |draw|
    boards.each do |board|
      board.each_with_index do |row, row_idx|
        row.each_with_index do |col, col_idx|
          board[row_idx][col_idx] = -1 if col == draw
          throw :won, sum.(board) * draw if has_won.(board)
        end
      end
    end
  end
end

pp score

## part 2

score = catch(:last) do
  draws.each do |draw|
    boards.clone.each_with_index do |board, board_idx|
      board.each_with_index do |row, row_idx|
        row.each_with_index do |col, col_idx|
          board[row_idx][col_idx] = -1 if col == draw
          winner = boards.delete(board) if has_won.(board)
          throw :last, sum.(winner) * draw if winner && boards.count.zero?
        end
      end
    end
  end
end

pp score