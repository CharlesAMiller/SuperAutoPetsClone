defmodule AutoBattler do
  @moduledoc """
  Documentation for `AutoBattler`.
  """

  @doc """
  Hello world.

  """
  @num_units 6

  def mosquito_start(enemies) do
    Enum.random(enemies)
  end

  def start_handler(unit, friends, enemies) do
    case unit.type do
      :mosquito ->
        {:attack, unit, mosquito_start(enemies)}

      _ ->
        nil
    end
  end

  """
    Recursive driver for battle
  """

  def sim(team1, team2, events) do
  end

  """
    Primary logic that handles in-game battles.
    This function is recursively called, and expects that the given events parameter
    will be non empty. In the case this function returns an empty events list, it should indicate that the battle is over.
  """

  @spec battle(any, any, list) :: {any, any, any}
  def battle(team1, team2, events) when length(events) > 0 do
    # Process a single event per loop.
    {event, evs} = events |> List.pop_at(0)

    {t1, t2, e} =
      case event.type do
        :battle ->
          # Find those involved in the battle
          from_unit = Enum.find(team1, fn u -> u.id == event.from.id end)
          to_unit = Enum.find(team2, fn u -> u.id == event.to.id end)

          # Ensure the two units are both alive. Otherwise, the event won't resolve
          {t1, t2, e} =
            if from_unit.health > 0 and to_unit.health > 0 do
              damaged_from = Map.update(from_unit, :health, 0, fn value -> value - to_unit.power end)
              damaged_to = Map.update(to_unit, :health, 0, fn value -> value - from_unit.power end)

              # This is where we'd put damaged or killed event handling ...

              t1 =
                List.replace_at(
                  team1,
                  Enum.find_index(team1, fn u -> u.id == damaged_from.id end),
                  damaged_from
                )

              t2 =
                List.replace_at(
                  team2,
                  Enum.find_index(team2, fn u -> u.id == damaged_to.id end),
                  damaged_to
                )

              {t1, t2, evs}
            else
              {team1, team2, evs}
            end

        :start ->
          {team1, team2, evs}
      end

    {t1_1, t2_1, e_1} =
      if Enum.empty?(e) do
        # We've exhausted events. Check if there are still units to battle
        unless Enum.all?(t1, fn u -> u.health <= 0 end) or
                 Enum.all?(t2, fn u -> u.health <= 0 end) do
          team1_unit = Enum.find(t1, fn u -> u.health >= 0 end)
          team2_unit = Enum.find(t2, fn u -> u.health >= 0 end)
          battle_event = %Event{type: :battle, from: team1_unit, to: team2_unit}
          {team1, team2, [battle_event]}
        else
          # The match is over
          {t1, t2, []}
        end
      end

    {t1_1, t2_1, e_1}
  end
end
