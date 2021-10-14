defmodule Chess.Board do
  @moduledoc """
  Board module.
  """

  @type direction ::
          :up | :down | :left | :right | :up_left | :up_right | :down_left | :down_right

  defstruct pieces: [],
            moves: [],
            white_captured: [],
            black_captured: []

  alias Chess.Board
  alias Chess.Piece
  alias Chess.Pawn
  alias Chess.Rook
  alias Chess.Knight
  alias Chess.Bishop
  alias Chess.Queen
  alias Chess.King

  @doc """
  Return a new Bord struct
  """
  def new do
    %Board{
      pieces:
        for(color <- Piece.color_list(), type <- Piece.type_list(), do: Piece.new(type, color))
    }
  end

  def get_piece(%Board{} = board, position) do
    Enum.find(board.pieces, &(&1.position == position))
  end

  # def insert_piece(%Board{} = board,type,color) do
  #   piece = get_piece(type,color)
  #   case piece do
  #     :invalid_type -> {:invalid_type,board}
  #     :invalid_color -> {:invalid_color,board}
  #     _ ->
  #       case Enum.find(board,& &1.type == type && &1.color == color) do
  #         nil -> {:ok,[piece|board]}
  #         _ -> {:already_in,board}
  #       end
  #   end
  # end

  defp delta_available(position) do
    {x, y} = position_2_xy(position)
    axf = 7 - x
    axb = 0 - x
    ayf = 7 - y
    ayb = 0 - y
    {axf, axb, ayf, ayb}
  end

  defp minxy do
    <<minx::utf8, miny::utf8>> = "a1"
    {minx, miny}
  end

  defp position_2_xy(position) do
    {minx, miny} = minxy()
    <<x::utf8, y::utf8>> = position
    {x - minx, y - miny}
  end

  defp xy_2_position({x, y}) do
    {minx, miny} = minxy()
    <<minx + x::utf8, miny + y::utf8>>
  end

  defp absolute_deltas(p1, p2) do
    {x1, y1} = position_2_xy(p1)
    {x2, y2} = position_2_xy(p2)
    {abs(x1 - x2), abs(y1 - y2)}
  end

  def new_position(position, :white, deltax, deltay), do: new_position(position, deltax, deltay)
  def new_position(position, :black, deltax, deltay), do: new_position(position, -deltax, -deltay)

  def new_position(position, deltax, deltay) do
    position
    |> delta_available()
    |> build_new_position(position, deltax, deltay)
  end

  defp build_new_position({axf, axb, ayf, ayb}, position, deltax, deltay)
       when deltax < axb or deltax > axf or deltay < ayb or deltay > ayf do
    {:invalid_position, position}
  end

  defp build_new_position(_, position, deltax, deltay) do
    <<x::utf8, y::utf8>> = position
    x = x + deltax
    y = y + deltay

    {:ok, <<x::utf8, y::utf8>>}
  end

  @doc """
  based on a destination position of a pawn returns a position for a en passant kill
  """

  def en_passant_kill_position(%Board{} = board, %Piece{} = killer_piece, to) do
    piece = get_piece(board, to)

    if piece != nil or killer_piece.class != :pawn do
      nil
    else
      {status, position} = new_position(to, killer_piece.color, 0, -1)

      if status != :ok do
        nil
      else
        enemy_piece = get_piece(board, position)

        if enemy_piece != nil and
             enemy_piece.class == :pawn and
             enemy_piece.color != killer_piece.color and
             Enum.count(enemy_piece.moves) == 1 do
          [{from, to} | _tail] = enemy_piece.moves
          {_xdelta, ydelta} = absolute_deltas(from, to)

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

  def possible_positions(%Board{} = board, position) do
    piece = get_piece(board, position)

    do_possible_positions(%Board{} = board, position, piece)
  end

  defp do_possible_positions(%Board{} = _board, _position, nil), do: []

  defp do_possible_positions(%Board{} = board, position, %Piece{class: class}) do
    case class do
      :pawn -> Pawn.possible_positions(board, position)
      :rook -> Rook.possible_positions(board, position)
      :knight -> Knight.possible_positions(board, position)
      :bishop -> Bishop.possible_positions(board, position)
      :queen -> Queen.possible_positions(board, position)
      :king -> King.possible_positions(board, position)
      _ -> []
    end
  end

  # proxima posicao inválida, retorna lista atual
  defp do_possible_straight_positions(%{
         status: :invalid_position,
         list: list
       }) do
    list
  end

  # proxima posição válida e desocupada, mas a morte é obrigatória, retorna a lista atual
  defp do_possible_straight_positions(%{
         status: :ok,
         piece_on_destination: nil,
         list: list,
         kill: :mandatory
       }) do
    list
  end

  # proxima posição válida e desocupada retorna a lista atual acrescida da nova posição
  defp do_possible_straight_positions(%{
         status: :ok,
         position: position,
         piece_on_destination: nil,
         max_iter: max_iter,
         list: list,
         iter: iter
       })
       when iter == max_iter do
    [position | list]
  end

  # proxima posição válida e desocupada, número maximo de interações não atingido, vai pra próxima
  defp do_possible_straight_positions(%{
         status: :ok,
         direction: direction,
         board: board,
         position: position,
         piece: piece,
         piece_on_destination: nil,
         max_iter: max_iter,
         list: list,
         iter: iter,
         kill: kill
       }) do
    do_possible_straight_positions(%{
      status: :next,
      direction: direction,
      board: board,
      position: position,
      piece: piece,
      max_iter: max_iter,
      list: [position | list],
      iter: iter,
      kill: kill
    })
  end

  # próxima casa ocupada por peça da mesma cor, retorna a lista atual
  defp do_possible_straight_positions(%{
         status: :ok,
         piece: piece,
         piece_on_destination: piece_on_destination,
         list: list
       })
       when piece.color == piece_on_destination.color do
    list
  end

  # próxima casa ocupada por peça de outra cor, morte proibida, retorna a lista
  defp do_possible_straight_positions(%{
         status: :ok,
         piece: piece,
         piece_on_destination: piece_on_destination,
         list: list,
         kill: :forbidden
       })
       when piece.color != piece_on_destination.color do
    list
  end

  # próxima casa ocupada por peça de outra cor, acrescenta a posição atual e retorna a lista
  defp do_possible_straight_positions(%{
         status: :ok,
         position: position,
         piece: piece,
         piece_on_destination: piece_on_destination,
         list: list
       })
       when piece.color != piece_on_destination.color do
    [position | list]
  end

  # itera pra próxima casa
  defp do_possible_straight_positions(%{
         status: :next,
         direction: direction,
         board: %Board{} = board,
         position: position,
         piece: %Piece{} = piece,
         max_iter: max_iter,
         list: list,
         iter: iter,
         kill: kill
       }) do
    iter = iter + 1

    {status, p} = get_position_by_direction(direction, position, piece.color)
    piece_on_destination = Board.get_piece(board, p)

    do_possible_straight_positions(%{
      status: status,
      direction: direction,
      board: board,
      position: p,
      piece: piece,
      piece_on_destination: piece_on_destination,
      max_iter: max_iter,
      list: list,
      iter: iter,
      kill: kill
    })
  end

  def possible_straight_positions(
        direction,
        %Board{} = board,
        position,
        max_iter \\ 0,
        kill \\ :allowed
      ) do
    piece = Board.get_piece(board, position)

    do_possible_straight_positions(%{
      status: :next,
      direction: direction,
      board: board,
      position: position,
      piece: piece,
      max_iter: max_iter,
      list: [],
      iter: 0,
      kill: kill
    })
  end

  defp get_position_by_direction(:up, position, color), do: new_position(position, color, 0, 1)
  defp get_position_by_direction(:down, position, color), do: new_position(position, color, 0, -1)
  defp get_position_by_direction(:right, position, color), do: new_position(position, color, 1, 0)
  defp get_position_by_direction(:left, position, color), do: new_position(position, color, -1, 0)

  defp get_position_by_direction(:up_right, position, color),
    do: new_position(position, color, 1, 1)

  defp get_position_by_direction(:up_left, position, color),
    do: new_position(position, color, -1, 1)

  defp get_position_by_direction(:down_right, position, color),
    do: new_position(position, color, 1, -1)

  defp get_position_by_direction(:down_left, position, color),
    do: new_position(position, color, -1, -1)

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

  defp add_captured(%Board{} = board, %Piece{color: :white} = piece) do
    %Board{board | white_captured: [piece | board.white_captured]}
  end

  defp add_captured(%Board{} = board, %Piece{color: :black} = piece) do
    %Board{board | black_captured: [piece | board.black_captured]}
  end

  # defp add_captured(%Board{} = board, nil) do
  #  board
  # end

  defp kill(%Board{} = board, %Piece{} = piece) do
    board = add_captured(board, piece)
    %Board{board | pieces: List.delete(board.pieces, piece)}
  end

  defp maybe_kill(%Board{} = board, %Piece{} = killer_piece, position) do
    piece = get_piece(board, position)

    if piece == nil do
      en_passant = en_passant_kill_position(board, killer_piece, position)

      if en_passant == nil do
        board
      else
        kill(board, get_piece(board, en_passant))
      end
    else
      kill(board, piece)
    end
  end

  defp maybe_castling_rook(%Board{} = board, %Piece{} = piece, position) do
    if piece.class == :king do
      cpositions = castling_positions(board, piece.position, piece)

      if position in cpositions do
        {rook, new_p} =
          case position do
            "c1" -> {get_piece(board, "a1"), "d1"}
            "g1" -> {get_piece(board, "h1"), "f1"}
            "c8" -> {get_piece(board, "a8"), "d8"}
            "g8" -> {get_piece(board, "h8"), "f8"}
            _ -> {nil, nil}
          end

        if rook == nil do
          board
        else
          set_new_position(board, rook, new_p)
        end
      end
    else
      board
    end
  end

  @doc """
  sets a new position to a piece, no critics
  """

  def set_new_position(%Board{} = board, %Piece{} = piece, position) do
    %Board{
      board
      | pieces:
          Enum.map(board.pieces, fn x ->
            if x.position == piece.position, do: Piece.set_position(piece, position), else: x
          end)
    }
  end

  defp add_move(%Board{} = board, type, from, to) do
    %Board{board | moves: [{type, from, to} | board.moves]}
  end

  def move(%Board{} = board, from, to) do
    piece = get_piece(board, from)
    do_move(board, from, to, piece)
  end

  defp do_move(board, _, _, nil), do: {:empty_position, board}

  defp do_move(board, from, to, piece) do
    pp = possible_positions(board, from)

    if to in pp do
      board =
        add_move(board, piece.type, from, to)
        |> maybe_kill(piece, to)
        |> maybe_castling_rook(piece, to)
        |> set_new_position(piece, to)

      {:ok, board}
    else
      {:not_allowed, board}
    end
  end

  defp print_line(%Board{} = board, y, marks) do
    linha =
      for x <- 0..7 do
        position = xy_2_position({x, y})
        piece = get_piece(board, position)

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

  def print(%Board{} = board, pos_highlight \\ "") do
    marks = if pos_highlight == "", do: [], else: possible_positions(board, pos_highlight)

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
end
