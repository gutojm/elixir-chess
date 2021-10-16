defmodule Chess.BoardTest do
  use ExUnit.Case
  # doctest Chess.Board

  alias Chess.{Board, Piece}

  setup do
    board = Board.new()

    %{
      board: board,
      wqb_pawn: Board.get_piece(board, "c2"),
      w_queen: Board.get_piece(board, "d1"),
      bqb_pawn: Board.get_piece(board, "c7")
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

  test "position_2_xy/1" do
    assert {0, 0} = Board.position_2_xy("a1")
    assert {7, 7} = Board.position_2_xy("h8")
  end

  test "xy_2_position/1" do
    assert "a1" = Board.xy_2_position({0, 0})
    assert "h8" = Board.xy_2_position({7, 7})
  end

  test "absolute_deltas/2" do
    assert {0, 0} = Board.absolute_deltas("a1", "a1")
    assert {2, 0} = Board.absolute_deltas("a1", "c1")
    assert {2, 0} = Board.absolute_deltas("c1", "a1")
    assert {2, 2} = Board.absolute_deltas("c3", "a1")
  end

  test "new_position/4" do
    assert {:ok, "b2"} = Board.new_position("a1", :white, 1, 1)
    assert {:invalid_position, "a1"} = Board.new_position("a1", :black, 1, 1)
    assert {:ok, "g7"} = Board.new_position("h8", :black, 1, 1)
    assert {:invalid_position, "h8"} = Board.new_position("h8", :white, 1, 1)
  end

  test "new_position/3" do
    assert {:ok, "b2"} = Board.new_position("a1", 1, 1)
    assert {:invalid_position, "a1"} = Board.new_position("a1", -1, -1)
    assert {:ok, "g7"} = Board.new_position("h8", -1, -1)
    assert {:invalid_position, "h8"} = Board.new_position("h8", 1, 1)
  end

  describe "possible_positions/2" do
    test "empty position", %{board: board} do
      assert [] = Board.possible_positions(board, "a3")
    end

    # desnecessário testar todos os movimentos de cada classe de peça uma vez que cada
    # um possui seus testes individuais
    test "pawn", %{board: board} do
      assert [] = ["a3", "a4"] -- Board.possible_positions(board, "a2")
    end
  end

  describe "possible_straight_positions/2" do
    test "all directions no limit", %{board: board, w_queen: w_queen} do
      board = Board.set_new_position(board, w_queen, "d5")

      assert [] = ["d6", "d7"] -- Board.possible_straight_positions(:up, board, "d5")
      assert [] = ["c6", "b7"] -- Board.possible_straight_positions(:up_left, board, "d5")
      assert [] = ["e6", "f7"] -- Board.possible_straight_positions(:up_right, board, "d5")
      assert [] = ["d4", "d3"] -- Board.possible_straight_positions(:down, board, "d5")
      assert [] = ["c4", "b3"] -- Board.possible_straight_positions(:down_left, board, "d5")
      assert [] = ["e4", "f3"] -- Board.possible_straight_positions(:down_right, board, "d5")
      assert [] = ["a5", "b5", "c5"] -- Board.possible_straight_positions(:left, board, "d5")

      assert [] =
               ["e5", "f5", "g5", "h5"] -- Board.possible_straight_positions(:right, board, "d5")
    end

    test "all directions with limit", %{board: board, w_queen: w_queen} do
      board = Board.set_new_position(board, w_queen, "d5")

      assert [] = ["d6"] -- Board.possible_straight_positions(:up, board, "d5", 1)
      assert [] = ["c6"] -- Board.possible_straight_positions(:up_left, board, "d5", 1)
      assert [] = ["e6"] -- Board.possible_straight_positions(:up_right, board, "d5", 1)
      assert [] = ["d4"] -- Board.possible_straight_positions(:down, board, "d5", 1)
      assert [] = ["c4"] -- Board.possible_straight_positions(:down_left, board, "d5", 1)
      assert [] = ["e4"] -- Board.possible_straight_positions(:down_right, board, "d5", 1)
      assert [] = ["c5"] -- Board.possible_straight_positions(:left, board, "d5", 1)
      assert [] = ["e5"] -- Board.possible_straight_positions(:right, board, "d5", 1)
    end

    test "with mandatory kill", %{board: board, w_queen: w_queen, bqb_pawn: bqb_pawn} do
      board = Board.set_new_position(board, w_queen, "d5")
      board = Board.set_new_position(board, bqb_pawn, "d6")

      assert [] = ["d6"] -- Board.possible_straight_positions(:up, board, "d5", 0, :mandatory)
      assert [] = Board.possible_straight_positions(:up_left, board, "d5", 0, :mandatory)
    end

    test "with forbidden kill", %{board: board, w_queen: w_queen, bqb_pawn: bqb_pawn} do
      board = Board.set_new_position(board, w_queen, "d5")
      board = Board.set_new_position(board, bqb_pawn, "d6")

      assert [] = Board.possible_straight_positions(:up, board, "d5", 0, :forbidden)

      assert [] =
               ["c6"] -- Board.possible_straight_positions(:up_left, board, "d5", 0, :forbidden)
    end
  end

  describe "set_new_position/3" do
    test "success", %{board: board, w_queen: w_queen} do
      board = Board.set_new_position(board, w_queen, "d5")
      piece = Board.get_piece(board, "d5")
      assert %Piece{type: :queen, color: :white, position: "d5"} = piece
    end
  end

  defp move_and_test(board, from, to, move_count \\ 0) do
    {status, board} = Board.move(board, from, to)
    {status, board, Board.get_piece(board, to), move_count + 1}
  end

  test "move/3", %{board: board} do
    assert {:not_allowed, board, %Piece{color: :white, class: :pawn}, _} =
             move_and_test(board, "a1", "a2")

    # white queen pawn
    assert {:ok, board, %Piece{color: :white, class: :pawn}, move_count} =
             move_and_test(board, "d2", "d4")

    # black king pawn
    assert {:ok, board, %Piece{color: :black, class: :pawn}, move_count} =
             move_and_test(board, "e7", "e5", move_count)

    # kill
    assert {:ok, board, %Piece{color: :white, class: :pawn}, move_count} =
             move_and_test(board, "d4", "e5", move_count)

    # white queen bishop
    assert {:ok, board, %Piece{color: :white, class: :bishop}, move_count} =
             move_and_test(board, "c1", "h6", move_count)

    # black king bishop
    assert {:ok, board, %Piece{color: :black, class: :bishop}, move_count} =
             move_and_test(board, "f8", "a3", move_count)

    # white queen knight
    assert {:ok, board, %Piece{color: :white, class: :knight}, move_count} =
             move_and_test(board, "b1", "c3", move_count)

    # black king knight
    assert {:ok, board, %Piece{color: :black, class: :knight}, move_count} =
             move_and_test(board, "g8", "f6", move_count)

    # white queen
    assert {:ok, board, %Piece{color: :white, class: :queen}, move_count} =
             move_and_test(board, "d1", "d2", move_count)

    # white king - long castling
    assert {:ok, board, %Piece{color: :white, class: :king}, move_count} =
             move_and_test(board, "e1", "c1", move_count)

    # check if rook also moved
    assert %Piece{color: :white, class: :rook} = Board.get_piece(board, "d1")
    # black king - short castling
    assert {:ok, board, %Piece{color: :black, class: :king}, move_count} =
             move_and_test(board, "e8", "g8", move_count)

    # check if rook also moved
    assert %Piece{color: :black, class: :rook} = Board.get_piece(board, "f8")

    assert move_count == length(board.moves)
    assert 1 == length(board.black_captured)
  end
end
