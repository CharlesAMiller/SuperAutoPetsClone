defmodule PetsTest do
  @moduledoc """
  This test module is meant to individually test the special behaviors of different units/pets.
  TODO: Consider moving these tests to different files, as the number of tests increases.
  """
  use ExUnit.Case

  test "Mosquito on_start level 1" do
    team1 = [Unit.createMosquito]
    team2 = [Unit.createFish]

    mosquito = hd(team1)
    assert Mosquito.on_start(mosquito, team1, team2) == [%Event{type: :attack, from: mosquito, to: hd(team2), value: 1}]
  end

  test "Mosquito on_start level 2" do
    team1 = [Unit.createMosquito(2)]
    team2 = [Unit.createFish, Unit.createFish]

    {t1, t2} = Util.tag_ids(team1, team2)

    mosquito = hd(team1)

    mosquito_events = Mosquito.on_start(mosquito, t1, t2)
    assert List.first(t2) != List.last(t2)
    assert Enum.member?(mosquito_events, %Event{type: :attack, from: mosquito, to: List.first(t2), value: 1})
    assert Enum.member?(mosquito_events, %Event{type: :attack, from: mosquito, to: List.last(t2), value: 1})
  end

  test "Mosquito on_start level 3" do
    team1 = [Unit.createMosquito(3)]
    team2 = [Unit.createFish, Unit.createFish, Unit.createFish]

    {t1, t2} = Util.tag_ids(team1, team2)

    mosquito = hd(team1)

    mosquito_events = Mosquito.on_start(mosquito, t1, t2)
    assert mosquito_events |> Enum.uniq |> Enum.count == 3
    assert Enum.member?(mosquito_events, %Event{type: :attack, from: mosquito, to: Enum.at(t2, 0), value: 1})
    assert Enum.member?(mosquito_events, %Event{type: :attack, from: mosquito, to: Enum.at(t2, 1), value: 1})
    assert Enum.member?(mosquito_events, %Event{type: :attack, from: mosquito, to: Enum.at(t2, 2), value: 1})
  end

  test "Blowfish on_hurt level 1" do
    team1 = [Unit.createBlowfish()]
    team2 = [Unit.createFish]

    blowfish = hd(team1)
    blowfish_events = Blowfish.on_hurt(blowfish, team1, team2)
    assert Enum.member?(blowfish_events, %Event{type: :attack, from: blowfish, to: List.first(team2), value: 2})
  end

  test "Blowfish on_hurt level 2" do
    team1 = [Unit.createBlowfish(2)]
    team2 = [Unit.createFish]

    blowfish = hd(team1)
    blowfish_events = Blowfish.on_hurt(blowfish, team1, team2)
    assert Enum.member?(blowfish_events, %Event{type: :attack, from: blowfish, to: List.first(team2), value: 4})
  end

  test "Blowfish on_hurt level 3" do
    team1 = [Unit.createBlowfish(3)]
    team2 = [Unit.createFish]

    blowfish = hd(team1)
    blowfish_events = Blowfish.on_hurt(blowfish, team1, team2)
    assert Enum.member?(blowfish_events, %Event{type: :attack, from: blowfish, to: List.first(team2), value: 6})
  end

  test "Crocodile on_start level 1 with 1 enemy" do
    team1 = [Unit.createCrocodile]
    team2 = [Unit.createFish]

    crocodile = hd(team1)
    crocodile_events = Crocodile.on_start(crocodile, team1, team2)
    assert Enum.member?(crocodile_events, %Event{type: :attack, from: crocodile, to: List.first(team2), value: 8})
  end

  test "Crocodile on_start level 1 with 5 enemies" do
    team1 = [Unit.createCrocodile]
    team2 = [Unit.createFish, Unit.createBlowfish, Unit.createMosquito, Unit.createCrocodile, Unit.createMosquito]

    {t1, t2} = Util.tag_ids(team1, team2)

    crocodile = hd(t1)
    target = List.last(t2)

    crocodile_events = Crocodile.on_start(crocodile, t1, t2)
    assert Enum.member?(crocodile_events, %Event{type: :attack, from: crocodile, to: target, value: 8})
  end

  test "Crocodile on_start level 2" do
    team1 = [Unit.createCrocodile(2)]
    team2 = [Unit.createFish]

    crocodile = hd(team1)
    crocodile_events = Crocodile.on_start(crocodile, team1, team2)
    assert Enum.member?(crocodile_events, %Event{type: :attack, from: crocodile, to: List.first(team2), value: 16})
  end

  test "Crocodile on_start level 2 with 5 enemies" do
    team1 = [Unit.createCrocodile(2)]
    team2 = [Unit.createFish, Unit.createBlowfish, Unit.createMosquito, Unit.createCrocodile, Unit.createMosquito]

    {t1, t2} = Util.tag_ids(team1, team2)

    crocodile = hd(t1)
    target = List.last(t2)

    crocodile_events = Crocodile.on_start(crocodile, t1, t2)
    assert Enum.member?(crocodile_events, %Event{type: :attack, from: crocodile, to: target, value: 16})
  end

  test "Crocodile on_start level 3" do
    team1 = [Unit.createCrocodile(3)]
    team2 = [Unit.createFish]

    crocodile = hd(team1)
    crocodile_events = Crocodile.on_start(crocodile, team1, team2)
    assert Enum.member?(crocodile_events, %Event{type: :attack, from: crocodile, to: List.first(team2), value: 24})
  end

  test "Crocodile on_start level 3 with 5 enemies" do
    team1 = [Unit.createCrocodile(3)]
    team2 = [Unit.createFish, Unit.createBlowfish, Unit.createMosquito, Unit.createCrocodile, Unit.createMosquito]

    {t1, t2} = Util.tag_ids(team1, team2)

    crocodile = hd(t1)
    target = List.last(t2)

    crocodile_events = Crocodile.on_start(crocodile, t1, t2)
    assert Enum.member?(crocodile_events, %Event{type: :attack, from: crocodile, to: target, value: 24})
  end

  test "Leopard on_start level 1" do
    team1 = [Unit.createLeopard]
    team2 = [Unit.createFish]

    leopard = hd(team1)
    assert Leopard.on_start(leopard, team1, team2) == [%Event{type: :attack, from: leopard, to: hd(team2), value: 5}]
  end

  test "Leopard on_start level 2" do
    team1 = [Unit.createLeopard(2)]
    team2 = [Unit.createFish, Unit.createFish]

    {t1, t2} = Util.tag_ids(team1, team2)

    leopard = hd(team1)

    leopard_events = Leopard.on_start(leopard, t1, t2)
    assert List.first(t2) != List.last(t2)
    assert Enum.member?(leopard_events, %Event{type: :attack, from: leopard, to: List.first(t2), value: 5})
    assert Enum.member?(leopard_events, %Event{type: :attack, from: leopard, to: List.last(t2), value: 5})
  end

  test "Leopard on_start level 3" do
    team1 = [Unit.createUnit(:leopard, 12, 4, 3)]
    team2 = [Unit.createFish, Unit.createFish, Unit.createFish]

    {t1, t2} = Util.tag_ids(team1, team2)

    leopard = hd(team1)

    leopard_events = Leopard.on_start(leopard, t1, t2)
    assert leopard_events |> Enum.uniq |> Enum.count == 3
    assert Enum.member?(leopard_events, %Event{type: :attack, from: leopard, to: Enum.at(t2, 0), value: 6})
    assert Enum.member?(leopard_events, %Event{type: :attack, from: leopard, to: Enum.at(t2, 1), value: 6})
    assert Enum.member?(leopard_events, %Event{type: :attack, from: leopard, to: Enum.at(t2, 2), value: 6})
  end

  test "Dolphin on_start level 1" do
    team1 = [Unit.createDolphin]
    team2 = [Unit.createFish]

    dolphin = hd(team1)
    assert Dolphin.on_start(dolphin, team1, team2) == [%Event{type: :attack, from: dolphin, to: hd(team2), value: 5}]
  end

  test "Dolphin on_start level 2" do
    team1 = [Unit.createDolphin(2)]
    team2 = [Unit.createFish]

    dolphin = hd(team1)
    assert Dolphin.on_start(dolphin, team1, team2) == [%Event{type: :attack, from: dolphin, to: hd(team2), value: 10}]
  end

  test "Dolphin on_start level 3" do
    team1 = [Unit.createDolphin(3)]
    team2 = [Unit.createFish]

    dolphin = hd(team1)
    assert Dolphin.on_start(dolphin, team1, team2) == [%Event{type: :attack, from: dolphin, to: hd(team2), value: 15}]
  end
  test "Dolphin on_start level 1 1v2 with different health" do
    team1 = [Unit.createDolphin]
    team2 = [Unit.createFish, Unit.createOtter]

    {t1, t2} = Util.tag_ids(team1, team2)

    dolphin = hd(team1)
    assert Dolphin.on_start(dolphin, t1, t2) == [%Event{type: :attack, from: dolphin, to: List.last(t2), value: 5}]
  end

  test "Dolphin on_start level 1 1v2 with same health" do
    team1 = [Unit.createDolphin]
    team2 = [Unit.createMosquito, Unit.createOtter]

    {t1, t2} = Util.tag_ids(team1, team2)

    dolphin = hd(team1)
    assert Dolphin.on_start(dolphin, t1, t2) == [%Event{type: :attack, from: dolphin, to: hd(t2), value: 5}]
  end

end
