defmodule Chess.Queen do
  @moduledoc false

  alias Chess.{Board}

  def possible_positions(%Board{} = board, position) do
    Board.possible_straight_positions(:up, board, position) ++
      Board.possible_straight_positions(:right, board, position) ++
      Board.possible_straight_positions(:left, board, position) ++
      Board.possible_straight_positions(:down, board, position) ++
      Board.possible_straight_positions(:up_left, board, position) ++
      Board.possible_straight_positions(:up_right, board, position) ++
      Board.possible_straight_positions(:down_left, board, position) ++
      Board.possible_straight_positions(:down_right, board, position)
  end
end
