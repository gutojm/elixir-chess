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
    test "no possible move", %{board: board} do
      assert [] = Queen.possible_positions(board, "d1")
    end

    test "all directions with kill and no kill", %{board: board, w_queen: w_queen} do
      board = Board.set_new_position(board, w_queen, "d5")

      assert [] =
               [
                 # verticais
                 "d3",
                 "d4",
                 "d6",
                 # morte
                 "d7",
                 # horizontais
                 "a5",
                 "b5",
                 "c5",
                 "e5",
                 "f5",
                 "h5",
                 # diagonal ur
                 "e6",
                 # kill
                 "f7",
                 # diagonal ul
                 "c6",
                 # kill
                 "b7",
                 # diagonal dr
                 "e4",
                 "f3",
                 # diagonal dl
                 "c4",
                 "b3"
               ] -- Queen.possible_positions(board, "d5")
    end
  end
end
