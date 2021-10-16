defmodule Chess.PawnTest do
  use ExUnit.Case

  alias Chess.{Board, Pawn}

  setup do
    board = Board.new()
    wqb_pawn = Board.get_piece(board, "c2")
    wq_pawn = Board.get_piece(board, "d2")
    bq_pawn = Board.get_piece(board, "d7")

    %{
      board: board,
      wqb_pawn: wqb_pawn,
      wq_pawn: wq_pawn,
      bq_pawn: bq_pawn
    }
  end

  describe "possible_positions/3" do
    test "no possible move friendly piece in front of", %{
      board: board,
      wq_pawn: wq_pawn
    } do
      board = Board.set_new_position(board, wq_pawn, "c3")
      assert [] = Pawn.possible_positions(board, "c2")
    end

    test "no possible move enemy piece in front of", %{
      board: board,
      bq_pawn: bq_pawn
    } do
      board = Board.set_new_position(board, bq_pawn, "c3")
      assert [] = Pawn.possible_positions(board, "c2")
    end

    test "first move white piece and kill in diagonal", %{
      board: board,
      bq_pawn: bq_pawn
    } do
      board = Board.set_new_position(board, bq_pawn, "e3")
      assert [] = ["d3", "d4", "e3"] -- Pawn.possible_positions(board, "d2")
    end

    test "first move black piece and kill in diagonal", %{
      board: board,
      wq_pawn: wq_pawn
    } do
      board = Board.set_new_position(board, wq_pawn, "e6")
      assert [] = ["d6", "d5", "e6"] -- Pawn.possible_positions(board, "d7")
    end

    test "en passant kill", %{board: board, wqb_pawn: wqb_pawn} do
      board = Board.set_new_position(board, wqb_pawn, "c5")
      {_, board} = Board.move(board, "d7", "d5")
      assert [] = ["c6", "d6"] -- Pawn.possible_positions(board, "c5")
    end
  end

  describe "en_passant_kill_position/3" do
    test "success", %{board: board, wqb_pawn: wqb_pawn} do
      board = Board.set_new_position(board, wqb_pawn, "c5")
      {_, board} = Board.move(board, "d7", "d5")
      assert "d5" = Pawn.en_passant_kill_position(board, Board.get_piece(board, "c5"), "d6")
    end

    test "failed", %{board: board, wqb_pawn: wqb_pawn} do
      board = Board.set_new_position(board, wqb_pawn, "c5")
      {_, board} = Board.move(board, "d7", "d6")
      {_, board} = Board.move(board, "d6", "d5")
      assert nil == Pawn.en_passant_kill_position(board, Board.get_piece(board, "c5"), "d6")
    end
  end
end
