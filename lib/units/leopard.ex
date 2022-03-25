defmodule Leopard do

  @leopard_special_damage_perc 0.5

  def find_targets(unit, enemies) do
    enemies |> Enum.take_random(unit.level)
  end

  def on_start(unit, friends, enemies) do
    find_targets(unit, enemies) |>
      Enum.map(fn enemy -> %Event{type: :attack, to: enemy, from: unit, value: round(unit.power * @leopard_special_damage_perc)} end)
  end

end
