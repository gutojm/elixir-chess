defmodule Chess.Piece do
  @moduledoc """
  Piece module.
  """

  defstruct type: nil,
            color: nil,
            position: nil,
            class: nil,
            moved: false,
            moves: []

  alias Chess.Piece

  @class_list [
    :queen,
    :king,
    :rook,
    :knight,
    :bishop,
    :pawn
  ]

  @type_list [
    :queen_rook,
    :queen_rook_pawn,
    :queen_knight,
    :queen_knight_pawn,
    :queen_bishop,
    :queen_bishop_pawn,
    :queen,
    :queen_pawn,
    :king,
    :king_pawn,
    :king_bishop,
    :king_bishop_pawn,
    :king_knight,
    :king_knight_pawn,
    :king_rook,
    :king_rook_pawn
  ]

  @color_list [:white, :black]

  def type_list, do: @type_list
  def color_list, do: @color_list

  def get_name(:rook), do: "R"
  def get_name(:knight), do: "N"
  def get_name(:bishop), do: "B"
  def get_name(:queen), do: "Q"
  def get_name(:king), do: "K"
  def get_name(:pawn), do: "P"
  def get_name(_), do: " "

  def get_color(:white), do: "_"
  def get_color(:black), do: " "
  def get_color(_), do: " "

  def is_valid_type?(type), do: type in @type_list
  def is_valid_color?(color), do: color in @color_list
  def is_valid_class?(class), do: class in @class_list

  defp get_class(type) when type not in @type_list, do: :invalid_type
  defp get_class(:queen_rook), do: :rook
  defp get_class(:king_rook), do: :rook
  defp get_class(:queen_knight), do: :knight
  defp get_class(:king_knight), do: :knight
  defp get_class(:queen_bishop), do: :bishop
  defp get_class(:king_bishop), do: :bishop
  defp get_class(:queen), do: :queen
  defp get_class(:king), do: :king
  defp get_class(_), do: :pawn

  def original_position(color, _type) when color not in @color_list, do: :invalid_color
  def original_position(_color, type) when type not in @type_list, do: :invalid_type
  def original_position(:white, :queen_rook), do: "a1"
  def original_position(:white, :queen_rook_pawn), do: "a2"
  def original_position(:white, :queen_knight), do: "b1"
  def original_position(:white, :queen_knight_pawn), do: "b2"
  def original_position(:white, :queen_bishop), do: "c1"
  def original_position(:white, :queen_bishop_pawn), do: "c2"
  def original_position(:white, :queen), do: "d1"
  def original_position(:white, :queen_pawn), do: "d2"
  def original_position(:white, :king), do: "e1"
  def original_position(:white, :king_pawn), do: "e2"
  def original_position(:white, :king_bishop), do: "f1"
  def original_position(:white, :king_bishop_pawn), do: "f2"
  def original_position(:white, :king_knight), do: "g1"
  def original_position(:white, :king_knight_pawn), do: "g2"
  def original_position(:white, :king_rook), do: "h1"
  def original_position(:white, :king_rook_pawn), do: "h2"
  def original_position(:black, :queen_rook), do: "a8"
  def original_position(:black, :queen_rook_pawn), do: "a7"
  def original_position(:black, :queen_knight), do: "b8"
  def original_position(:black, :queen_knight_pawn), do: "b7"
  def original_position(:black, :queen_bishop), do: "c8"
  def original_position(:black, :queen_bishop_pawn), do: "c7"
  def original_position(:black, :queen), do: "d8"
  def original_position(:black, :queen_pawn), do: "d7"
  def original_position(:black, :king), do: "e8"
  def original_position(:black, :king_pawn), do: "e7"
  def original_position(:black, :king_bishop), do: "f8"
  def original_position(:black, :king_bishop_pawn), do: "f7"
  def original_position(:black, :king_knight), do: "g8"
  def original_position(:black, :king_knight_pawn), do: "g7"
  def original_position(:black, :king_rook), do: "h8"
  def original_position(:black, :king_rook_pawn), do: "h7"

  def new(type, _color) when type not in @type_list, do: :invalid_type
  def new(_type, color) when color not in @color_list, do: :invalid_color

  def new(type, color) do
    %Piece{
      type: type,
      color: color,
      position: original_position(color, type),
      class: get_class(type),
      moved: false
    }
  end

  # TODO - validate position

  def set_position(%Piece{} = piece, position) do
    %Piece{piece | position: position, moved: true, moves: [{piece.position, position}|piece.moves]}
  end

  # TODO - validate color

  def enemy_color(color) do
    if color == :white do
      :black
    else
      :white
    end
  end
end
