defmodule Chess.KingTest do
  use ExUnit.Case

  alias Chess.{Board, King}

  setup do
    board = Board.new()

    %{
      board: board,
      w_king: Board.get_piece(board, "e1"),
      b_king: Board.get_piece(board, "e8"),
      bk_bishop: Board.get_piece(board, "f8"),
      bk_knight: Board.get_piece(board, "g8")
    }
  end

  describe "possible_positions/3" do
    test "no move", %{
      board: board
    } do
      assert [] = King.possible_positions(board, "e1")
    end

    test "all directions with block", %{
      board: board,
      w_king: w_king
    } do
      board = Board.set_new_position(board, w_king, "e3")

      assert [] = ["d3", "f3", "d4", "e4", "f4"] -- King.possible_positions(board, "e3")
    end

    test "all directions with kill", %{
      board: board,
      w_king: w_king
    } do
      board = Board.set_new_position(board, w_king, "e6")

      assert [] =
               ["d5", "e5", "f5", "d6", "f6", "d7", "e7", "f7"] --
                 King.possible_positions(board, "e6")
    end

    test "short castling", %{
      board: board,
      bk_bishop: bk_bishop,
      bk_knight: bk_knight
    } do
      board = Board.set_new_position(board, bk_bishop, "a3")
      board = Board.set_new_position(board, bk_knight, "b3")

      assert [] = ["f8", "g8"] -- King.possible_positions(board, "e8")
    end

    test "failed short castling", %{
      board: board,
      b_king: b_king,
      bk_bishop: bk_bishop,
      bk_knight: bk_knight
    } do
      positions =
        board
        |> Board.set_new_position(bk_bishop, "a3")
        |> Board.set_new_position(bk_knight, "b3")
        # apenas para setar o status de moved da peça
        |> Board.set_new_position(b_king, "e8")
        |> King.possible_positions("e8")

      assert [] = ["f8"] -- positions
    end
  end
end
