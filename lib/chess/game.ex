defmodule Chess.Game do
  defstruct turn: :white,
            board: nil

  alias Chess.Game
  alias Chess.Board

  def new do
    %Game{
      board: Board.new
    }
  end

  def set_board(%Game{} = game,%Board{} = board), do: %Game{game | board: board}

  def next_turn(%Game{turn: :white} = game), do: %Game{game | turn: :black}
  def next_turn(%Game{turn: :black} = game), do: %Game{game | turn: :white}

  def move(%Game{} = game,from,to) do
    piece = Board.get_piece(game.board,from)

    if piece == nil do
      {:invalid_position,game}
    else
      if piece.color != game.turn do
        {:invalid_color,game}
      else
        {status,board} = Board.move(game.board,from,to)

        game =
          if status == :ok do
            Game.set_board(game,board)
            |> Game.next_turn()
          else
            game
          end

        {status,game}
      end
    end
  end

  def play(%Game{} = game,last_message \\ "") do
    Board.print(game.board)

    IO.puts("\n #{last_message} \n")

    from = IO.gets("#{game.turn}: command ('h' for help): ") |> String.replace_trailing("\n","")

    status =
      cond do
        String.equivalent?(from,"h") ->
          IO.puts("'q'uit")
          IO.puts("'m'oves")
          IO.puts("'c'aptures")
          IO.gets("Press ENTER...")
          :continue
        String.equivalent?(from,"q") ->
          :end_game
        String.equivalent?(from,"m") ->
          Board.print_moves(game.board)
          IO.gets("Press ENTER...")
          :continue
        String.equivalent?(from,"c") ->
          Board.print_captures(game.board)
          IO.gets("Press ENTER...")
          :continue
        true ->
          :move
      end

    to =
      if status == :move do
        Board.print(game.board,from)
          IO.gets("#{game.turn}: to: ") |> String.replace_trailing("\n","")
      else
        nil
      end

    {status,game} =
      if status == :move do
        move(game,from,to)
      else
        {status,game}
      end

    if status != :end_game do
      Game.play(game,"#{status}: #{from} #{to}")
    else
      game
    end
  end
end
