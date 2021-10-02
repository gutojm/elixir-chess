defmodule Chess.Pawn do
  alias Chess.Board
  alias Chess.Piece

  def possible_positions(%Board{} = board,position,%Piece{} = piece) do
    max_iter = if piece.moved, do: 1, else: 2
    Board.possible_positions(:up,board,position,piece,max_iter,[],0)

    # falta a morte em diagonal e não permitir matar em frente
  end
end
