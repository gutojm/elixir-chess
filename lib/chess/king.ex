defmodule Chess.King do
  @moduledoc false

  alias Chess.Board

  def possible_positions(%Board{} = board, position) do
    piece = Board.get_piece(board, position)

    Board.possible_straight_positions(:up, board, position, 1) ++
      Board.possible_straight_positions(:right, board, position, 1) ++
      Board.possible_straight_positions(:left, board, position, 1) ++
      Board.possible_straight_positions(:down, board, position, 1) ++
      Board.possible_straight_positions(:up_left, board, position, 1) ++
      Board.possible_straight_positions(:up_right, board, position, 1) ++
      Board.possible_straight_positions(:down_left, board, position, 1) ++
      Board.possible_straight_positions(:down_right, board, position, 1) ++
      Board.castling_positions(board, position, piece)
  end
end
