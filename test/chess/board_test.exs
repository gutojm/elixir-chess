defmodule Chess.BoardTest do
  use ExUnit.Case
  # doctest Chess.Board

  alias Chess.{Board, Piece}

  setup do
    board = Board.new()

    %{board: board}
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
end
