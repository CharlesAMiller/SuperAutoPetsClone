defmodule Crocodile do

  @crocodile_special_damage 8

  # Targets last unit in the opposing team's lineup
  def on_start(unit, friends, enemies) do
    last_enemy_id = Enum.map(enemies, fn e -> e.id end) |> Enum.max
    target = Enum.find(enemies, fn e -> e.id == last_enemy_id end)
    [%Event{type: :attack, from: unit, to: target, value: @crocodile_special_damage * unit.level}]
  end

end
