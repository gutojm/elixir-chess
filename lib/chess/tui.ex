defmodule Chess.TUI do
  @moduledoc false

  alias Chess.{Board, Game, Piece}

  def play(game) do
    play_loop(game, "", :start)
  end

  def play_loop(game, _last_message, :end_game), do: game

  def play_loop(game, last_message, _status) do
    print_board(game.board)

    IO.puts("\n #{last_message} \n")

    print_menaces(game.board)

    command =
      IO.gets("#{game.turn}: command ('h' for help): ") |> String.replace_trailing("\n", "")

    status = get_status_from_command(game, command)

    to = get_destination(game, command, status)

    {status, game} = maybe_move(status, game, command, to)

    play_loop(game, "#{status}: #{status} #{to}", status)
  end

  defp print_menaces_by_color(_, []), do: nil

  defp print_menaces_by_color(:white, menacing_positions),
    do: IO.puts("white checked: #{menacing_positions}")

  defp print_menaces_by_color(:black, menacing_positions),
    do: IO.puts("black checked: #{menacing_positions}")

  defp print_menaces(%Board{} = board) do
    print_menaces_by_color(:white, Board.menacing_king_positions(board, :white))
    print_menaces_by_color(:black, Board.menacing_king_positions(board, :black))
  end

  def print_board(%Board{} = board, pos_highlight \\ "") do
    marks = get_marks(board, pos_highlight)

    IO.puts("   A  B  C  D  E  F  G  H \n")

    Enum.each(7..0, fn y ->
      board
      |> print_line(y, marks)
      |> IO.puts()
    end)

    IO.puts("\n   A  B  C  D  E  F  G  H ")
    IO.puts("#{marks}")
  end

  def print_moves(%Board{} = board) do
    Enum.each(board.moves, fn {type, from, to} -> IO.puts("#{type} #{from} #{to}") end)
  end

  def print_captures(%Board{} = board) do
    do_print_capture(board.white_captured, "black")
    do_print_capture(board.black_captured, "white")
  end

  defp do_print_capture(captured_list, label_color) do
    IO.puts(label_color <> ":")

    Enum.each(captured_list, fn x -> IO.puts("#{x.type} #{x.color}") end)
  end

  defp get_marks(_, ""), do: []

  defp get_marks(board, pos_highlight) do
    Board.possible_positions(board, pos_highlight)
  end

  defp print_line(%Board{} = board, y, marks) do
    0..7
    |> Enum.map(fn x ->
      position = Board.xy_2_position({x, y})
      piece = Board.get_piece(board, position)
      build_square(piece, position in marks)
    end)
    |> Enum.join()
    |> then(fn line ->
      "#{y + 1} #{line} #{y + 1}"
    end)
  end

  defp build_square(nil = _piece, true = _position_in_marks), do: "< >"
  defp build_square(_piece, true = _position_in_marks), do: "> <"
  defp build_square(nil = _piece, false = _position_in_marks), do: "[ ]"

  defp build_square(piece, false = _position_in_marks) do
    Piece.get_color(piece.color) <> Piece.get_name(piece.class) <> Piece.get_color(piece.color)
  end

  def print_help_command do
    IO.puts("'q'uit")
    IO.puts("'m'oves")
    IO.puts("'c'aptures")
    IO.gets("Press ENTER...")
  end

  defp get_status_from_command(_, "h") do
    print_help_command()
    :continue
  end

  defp get_status_from_command(game, "m") do
    print_moves(game.board)
    IO.gets("Press ENTER...")
    :continue
  end

  defp get_status_from_command(game, "c") do
    print_captures(game.board)
    IO.gets("Press ENTER...")
    :continue
  end

  defp get_status_from_command(_, "q") do
    :end_game
  end

  defp get_status_from_command(_game, _) do
    :move
  end

  defp get_destination(game, from, :move) do
    print_board(game.board, from)
    IO.gets("#{game.turn}: to: ") |> String.replace_trailing("\n", "")
  end

  defp get_destination(_, _, _), do: nil

  defp maybe_move(:move, game, from, to), do: Game.move(game, from, to)
  defp maybe_move(status, game, _, _), do: {status, game}
end
