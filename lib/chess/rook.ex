defmodule Chess.Rook do
  alias Chess.Board
  alias Chess.Piece

  def possible_positions(%Board{} = board, position, %Piece{} = piece) do
    Board.possible_positions(:up, board, position, piece, 0, [], 0) ++
      Board.possible_positions(:right, board, position, piece, 0, [], 0) ++
      Board.possible_positions(:left, board, position, piece, 0, [], 0) ++
      Board.possible_positions(:down, board, position, piece, 0, [], 0)
  end
end
