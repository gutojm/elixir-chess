defmodule Chess do
  @moduledoc """
  Documentation for `Chess`.
  """
  alias Chess.{Game, TUI}

  def play(:tui) do
    Game.new()
    |> TUI.play()
  end

  def play(_), do: {:error, :undefined_interface}
end
