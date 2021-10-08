defmodule Chess.QueenTest do
  use ExUnit.Case

  alias Chess.{Board, Queen}

  setup do
    board = Board.new()
    w_queen = Board.get_piece(board, "d1")

    %{
      board: board,
      w_queen: w_queen
    }
  end

  describe "possible_positions/3" do
    test "no possible move", %{board: board, w_queen: w_queen} do
      assert [] = Queen.possible_positions(board, "d1", w_queen)
    end

    test "all directions with kill and no kill", %{board: board, w_queen: w_queen} do
      board = Board.set_new_position(board, w_queen, "d5")

      assert [] =
               [
                 "d3", # verticais
                 "d4",
                 "d6",
                 "d7", # morte
                 "a5", # horizontais
                 "b5",
                 "c5",
                 "e5",
                 "f5",
                 "h5",
                 "e6", # diagonal ur
                 "f7", # kill
                 "c6", # diagonal ul
                 "b7", # kill
                 "e4", # diagonal dr
                 "f3",
                 "c4", # diagonal dl
                 "b3"
               ] -- Queen.possible_positions(board, "d5", w_queen)
    end
  end

end
