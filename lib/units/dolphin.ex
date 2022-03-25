defmodule Dolphin do

  @dolphin_special_damage 5

  def find_target(enemies) do
    enemies |> Enum.min_by(fn e -> e.health end)
  end

  def on_start(unit, friends, enemies) do
    target = find_target(enemies)
    [%Event{type: :attack, to: target, from: unit, value: unit.level * @dolphin_special_damage}]
  end

end
