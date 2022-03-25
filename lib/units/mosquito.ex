defmodule Mosquito do

  @mosquito_special_damage 1

  def find_targets(unit, enemies) do
    enemies |> Enum.take_random(unit.level)
  end

  def on_start(unit, friends, enemies) do
    find_targets(unit, enemies) |>
      Enum.map(fn enemy -> %Event{type: :attack, to: enemy, from: unit, value: @mosquito_special_damage} end)
  end

end
