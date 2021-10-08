defmodule Chess.Queen do
  @moduledoc false

  alias Chess.{Bishop, Board, Piece, Rook}

  def possible_positions(%Board{} = board, position, %Piece{} = piece) do
    Rook.possible_positions(board, position, piece) ++
      Bishop.possible_positions(board, position, piece)
  end
end
