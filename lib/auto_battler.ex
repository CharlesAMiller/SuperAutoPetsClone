defmodule AutoBattler do
  @moduledoc """
  Documentation for `AutoBattler`.
  """

  @doc """
  Hello world.

  """
  @num_units 6

  def start(team1, team2, [team1_head | team1_tail], [team2_head | team2_tail], events) do
    team1_events = start_handler(team1_head, team1, team2)
    team2_events = start_handler(team2_head, team2, team1)
    start(team1_tail, team2_tail, team1_tail, team2_tail, events ++ team1_events ++ team2_events)
  end

  def start(team1, team2, [], [], events) do
    events
  end

  def start_handler(unit, friends, enemies) do
    case unit.type do
      :mosquito ->
        Mosquito.on_start(unit, friends, enemies)
      _ ->
       []
    end
  end

  def on_hurt_handler(unit, friends, enemies) do
    case unit.type do
      :pufferfish ->
        Pufferfish.on_hurt(unit, friends, enemies)
      _ ->
        []
    end
  end

  """
    Recursive driver for battle
  """
  @spec sim(any, any, list) :: :team1 | :team2 | :tie
  def sim(team1, team2, events) do
    cond do
      length(events) > 0 ->
        {t1, t2, e} = battle(team1, team2, events)
        sim(t1, t2, e)
      true ->
        is_team1_fainted = Enum.all?(team1, fn u -> u.health <= 0 end)
        is_team2_fainted = Enum.all?(team2, fn u -> u.health <= 0 end)
        cond do
          is_team1_fainted and is_team2_fainted ->
            :tie
          is_team1_fainted ->
            :team2
          true ->
            :team1
        end
    end
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

    all_units = team1 ++ team2

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

        :attack ->
          from_unit = Enum.find(all_units, fn u -> u.id == event.from.id end)
          to_unit = Enum.find(all_units, fn u -> u.id == event.to.id end)

          damaged_to = Map.update(to_unit, :health, 0, fn value -> value - event.value end)
          damaged_team = if Enum.member?(team1, to_unit), do: team1, else: team2
          updated_damage_team = List.replace_at(damaged_team, Enum.find_index(damaged_team, fn u -> u.id == damaged_to.id end), damaged_to)
          cond do
            damaged_team == team1 ->
              {updated_damage_team, team2, evs}
            true ->
              {team1, updated_damage_team, evs}
          end

        :start ->
          start_events = start(team1, team2, team1, team2, [])
          {team1, team2, evs ++ start_events}
      end

    {t1_1, t2_1, e_1} =
      if Enum.empty?(e) do
        # We've exhausted events. Check if there are still units to battle
        if Enum.any?(t1, fn u -> u.health > 0 end) and
            Enum.any?(t2, fn u -> u.health > 0 end) do
          team1_unit = Enum.filter(t1, fn u -> u.health > 0 end) |> Enum.sort(fn u1, u2 -> u1.health <= u2.health end) |> hd()
          team2_unit = Enum.filter(t2, fn u -> u.health > 0 end) |> Enum.sort(fn u1, u2 -> u1.health <= u2.health end) |> hd()
          battle_event = %Event{type: :battle, from: team1_unit, to: team2_unit}
          {t1, t2, [battle_event]}
        else
          # The match is over
          {t1, t2, []}
        end
      else
        {t1, t2, e}
      end
  end
end
