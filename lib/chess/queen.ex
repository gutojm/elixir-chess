defmodule Chess.Queen do
  alias Chess.Rook
  alias Chess.Bishop
  alias Chess.Board
  alias Chess.Piece

  def possible_positions(%Board{} = board,position,%Piece{} = piece) do
    Rook.possible_positions(board,position,piece) ++
    Bishop.possible_positions(board,position,piece)
  end
end
