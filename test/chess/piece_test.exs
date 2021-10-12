defmodule Chess.PieceTest do
  use ExUnit.Case

  alias Chess.{Piece}

  test "type_list/0" do
    assert 16 = length(Piece.type_list())
  end

  test "color_list/0" do
    assert 2 = length(Piece.color_list())
  end

  test "get_name/1" do
    assert "R" = Piece.get_name(:rook)
  end

  test "get_color/1" do
    assert "_" = Piece.get_color(:white)
  end

  test "is_valid_type?/1" do
    assert Piece.is_valid_type?(:queen)
    refute Piece.is_valid_type?(:horse)
  end

  test "is_valid_color/1" do
    assert Piece.is_valid_color?(:white)
    refute Piece.is_valid_color?(:blue)
  end

  test "is_valid_class/1" do
    assert Piece.is_valid_class?(:king)
    refute Piece.is_valid_class?(:horse)
  end

  test "new/2" do
    assert %Piece{type: :king, color: :white, class: :king, position: "e1"} = Piece.new(:king,:white)
    assert :invalid_type = Piece.new(:kingo,:white)
    assert :invalid_color = Piece.new(:king,:blue)
  end

  test "original_position/2" do
    assert "e1" = Piece.original_position(:white,:king)
    assert :invalid_type = Piece.original_position(:white,:kingo)
    assert :invalid_color = Piece.original_position(:blue,:king)
  end

  test "set_position/2" do
    piece = Piece.new(:king,:white)
    piece = Piece.set_position(piece,"e3")
    assert %Piece{position: "e3", moved: true} = piece

    piece = Piece.set_position(piece,"e5")
    assert 2 = length(piece.moves)
  end

  test "enemy_color/1" do
    assert :black = Piece.enemy_color(:white)
    assert :white = Piece.enemy_color(:black)
  end
end
