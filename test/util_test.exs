defmodule UtilTest do
  use ExUnit.Case

  test "tag_ids in 1v1" do
    {team1, team2} = Util.tag_ids([Unit.createFish], [Unit.createFish])
    assert hd(team1).id == 0
    assert hd(team2).id == 1
  end

  test "tag_ids in 1v2" do
    {team1, team2} = Util.tag_ids([Unit.createFish], [Unit.createFish, Unit.createFish])
    assert hd(team1).id == 0
    assert Enum.at(team2, 0).id == 1
    assert Enum.at(team2, 1).id == 2
  end

  test "tag_ids in 2v1" do
    {team1, team2} = Util.tag_ids([Unit.createFish, Unit.createFish], [Unit.createFish])
    assert Enum.at(team1, 0).id == 0
    assert Enum.at(team1, 1).id == 1
    assert Enum.at(team2, 0).id == 2
  end

end
