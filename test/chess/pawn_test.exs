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
      wqb_pawn: wqb_pawn,
      wq_pawn: wq_pawn
    } do
      board = Board.set_new_position(board, wq_pawn, "c3")
      assert [] = Pawn.possible_positions(board, "c2", wqb_pawn)
    end

    test "no possible move enemy piece in front of", %{
      board: board,
      wqb_pawn: wqb_pawn,
      bq_pawn: bq_pawn
    } do
      board = Board.set_new_position(board, bq_pawn, "c3")
      assert [] = Pawn.possible_positions(board, "c2", wqb_pawn)
    end

    test "first move white piece and kill in diagonal", %{
      board: board,
      wq_pawn: wq_pawn,
      bq_pawn: bq_pawn
    } do
      board = Board.set_new_position(board, bq_pawn, "e3")
      assert [] = ["d3", "d4", "e3"] -- Pawn.possible_positions(board, "d2", wq_pawn)
    end

    test "first move black piece and kill in diagonal", %{
      board: board,
      bq_pawn: bq_pawn,
      wq_pawn: wq_pawn
    } do
      board = Board.set_new_position(board, wq_pawn, "e6")
      assert [] = ["d6", "d5", "e6"] -- Pawn.possible_positions(board, "d7", bq_pawn)
    end

    test "en passant kill", %{board: board, wqb_pawn: wqb_pawn} do
      board = Board.set_new_position(board, wqb_pawn, "c5")
      {_, board} = Board.move(board, "d7", "d5")
      assert [] = ["c6", "d6"] -- Pawn.possible_positions(board, "c5", wqb_pawn)
    end
  end
end
