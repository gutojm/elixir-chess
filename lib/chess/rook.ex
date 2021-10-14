defmodule Chess.Rook do
  @moduledoc """
  Rook module.
  """

  alias Chess.{Board}

  @doc """
  Return a list of possible positions for a given board, position
  """
  def possible_positions(%Board{} = board, position) do
    Board.possible_straight_positions(:up, board, position) ++
      Board.possible_straight_positions(:right, board, position) ++
      Board.possible_straight_positions(:left, board, position) ++
      Board.possible_straight_positions(:down, board, position)
  end
end
