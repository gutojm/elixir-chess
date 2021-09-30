defmodule King do
  def possible_positions(board,position,piece) do
    Board.possible_positions(:up,board,position,piece,1,[],0) ++
    Board.possible_positions(:right,board,position,piece,1,[],0) ++
    Board.possible_positions(:left,board,position,piece,1,[],0) ++
    Board.possible_positions(:down,board,position,piece,1,[],0) ++
    Board.possible_positions(:up_left,board,position,piece,1,[],0) ++
    Board.possible_positions(:up_right,board,position,piece,1,[],0) ++
    Board.possible_positions(:down_left,board,position,piece,1,[],0) ++
    Board.possible_positions(:down_right,board,position,piece,1,[],0)

    # falta o roque
  end
end
