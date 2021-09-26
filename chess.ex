defmodule Chess do
  defp is_valid_type(type) do
    Enum.find([
        :queen_tower,
        :queen_tower_pawn,
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
        :king_tower,
        :king_tower_pawn
    ],& &1 == type)
  end

  defp is_valid_color(color) do
    Enum.find([:white, :black],& &1 == color)
  end

  defp get_piece(type, color) do
    case is_valid_color(color) do
      nil ->
        :invalid_color
      _ ->
        case is_valid_type(type) do
          nil ->
            :invalid_type
          _ ->
            %{
              type: type,
              color: color,
              position: original_position(color,type)
            }
        end
    end
  end

  defp original_position(color,type) do

    case color do
      :white ->
        case type do
          :queen_tower -> 'a1'
          :queen_tower_pawn-> 'a2'
          :queen_knight -> 'b1'
          :queen_knight_pawn -> 'b2'
          :queen_bishop -> 'c1'
          :queen_bishop_pawn -> 'c2'
          :queen -> 'd1'
          :queen_pawn -> 'd2'
          :king -> 'e1'
          :king_pawn -> 'e2'
          :king_bishop -> 'f1'
          :king_bishop_pawn -> 'f2'
          :king_knight -> 'g1'
          :king_knight_pawn -> 'g2'
          :king_tower -> 'h1'
          :king_tower_pawn -> 'h2'
        end
      :black ->
        case type do
          :queen_tower -> 'a8'
          :queen_tower_pawn -> 'a7'
          :queen_knight -> 'b8'
          :queen_knight_pawn -> 'b7'
          :queen_bishop -> 'c8'
          :queen_bishop_pawn -> 'c7'
          :queen -> 'd8'
          :queen_pawn -> 'd7'
          :king -> 'e8'
          :king_pawn -> 'e7'
          :king_bishop -> 'f8'
          :king_bishop_pawn -> 'f7'
          :king_knight -> 'g8'
          :king_knight_pawn -> 'g7'
          :king_tower -> 'h8'
          :king_tower_pawn -> 'h7'
        end
    end
  end

  def get_king(color) do
    get_piece(:king,color)
  end

  def get_queen(color) do
    get_piece(:queen,color)
  end

  def get_king_bishop(color) do
    get_piece(:king_bishop,color)
  end

  def get_queen_bishop(color) do
    get_piece(:queen_bishop,color)
  end

  def get_king_knight(color) do
    get_piece(:king_knight,color)
  end

  def get_queen_knight(color) do
    get_piece(:queen_knight,color)
  end

  def get_king_tower(color) do
    get_piece(:king_tower,color)
  end

  def get_queen_tower(color) do
    get_piece(:queen_tower,color)
  end

  def get_king_pawn(color) do
    get_piece(:king_pawn,color)
  end

  def get_queen_pawn(color) do
    get_piece(:queen_pawn,color)
  end

  def get_king_bishop_pawn(color) do
    get_piece(:king_bishop_pawn,color)
  end

  def get_queen_bishop_pawn(color) do
    get_piece(:queen_bishop_pawn,color)
  end

  def get_king_knight_pawn(color) do
    get_piece(:king_knight_pawn,color)
  end

  def get_queen_knight_pawn(color) do
    get_piece(:queen_knight_pawn,color)
  end

  def get_king_tower_pawn(color) do
    get_piece(:king_tower_pawn,color)
  end

  def get_queen_tower_pawn(color) do
    get_piece(:queen_tower_pawn,color)
  end
end
