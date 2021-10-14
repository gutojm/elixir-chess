defmodule Chess.Pawn do
  @moduledoc false

  alias Chess.Board
  alias Chess.Piece

  def en_passant_positions(%Board{} = board, position, %Piece{} = piece) do
    (Board.possible_straight_positions(:up_left, board, position, 1, :forbidden) ++
       Board.possible_straight_positions(:up_right, board, position, 1, :forbidden))
    |> Enum.filter(&(Board.en_passant_kill_position(board, piece, &1) != nil))
  end

  def possible_positions(%Board{} = board, position) do
    piece = Board.get_piece(board, position)
    max_iter = if piece.moved, do: 1, else: 2

    Board.possible_straight_positions(:up, board, position, max_iter, :forbidden) ++
      Board.possible_straight_positions(:up_left, board, position, 1, :mandatory) ++
      Board.possible_straight_positions(:up_right, board, position, 1, :mandatory) ++
      en_passant_positions(board, position, piece)
  end
end
