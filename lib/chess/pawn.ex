defmodule Chess.Pawn do
  alias Chess.Board
  alias Chess.Piece

  def en_passant_positions(%Board{} = board, position, %Piece{} = piece) do
    (Board.possible_positions(:up_left, board, position, piece, 1, [], 0, :forbidden) ++
       Board.possible_positions(:up_right, board, position, piece, 1, [], 0, :forbidden))
    |> Enum.filter(&(Board.en_passant_kill_position(board, piece, &1) != nil))
  end

  def possible_positions(%Board{} = board, position, %Piece{} = piece) do
    max_iter = if piece.moved, do: 1, else: 2

    Board.possible_positions(:up, board, position, piece, max_iter, [], 0, :forbidden) ++
      Board.possible_positions(:up_left, board, position, piece, 1, [], 0, :mandatory) ++
      Board.possible_positions(:up_right, board, position, piece, 1, [], 0, :mandatory) ++
      en_passant_positions(board, position, piece)
  end
end
