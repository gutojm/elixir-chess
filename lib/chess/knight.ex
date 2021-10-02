defmodule Chess.Knight do
  alias Chess.Board
  alias Chess.Piece

  defp check_position(%Board{} = board,position,color,deltax,deltay) do
    {status,new_p} = Board.new_position(position,color,deltax,deltay)

    if status == :ok do
      piece = Board.get_piece(board,new_p)

      if piece == nil do
        [new_p]
      else
        if piece.color != color do
          [new_p]
        else
          []
        end
      end
    else
      []
    end
  end

  def possible_positions(%Board{} = board,position,%Piece{} = piece) do
    check_position(board,position,piece.color,1,2) ++
    check_position(board,position,piece.color,2,1) ++
    check_position(board,position,piece.color,-1,2) ++
    check_position(board,position,piece.color,-2,1) ++
    check_position(board,position,piece.color,1,-2) ++
    check_position(board,position,piece.color,2,-1) ++
    check_position(board,position,piece.color,-1,-2) ++
    check_position(board,position,piece.color,-2,-1)
  end
end
