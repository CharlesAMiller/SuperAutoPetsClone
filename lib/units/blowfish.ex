defmodule Blowfish do

  def on_hurt(unit, friends, enemies) do
    target = enemies |> Enum.random
    [%Event{type: :attack, from: unit, to: target, value: 2 * unit.level}]
  end

end
