defmodule Chess.King do
  @moduledoc false

  alias Chess.Board
  alias Chess.Piece

  def possible_positions(%Board{} = board, position, %Piece{} = piece) do
    Board.possible_positions(:up, board, position, piece, 1, [], 0) ++
      Board.possible_positions(:right, board, position, piece, 1, [], 0) ++
      Board.possible_positions(:left, board, position, piece, 1, [], 0) ++
      Board.possible_positions(:down, board, position, piece, 1, [], 0) ++
      Board.possible_positions(:up_left, board, position, piece, 1, [], 0) ++
      Board.possible_positions(:up_right, board, position, piece, 1, [], 0) ++
      Board.possible_positions(:down_left, board, position, piece, 1, [], 0) ++
      Board.possible_positions(:down_right, board, position, piece, 1, [], 0) ++
      Board.castling_positions(board, position, piece)

    # falta o roque
  end
end
