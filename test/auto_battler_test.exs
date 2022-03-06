defmodule AutoBattlerTest do
  use ExUnit.Case
  doctest AutoBattler

  test "fish vs otter" do
    {team1, team2, events} = AutoBattler.battle(
      [%Unit{type: :fish, level: 1, power: 2, health: 3}],
      [%Unit{type: :otter, level: 1, power: 1, health: 2}],
      [%Event{type: :start}])

    # Should have run start command, and enqueued a battle event.
    assert team1 == [%Unit{type: :fish, level: 1, power: 2, health: 3}]
    assert team2 == [%Unit{type: :otter, level: 1, power: 1, health: 2}]
    assert events == [%Event{type: :battle, from: hd(team1), to: hd(team2)}]

    # Should have run battle event. Units healht should have been altered. No more events should be needed.
    {team1_2, team2_2, events_2} = AutoBattler.battle(team1, team2, events)
    assert team1_2 == [%Unit{type: :fish, power: 2, health: 2}]
    assert team2_2 == [%Unit{type: :otter, power: 1, health: 0}]
    assert events_2 == []
  end

end
