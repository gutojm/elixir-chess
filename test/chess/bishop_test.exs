defmodule Chess.BishopTest do
  use ExUnit.Case

  alias Chess.{Board, Bishop, Piece}

  setup do
    board = Board.new()

    %{
      board: board,
      wq_bishop: Board.get_piece(board, "c1")
    }
  end

  describe "possible_positions/3" do
    test "no possible move", %{board: board} do
      assert [] = Bishop.possible_positions(board, "a1")
    end

    test "all directions with kill and no kill", %{board: board, wq_bishop: wq_bishop} do
      board = Board.set_new_position(board, wq_bishop, "d5")

      assert [] =
               [
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
               ] -- Bishop.possible_positions(board, "d5")

      assert %Piece{color: :black} = Board.get_piece(board, "f7")
    end
  end
end
