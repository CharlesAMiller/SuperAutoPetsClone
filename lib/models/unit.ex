defmodule Unit do

  defstruct id: 0,
    type: :fish,
    level: 1,
    power: 1,
    health: 1,
    status: nil,
    equipment: nil,
    is_summoned: false,
    summonded_by: nil

    def createFish(level \\ 1) do
      %Unit{type: :fish, power: 2, health: 3, level: level}
    end

    def createOtter(level \\ 1) do
      %Unit{type: :otter, power: 1, health: 2, level: level}
    end

    def createMosquito(level \\ 1) do
      %Unit{type: :mosquito, power: 2, health: 2, level: level}
    end

    def createBlowfish(level \\ 1) do
      %Unit{type: :blowfish, power: 3, health: 5, level: level}
    end

    def createCrocodile(level \\ 1) do
      %Unit{type: :crocodile, power: 8, health: 4, level: level}
    end

    def createLeopard(level \\ 1) do
      %Unit{type: :leopard, power: 10, health: 4, level: level}
    end

    def createDolphin(level \\ 1) do
      %Unit{type: :dolphin, power: 4, health: 6, level: level}
    end

    def createUnit(type \\ :fish, power \\ 2, health \\ 3, level \\ 1) do
      %Unit{type: type, power: power, health: health, level: level}
    end

end
