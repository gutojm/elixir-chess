defmodule Chess do
  defp get_piece(type, color) do
    %{
      type: type,
      color: color,
      position: original_position(color,type)
    }
  end

  defp original_position(color,type) when {color,type} == {:white,:queen_tower} do
    'a1'
  end

  defp original_position(color,type) when {color,type} == {:white,:queen_tower_pawn} do
    'a2'
  end

  defp original_position(color,type) when {color,type} == {:white,:queen_knight} do
    'b1'
  end

  defp original_position(color,type) when {color,type} == {:white,:queen_knight_pawn} do
    'b2'
  end

  defp original_position(color,type) when {color,type} == {:white,:queen_bishop} do
    'c1'
  end

  defp original_position(color,type) when {color,type} == {:white,:queen_bishop_pawn} do
    'c2'
  end

  defp original_position(color,type) when {color,type} == {:white,:queen} do
    'd1'
  end

  defp original_position(color,type) when {color,type} == {:white,:queen_pawn} do
    'd2'
  end

  defp original_position(color,type) when {color,type} == {:white,:king} do
    'e1'
  end

  defp original_position(color,type) when {color,type} == {:white,:king_pawn} do
    'e2'
  end

  defp original_position(color,type) when {color,type} == {:white,:king_bishop} do
    'f1'
  end

  defp original_position(color,type) when {color,type} == {:white,:king_bishop_pawn} do
    'f2'
  end

  defp original_position(color,type) when {color,type} == {:white,:king_knight} do
    'g1'
  end

  defp original_position(color,type) when {color,type} == {:white,:king_knight_pawn} do
    'g2'
  end

  defp original_position(color,type) when {color,type} == {:white,:king_tower} do
    'h1'
  end

  defp original_position(color,type) when {color,type} == {:white,:king_tower_pawn} do
    'h2'
  end

  defp original_position(color,type) when {color,type} == {:black,:queen_tower} do
    'a8'
  end

  defp original_position(color,type) when {color,type} == {:black,:queen_tower_pawn} do
    'a7'
  end

  defp original_position(color,type) when {color,type} == {:black,:queen_knight} do
    'b8'
  end

  defp original_position(color,type) when {color,type} == {:black,:queen_knight_pawn} do
    'b7'
  end

  defp original_position(color,type) when {color,type} == {:black,:queen_bishop} do
    'c8'
  end

  defp original_position(color,type) when {color,type} == {:black,:queen_bishop_pawn} do
    'c7'
  end

  defp original_position(color,type) when {color,type} == {:black,:queen} do
    'd8'
  end

  defp original_position(color,type) when {color,type} == {:black,:queen_pawn} do
    'd7'
  end

  defp original_position(color,type) when {color,type} == {:black,:king} do
    'e8'
  end

  defp original_position(color,type) when {color,type} == {:black,:king_pawn} do
    'e7'
  end

  defp original_position(color,type) when {color,type} == {:black,:king_bishop} do
    'f8'
  end

  defp original_position(color,type) when {color,type} == {:black,:king_bishop_pawn} do
    'f7'
  end

  defp original_position(color,type) when {color,type} == {:black,:king_knight} do
    'g8'
  end

  defp original_position(color,type) when {color,type} == {:black,:king_knight_pawn} do
    'g7'
  end

  defp original_position(color,type) when {color,type} == {:black,:king_tower} do
    'h8'
  end

  defp original_position(color,type) when {color,type} == {:black,:king_tower_pawn} do
    'h7'
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
