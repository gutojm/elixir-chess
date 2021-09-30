defmodule Pawn do
  def possible_positions(board,position,piece) do
    max_iter = if piece.moved, do: 1, else: 2
    Board.possible_positions(:up,board,position,piece,max_iter,[],0)
  end
end
