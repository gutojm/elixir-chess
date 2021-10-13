defmodule Chess.Rook do
  @moduledoc """
  Rook module.
  """

  alias Chess.{Board, Piece}

  @doc """
  Return a list of possible positions for a given board, position
  """
  def possible_positions(%Board{} = board, position, %Piece{} = piece) do
    Board.possible_straight_positions(:up, board, position, piece, 0, [], 0) ++
      Board.possible_straight_positions(:right, board, position, piece, 0, [], 0) ++
      Board.possible_straight_positions(:left, board, position, piece, 0, [], 0) ++
      Board.possible_straight_positions(:down, board, position, piece, 0, [], 0)
  end
end
