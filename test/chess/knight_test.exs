defmodule Chess.KnightTest do
  use ExUnit.Case

  alias Chess.{Board, Knight}

  setup do
    board = Board.new()
    wq_knight = Board.get_piece(board, "b1")
    bk_knight = Board.get_piece(board, "g8")

    %{
      board: board,
      wq_knight: wq_knight,
      bk_knight: bk_knight
    }
  end

  defp move_and_test(%Board{} = board, from, to, positions) do
    {_, board} = Board.move(board, from, to)
    piece = Board.get_piece(board, to)
    {board, [] == positions -- Knight.possible_positions(board, to, piece)}
  end

  describe "possible_positions/3" do
    test "movement test", %{
      board: board,
      wq_knight: wq_knight,
      bk_knight: bk_knight
    } do
      # white
      assert [] = ["a3", "c3"] -- Knight.possible_positions(board, "b1", wq_knight)

      assert {board, true} = move_and_test(board, "b1", "c3", ["a4", "e4", "b5", "d5"])

      assert {board, true} =
               move_and_test(board, "c3", "d5", ["c3", "e3", "b4", "f4", "b6", "f6", "c7", "e7"])

      # black
      assert [] = ["f6", "h6"] -- Knight.possible_positions(board, "g8", bk_knight)

      assert {board, true} = move_and_test(board, "g8", "h6", ["f5", "g4"])

      assert {_, true} = move_and_test(board, "h6", "g4", ["f6", "h6", "e5", "e3", "f2", "h2"])
    end
  end
end
