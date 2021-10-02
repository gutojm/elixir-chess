defmodule Chess.Piece do
  defstruct type: nil,
            color: nil,
            position: nil,
            class: nil,
            moved: false

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

  def get_color(:white), do: "w"
  def get_color(:black), do: "b"
  def get_color(_), do: " "

  def is_valid_type?(type), do: type in @type_list
  def is_valid_color?(color), do: color in @color_list
  def is_valid_class?(class), do: class in @class_list

  defp get_class(type) when type not in @type_list, do: :invalid_type
  defp get_class(:queen_rook),   do: :rook
  defp get_class(:king_rook),    do: :rook
  defp get_class(:queen_knight), do: :knight
  defp get_class(:king_knight),  do: :knight
  defp get_class(:queen_bishop), do: :bishop
  defp get_class(:king_bishop),  do: :bishop
  defp get_class(:queen),        do: :queen
  defp get_class(:king),         do: :king
  defp get_class(_),             do: :pawn

  defp original_position(color,_type) when color not in @color_list, do: :invalid_color
  defp original_position(_color,type) when type not in @type_list, do: :invalid_type
  defp original_position(:white,:queen_rook),       do: "a1"
  defp original_position(:white,:queen_rook_pawn),  do: "a2"
  defp original_position(:white,:queen_knight),      do: "b1"
  defp original_position(:white,:queen_knight_pawn), do: "b2"
  defp original_position(:white,:queen_bishop),      do: "c1"
  defp original_position(:white,:queen_bishop_pawn), do: "c2"
  defp original_position(:white,:queen),             do: "d1"
  defp original_position(:white,:queen_pawn),        do: "d2"
  defp original_position(:white,:king),              do: "e1"
  defp original_position(:white,:king_pawn),         do: "e2"
  defp original_position(:white,:king_bishop),       do: "f1"
  defp original_position(:white,:king_bishop_pawn),  do: "f2"
  defp original_position(:white,:king_knight),       do: "g1"
  defp original_position(:white,:king_knight_pawn),  do: "g2"
  defp original_position(:white,:king_rook),        do: "h1"
  defp original_position(:white,:king_rook_pawn),   do: "h2"
  defp original_position(:black,:queen_rook),       do: "a8"
  defp original_position(:black,:queen_rook_pawn),  do: "a7"
  defp original_position(:black,:queen_knight),      do: "b8"
  defp original_position(:black,:queen_knight_pawn), do: "b7"
  defp original_position(:black,:queen_bishop),      do: "c8"
  defp original_position(:black,:queen_bishop_pawn), do: "c7"
  defp original_position(:black,:queen),             do: "d8"
  defp original_position(:black,:queen_pawn),        do: "d7"
  defp original_position(:black,:king),              do: "e8"
  defp original_position(:black,:king_pawn),         do: "e7"
  defp original_position(:black,:king_bishop),       do: "f8"
  defp original_position(:black,:king_bishop_pawn),  do: "f7"
  defp original_position(:black,:king_knight),       do: "g8"
  defp original_position(:black,:king_knight_pawn),  do: "g7"
  defp original_position(:black,:king_rook),        do: "h8"
  defp original_position(:black,:king_rook_pawn),   do: "h7"

  def new(type, _color) when type not in @type_list, do: :invalid_type
  def new(_type, color) when color not in @color_list, do: :invalid_color
  def new(type, color) do
    %Piece{
      type: type,
      color: color,
      position: original_position(color,type),
      class: get_class(type),
      moved: false
    }
  end

  # def get_king(color) do
  #   get_piece(:king,color)
  # end

  # def get_queen(color) do
  #   get_piece(:queen,color)
  # end

  # def get_king_bishop(color) do
  #   get_piece(:king_bishop,color)
  # end

  # def get_queen_bishop(color) do
  #   get_piece(:queen_bishop,color)
  # end

  # def get_king_knight(color) do
  #   get_piece(:king_knight,color)
  # end

  # def get_queen_knight(color) do
  #   get_piece(:queen_knight,color)
  # end

  # def get_king_rook(color) do
  #   get_piece(:king_rook,color)
  # end

  # def get_queen_rook(color) do
  #   get_piece(:queen_rook,color)
  # end

  # def get_king_pawn(color) do
  #   get_piece(:king_pawn,color)
  # end

  # def get_queen_pawn(color) do
  #   get_piece(:queen_pawn,color)
  # end

  # def get_king_bishop_pawn(color) do
  #   get_piece(:king_bishop_pawn,color)
  # end

  # def get_queen_bishop_pawn(color) do
  #   get_piece(:queen_bishop_pawn,color)
  # end

  # def get_king_knight_pawn(color) do
  #   get_piece(:king_knight_pawn,color)
  # end

  # def get_queen_knight_pawn(color) do
  #   get_piece(:queen_knight_pawn,color)
  # end

  # def get_king_rook_pawn(color) do
  #   get_piece(:king_rook_pawn,color)
  # end

  # def get_queen_rook_pawn(color) do
  #   get_piece(:queen_rook_pawn,color)
  # end
end
