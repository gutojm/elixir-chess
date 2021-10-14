defmodule Chess.RookTest do
  use ExUnit.Case

  alias Chess.{Board, Rook}

  setup do
    board = Board.new()
    wq_rook = Board.get_piece(board, "a1")
    wqr_pawn = Board.get_piece(board, "a2")
    bk_rook = Board.get_piece(board, "h8")
    bkr_pawn = Board.get_piece(board, "h8")

    %{
      board: board,
      wq_rook: wq_rook,
      wqr_pawn: wqr_pawn,
      bk_rook: bk_rook,
      bkr_pawn: bkr_pawn
    }
  end

  describe "possible_positions/3" do
    test "no possible move", %{board: board} do
      assert [] = Rook.possible_positions(board, "a1")
    end

    test "possible forward no kill", %{board: board, wqr_pawn: wqr_pawn} do
      board = Board.set_new_position(board, wqr_pawn, "a5")

      assert [] = ["a2", "a3", "a4"] -- Rook.possible_positions(board, "a1")
    end

    test "possible forward with kill", %{board: board, wqr_pawn: wqr_pawn} do
      board = Board.set_new_position(board, wqr_pawn, "b3")

      assert [] =
               ["a2", "a3", "a4", "a5", "a6", "a7"] --
                 Rook.possible_positions(board, "a1")
    end

    test "all directions with kill and no kill", %{board: board, wq_rook: wq_rook} do
      board = Board.set_new_position(board, wq_rook, "d5")

      assert [] =
               [
                 "d3",
                 "d4",
                 "d6",
                 "d7",
                 "a5",
                 "b5",
                 "c5",
                 "e5",
                 "f5",
                 "h5"
               ] -- Rook.possible_positions(board, "d5")
    end
  end
end
