defmodule Chess.Game do
  @moduledoc """
  Game module.
  """

  defstruct turn: :white,
            board: nil

  alias Chess.{Board, Game}

  def new do
    %Game{
      board: Board.new()
    }
  end

  defp set_board(%Game{} = game, %Board{} = board), do: %Game{game | board: board}

  defp next_turn(%Game{turn: :white} = game), do: %Game{game | turn: :black}
  defp next_turn(%Game{turn: :black} = game), do: %Game{game | turn: :white}

  def move(%Game{} = game, from, to) do
    piece = Board.get_piece(game.board, from)

    if piece == nil do
      {:invalid_position, game}
    else
      if piece.color != game.turn do
        {:invalid_color, game}
      else
        {status, board} = Board.move(game.board, from, to)

        game =
          if status == :ok do
            set_board(game, board)
            |> next_turn()
          else
            game
          end

        {status, game}
      end
    end
  end
end
