defmodule Chess.BoardTest do
  use ExUnit.Case
  # doctest Chess.Board

  alias Chess.{Board, Piece}

  setup do
    board = Board.new()

    %{
      board: board,
      wqb_pawn: Board.get_piece(board, "c2")
    }
  end

  describe "new/0" do
    test "success return" do
      assert %Board{} = Board.new()
    end
  end

  describe "get_piece/2" do
    test "success", %{board: board} do
      assert %Piece{class: :rook} = Board.get_piece(board, "a1")
    end

    test "retuning nil.", %{board: board} do
      assert nil == Board.get_piece(board, "a0")

      assert nil == Board.get_piece(board, "a3")
    end
  end

  describe "en_passant_kill_position/3" do
    test "success", %{board: board, wqb_pawn: wqb_pawn} do
      board = Board.set_new_position(board, wqb_pawn, "c5")
      {_, board} = Board.move(board, "d7", "d5")
      assert "d5" = Board.en_passant_kill_position(board, Board.get_piece(board, "c5"), "d6")
    end

    test "failed", %{board: board, wqb_pawn: wqb_pawn} do
      board = Board.set_new_position(board, wqb_pawn, "c5")
      {_, board} = Board.move(board, "d7", "d6")
      {_, board} = Board.move(board, "d6", "d5")
      assert nil == Board.en_passant_kill_position(board, Board.get_piece(board, "c5"), "d6")
    end
  end
end
