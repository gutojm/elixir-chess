defmodule Chess.Pawn do
  @moduledoc false

  alias Chess.Board
  alias Chess.Piece

  def en_passant_kill_position(%Board{} = board, %Piece{} = killer_piece, to) do
    piece = Board.get_piece(board, to)

    if piece != nil or killer_piece.class != :pawn do
      nil
    else
      {status, position} = Board.new_position(to, killer_piece.color, 0, -1)

      if status != :ok do
        nil
      else
        enemy_piece = Board.get_piece(board, position)

        if enemy_piece != nil and
             enemy_piece.class == :pawn and
             enemy_piece.color != killer_piece.color and
             Enum.count(enemy_piece.moves) == 1 do
          [{from, to} | _tail] = enemy_piece.moves
          {_xdelta, ydelta} = Board.absolute_deltas(from, to)

          if ydelta == 2 do
            position
          else
            nil
          end
        else
          nil
        end
      end
    end
  end

  def en_passant_positions(%Board{} = board, position, %Piece{} = piece) do
    (Board.possible_straight_positions(:up_left, board, position, 1, :forbidden) ++
       Board.possible_straight_positions(:up_right, board, position, 1, :forbidden))
    |> Enum.filter(&(en_passant_kill_position(board, piece, &1) != nil))
  end

  def possible_positions(%Board{} = board, position) do
    piece = Board.get_piece(board, position)
    max_iter = if piece.moved, do: 1, else: 2

    Board.possible_straight_positions(:up, board, position, max_iter, :forbidden) ++
      Board.possible_straight_positions(:up_left, board, position, 1, :mandatory) ++
      Board.possible_straight_positions(:up_right, board, position, 1, :mandatory) ++
      en_passant_positions(board, position, piece)
  end
end
