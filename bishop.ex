defmodule Bishop do
  def possible_positions(board,position,piece) do
    Board.possible_positions(:up_left,board,position,piece,0,[],0) ++
    Board.possible_positions(:up_right,board,position,piece,0,[],0) ++
    Board.possible_positions(:down_left,board,position,piece,0,[],0) ++
    Board.possible_positions(:down_right,board,position,piece,0,[],0)
  end
end
