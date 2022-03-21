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

    def createFish() do
      %Unit{type: :fish, power: 2, health: 3}
    end

    def createMosquito() do
      %Unit{type: :mosquito, power: 2, health: 2}
    end

end
