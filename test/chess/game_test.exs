defmodule Chess.GameTest do
  use ExUnit.Case

  alias Chess.{Game}

  setup do
    game = Game.new()

    %{
      game: game
    }
  end

  describe "new/0" do
    test "success return" do
      assert %Game{} = Game.new()
    end
  end

  describe "move/3" do
    test "not allowed", %{game: game} do
      {:not_allowed, _} = Game.move(game, "a1", "a2")
    end

    test "invalid position", %{game: game} do
      {:invalid_position, _} = Game.move(game, "a6", "a5")
    end

    test "invalid color", %{game: game} do
      {:invalid_color, _} = Game.move(game, "a7", "a6")
    end

    test "success", %{game: game} do
      {:ok, %Game{turn: :black}} = Game.move(game, "a2", "a3")
    end
  end
end
