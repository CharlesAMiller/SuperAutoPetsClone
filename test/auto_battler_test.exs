defmodule AutoBattlerTest do
  use ExUnit.Case
  doctest AutoBattler

  test "fish vs otter sim" do
    assert :team1 = AutoBattler.sim(
      [%Unit{type: :fish, level: 1, power: 2, health: 3}],
      [%Unit{type: :otter, level: 1, power: 1, health: 2}],
      [%Event{type: :start}])
  end

  test "pig vs mosquito sim" do
    assert :team2 = AutoBattler.sim([%Unit{id: 1, type: :pig, power: 3, health: 1}], [%Unit{id: 2, type: :mosquito, power: 2, health: 2}], [%Event{type: :start}])
  end

  test "fish vs fish sim" do
    assert :tie = AutoBattler.sim([Unit.createFish], [Unit.createFish], [%Event{type: :start}])
  end

  test "2x fish vs 2x fish sim" do
    {team1, team2} = Util.tag_ids([Unit.createFish, Unit.createFish], [Unit.createFish, Unit.createFish])
    assert :tie = AutoBattler.sim(team1, team2, [%Event{type: :start}])
  end

  test "crocodile vs dolphin sim" do
    {team1, team2} = Util.tag_ids([Unit.createCrocodile], [Unit.createDolphin])
    assert :tie = AutoBattler.sim(team1, team2, [%Event{type: :start}])
  end

  test "crocodile vs dolphin and otter sim" do
    {team1, team2} = Util.tag_ids([Unit.createCrocodile], [Unit.createDolphin, Unit.createOtter])
    assert :team2 = AutoBattler.sim(team1, team2, [%Event{type: :start}])
  end

  test "3x mosquito vs leopard sim" do
    {team1, team2} = Util.tag_ids([Unit.createMosquito, Unit.createMosquito, Unit.createMosquito], [Unit.createLeopard])
    assert :team1 = AutoBattler.sim(team1, team2, [%Event{type: :start}])
  end

  test "5x mosquito vs 5x leopard sim" do
    {team1, team2} = Util.tag_ids([Unit.createMosquito, Unit.createMosquito, Unit.createMosquito, Unit.createMosquito, Unit.createMosquito], [Unit.createLeopard, Unit.createLeopard, Unit.createLeopard, Unit.createLeopard, Unit.createLeopard])
    assert :team2 = AutoBattler.sim(team1, team2, [%Event{type: :start}])
  end

  test "2x fish vs 2x fish" do
    {team1, team2} = Util.tag_ids([Unit.createFish, Unit.createFish], [Unit.createFish, Unit.createFish])

    {team1_1, team2_1, events_1} = AutoBattler.battle(team1, team2, [%Event{type: :start}])
    assert team1 == team1_1
    assert team2 == team2_1
    assert events_1 == [%Event{type: :battle, from: Enum.find(team1, fn x -> x.id == 0 end), to: Enum.find(team2, fn x -> x.id == 2 end)}]

    {team1_2, team2_2, events_2} = AutoBattler.battle(team1_1, team2_1, events_1)
    assert team1_2 == [Util.find_by_tag(team1, 0) |> Map.put(:health, 1), Util.find_by_tag(team1, 1)]
    assert team2_2 == [Util.find_by_tag(team2, 2) |> Map.put(:health, 1), Util.find_by_tag(team2, 3)]
    assert events_2 == [%Event{type: :battle, from: Util.find_by_tag(team1_2, 0), to: Util.find_by_tag(team2_2, 2)}]

    {team1_3, team2_3, events_3} = AutoBattler.battle(team1_2, team2_2, events_2)
    assert team1_3 == [Util.find_by_tag(team1_2, 0) |> Map.put(:health, -1), Util.find_by_tag(team1_2, 1)]
    assert team2_3 == [Util.find_by_tag(team2_2, 2) |> Map.put(:health, -1), Util.find_by_tag(team2_2, 3)]
    assert events_3 == [%Event{type: :battle, from: Util.find_by_tag(team1_3, 1), to: Util.find_by_tag(team2_3, 3)}]

    {team1_4, team2_4, events_4} = AutoBattler.battle(team1_3, team2_3, events_3)
    assert team1_4 == [Util.find_by_tag(team1_3, 0), Util.find_by_tag(team1_3, 1) |> Map.put(:health, 1)]
    assert team2_4 == [Util.find_by_tag(team2_3, 2), Util.find_by_tag(team2_3, 3) |> Map.put(:health, 1)]
    assert events_4 == [%Event{type: :battle, from: Util.find_by_tag(team1_4, 1), to: Util.find_by_tag(team2_4, 3)}]

    {team1_5, team2_5, events_5} = AutoBattler.battle(team1_4, team2_4, events_4)
    assert team1_5 == [Util.find_by_tag(team1_3, 0), Util.find_by_tag(team1_3, 1) |> Map.put(:health, -1)]
    assert team2_5 == [Util.find_by_tag(team2_3, 2), Util.find_by_tag(team2_3, 3) |> Map.put(:health, -1)]
    assert events_5 == []

  end

  test "pig vs mosquito" do
    {team1, team2, events} = AutoBattler.battle([%Unit{type: :pig, power: 3, health: 1}], [%Unit{type: :mosquito, health: 2, power: 2}], [%Event{type: :start}])
    assert team1 == [%Unit{type: :pig, power: 3, health: 1}]
    assert team2 == [%Unit{type: :mosquito, health: 2, power: 2}]
    assert events == [%Event{type: :attack, to: hd(team1), from: hd(team2), value: 1}]

    {team1_1, team2_1, events_1} = AutoBattler.battle(team1, team2, events)
    assert team1_1 == [%Unit{type: :pig, power: 3, health: 0}]
    assert team2_1 == team2
    assert events_1 == []

  end

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
