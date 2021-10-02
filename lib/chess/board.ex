defmodule Chess.Board do
  defstruct piece_list: []

  alias Chess.Board
  alias Chess.Piece
  alias Chess.Pawn
  alias Chess.Rook
  alias Chess.Knight
  alias Chess.Bishop
  alias Chess.Queen
  alias Chess.King

  def new do
    %Board{piece_list: (for color <- Piece.color_list, type <- Piece.type_list, do: Piece.new(type,color))}
  end

  def get_piece(%Board{} = board,position) do
    Enum.find(board,& &1.position == position)
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


  def delta_available(position) do
    {x,y} = position_2_xy(position)
    axf = 7 - x;
    axb = 0 - x;
    ayf = 7 - y;
    ayb = 0 - y;
    {axf,axb,ayf,ayb}
  end

  defp minxy do
    <<minx::utf8,miny::utf8>> = "a1"
    {minx,miny}
  end

  def position_2_xy(position) do
    {minx,miny} = minxy()
    <<x::utf8,y::utf8>> = position
    {x-minx,y-miny}
  end

  def xy_2_position({x,y}) do
    {minx,miny} = minxy()
    <<minx+x::utf8,miny+y::utf8>>
  end

  def new_position(position,deltax,deltay) do
    {axf,axb,ayf,ayb} = delta_available(position)

    cond do
      deltax < axb or
      deltax > axf or
      deltay < ayb or
      deltay > ayf ->
        {:invalid_position,position}
      true ->
        <<x::utf8,y::utf8>> = position
        x = x + deltax
        y = y + deltay
        {:ok,<<x::utf8,y::utf8>>}
    end
  end

  def new_position(position,:white,deltax,deltay), do: new_position(position,deltax,deltay)
  def new_position(position,:black,deltax,deltay), do: new_position(position,-deltax,-deltay)

  def possible_positions(%Board{} = board,position) do
    piece = get_piece(board,position)

    case piece.class do
      :pawn -> Pawn.possible_positions(board,position,piece)
      :rook -> Rook.possible_positions(board,position,piece)
      :knight -> Knight.possible_positions(board,position,piece)
      :bishop -> Bishop.possible_positions(board,position,piece)
      :queen -> Queen.possible_positions(board,position,piece)
      :king -> King.possible_positions(board,position,piece)
      _ -> []
    end
  end

  def possible_positions(direction,%Board{} = board,position,%Piece{} = piece,max_iter,list,iter) do
    iter = iter + 1

    {status,p} = case direction do
      :up -> new_position(position,piece.color,0,1)
      :down -> new_position(position,piece.color,0,-1)
      :right -> new_position(position,piece.color,1,0)
      :left -> new_position(position,piece.color,-1,0)
      :up_right -> new_position(position,piece.color,1,1)
      :up_left -> new_position(position,piece.color,-1,1)
      :down_right -> new_position(position,piece.color,1,-1)
      _ -> new_position(position,piece.color,-1,-1)
    end

    if status == :invalid_position do
      list
    else
      piece_p = get_piece(board,p)

      if piece_p == nil do
        list = [p|list]
        if iter == max_iter do
          list
        else
          possible_positions(direction,board,p,piece,max_iter,list,iter)
        end
      else
        if piece_p.color == piece.color do
          list
        else
          [p|list]
        end
      end
    end
  end

  def move(%Board{} = board,from,to) do
    piece = get_piece(board,from)

    if(piece == nil) do
      {:empty_position,board}
    else
      pp = possible_positions(board,from)

      if to not in pp do
        {:not_allowed,board}
      else
        piece_to_del = get_piece(board,to)
        board = List.delete(board,piece_to_del)
        {:ok,Enum.map(board, fn x -> if x.position == from, do: %{piece | position: to, moved: true}, else: x end)}
      end
    end
  end

  defp print_line(%Board{} = board,y,marks) do
    linha =
      for x <- 0..7 do
        position = xy_2_position({x,y})
        piece = get_piece(board,position)

        if position in marks do
          if piece == nil, do: "<>", else: "><"
        else
          if piece == nil, do: "  ", else: Piece.get_color(piece.color) <> Piece.get_name(piece.class)
        end
      end
      |> Enum.join()

    "#{y+1} #{linha}"
  end

  def print(%Board{} = board,pos_highlight \\ "") do
    marks = if pos_highlight == "", do: [], else: possible_positions(board,pos_highlight)

    for y <- 7..0 do
      IO.puts(print_line(board,y,marks))
    end
    IO.puts("\n  A B C D E F G H ")
  end
end
