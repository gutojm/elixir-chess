defmodule Queen do
  def possible_positions(board,position,piece) do
    Rook.possible_positions(board,position,piece) ++
    Bishop.possible_positions(board,position,piece)
  end
end
