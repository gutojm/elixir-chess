defmodule Chess.UIText do
  @moduledoc false

  alias Chess.{Board, Game, Piece}

  defp print_line(%Board{} = board, y, marks) do
    linha =
      for x <- 0..7 do
        position = Board.xy_2_position({x, y})
        piece = Board.get_piece(board, position)

        if position in marks do
          if piece == nil, do: "< >", else: "> <"
        else
          if piece == nil,
            do: "[ ]",
            else:
              Piece.get_color(piece.color) <>
                Piece.get_name(piece.class) <> Piece.get_color(piece.color)
        end
      end
      |> Enum.join()

    "#{y + 1} #{linha} #{y + 1}"
  end

  def print_board(%Board{} = board, pos_highlight \\ "") do
    marks = if pos_highlight == "", do: [], else: Board.possible_positions(board, pos_highlight)

    IO.puts("   A  B  C  D  E  F  G  H \n")

    for y <- 7..0 do
      IO.puts(print_line(board, y, marks))
    end

    IO.puts("\n   A  B  C  D  E  F  G  H ")
    IO.puts("#{marks}")
  end

  def print_moves(%Board{} = board) do
    for {type, from, to} <- board.moves do
      IO.puts("#{type} #{from} #{to}")
    end
  end

  def print_captures(%Board{} = board) do
    IO.puts("black:")

    for x <- board.white_captured do
      IO.puts("#{x.type} #{x.color}")
    end

    IO.puts("white:")

    for x <- board.black_captured do
      IO.puts("#{x.type} #{x.color}")
    end
  end

  def play(%Game{} = game, last_message \\ "") do
    print_board(game.board)

    IO.puts("\n #{last_message} \n")

    from = IO.gets("#{game.turn}: command ('h' for help): ") |> String.replace_trailing("\n", "")

    status =
      cond do
        String.equivalent?(from, "h") ->
          IO.puts("'q'uit")
          IO.puts("'m'oves")
          IO.puts("'c'aptures")
          IO.gets("Press ENTER...")
          :continue

        String.equivalent?(from, "q") ->
          :end_game

        String.equivalent?(from, "m") ->
          print_moves(game.board)
          IO.gets("Press ENTER...")
          :continue

        String.equivalent?(from, "c") ->
          print_captures(game.board)
          IO.gets("Press ENTER...")
          :continue

        true ->
          :move
      end

    to =
      if status == :move do
        print_board(game.board, from)
        IO.gets("#{game.turn}: to: ") |> String.replace_trailing("\n", "")
      else
        nil
      end

    {status, game} =
      if status == :move do
        Game.move(game, from, to)
      else
        {status, game}
      end

    if status != :end_game do
      play(game, "#{status}: #{from} #{to}")
    else
      game
    end
  end
end
