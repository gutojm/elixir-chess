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

  def position_2_xy(position) do
    {minx, miny} = minxy()
    <<x::utf8, y::utf8>> = position
    {x - minx, y - miny}
  end

  def xy_2_position({x, y}) do
    {minx, miny} = minxy()
    <<minx + x::utf8, miny + y::utf8>>
  end

  def absolute_deltas(p1, p2) do
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
      en_passant = Pawn.en_passant_kill_position(board, killer_piece, position)

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
      cpositions = King.castling_positions(board, piece.position, piece)

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

  # TODO - validar posição inválida

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

  defp check_menaces(nil, _), do: []

  defp check_menaces(%Piece{color: color, position: position}, %Board{pieces: pieces} = board) do
    Enum.filter(
      pieces,
      &(&1.color != color and position in possible_positions(board, &1.position))
    )
  end

  def menacing_king_pieces(%Board{} = board, color) do
    Enum.find(board.pieces, &(&1.class == :king and &1.color == color))
    |> check_menaces(board)
  end

  def menacing_king_positions(%Board{} = board, color) do
    menacing_king_pieces(board, color)
    |> Enum.map(& &1.position)
  end
end
