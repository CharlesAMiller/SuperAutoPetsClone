defmodule Util do

  def tag_id([head | tail], id_start) do
    # TODO: Clean me up. I know there is a cleaner way to do this.
    if length(tail) > 0 do
      [Map.update!(head, :id, fn _ -> id_start end)] ++ tag_id(tail, id_start + 1)
    else
      [Map.update!(head, :id, fn _ -> id_start end)]
    end
  end

  def tag_ids(team1, team2) do
    t1 = tag_id(team1, 0)
    t2 = tag_id(team2, List.last(t1).id + 1)
    {t1, t2}
  end

  def find_by_tag(team, id) do
    Enum.find(team, fn x -> x.id == id end)
  end

end
