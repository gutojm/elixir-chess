defmodule Chess.King do
  @moduledoc false

  alias Chess.{Board, Piece}

  def possible_positions(%Board{} = board, position) do
    piece = Board.get_piece(board, position)

    Board.possible_straight_positions(:up, board, position, 1) ++
      Board.possible_straight_positions(:right, board, position, 1) ++
      Board.possible_straight_positions(:left, board, position, 1) ++
      Board.possible_straight_positions(:down, board, position, 1) ++
      Board.possible_straight_positions(:up_left, board, position, 1) ++
      Board.possible_straight_positions(:up_right, board, position, 1) ++
      Board.possible_straight_positions(:down_left, board, position, 1) ++
      Board.possible_straight_positions(:down_right, board, position, 1) ++
      castling_positions(board, position, piece)
  end

  def castling_positions(%Board{} = board, position, %Piece{} = piece) do
    if piece.moved do
      []
    else
      rooks = [
        Piece.original_position(piece.color, :queen_rook),
        Piece.original_position(piece.color, :king_rook)
      ]

      in_between = [
        [
          Piece.original_position(piece.color, :queen_knight),
          Piece.original_position(piece.color, :queen_bishop),
          Piece.original_position(piece.color, :queen)
        ],
        [
          Piece.original_position(piece.color, :king_knight),
          Piece.original_position(piece.color, :king_bishop)
        ]
      ]

      for x <- 0..1 do
        rook_position = Enum.at(rooks, x)
        rook = Board.get_piece(board, rook_position)

        if rook == nil or rook.moved do
          nil
        else
          positions = Enum.at(in_between, x)

          list =
            for p <- positions do
              Board.get_piece(board, p)
            end
            |> Enum.filter(&(&1 != nil))

          if list == [] do
            delta_x = if x == 0, do: -2, else: 2

            {status, new_p} = Board.new_position(position, delta_x, 0)

            if status == :ok do
              new_p
            else
              nil
            end
          else
            nil
          end
        end
      end
      |> Enum.filter(&(&1 != nil))
    end
  end
end
