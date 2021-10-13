defmodule Chess.Bishop do
  @moduledoc false

  alias Chess.Board
  alias Chess.Piece

  def possible_positions(%Board{} = board, position, %Piece{} = piece) do
    Board.possible_straight_positions(:up_left, board, position, piece, 0, [], 0) ++
      Board.possible_straight_positions(:up_right, board, position, piece, 0, [], 0) ++
      Board.possible_straight_positions(:down_left, board, position, piece, 0, [], 0) ++
      Board.possible_straight_positions(:down_right, board, position, piece, 0, [], 0)
  end
end
