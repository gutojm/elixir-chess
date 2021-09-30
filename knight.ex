defmodule Knight do
  defp check_position(board,position,color,deltax,deltay) do
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

  def possible_positions(board,position,piece) do
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
