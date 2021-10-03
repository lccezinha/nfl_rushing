defmodule NflRushing.StatsTest do
  use NflRushing.DataCase

  alias NflRushing.Factory
  alias NflRushing.Stats

  def player_factory(attrs \\ %{}), do: Factory.insert!(:player, attrs)

  describe "list/1" do
    test "with no data returns empty list" do
      assert [] == Stats.list()
    end

    test "with data returns list" do
      player_factory()
      player_factory()

      refute [] == Stats.list()
      assert Stats.list() |> Enum.count() == 2
    end

    test "with whole name param given as filter must filter by name" do
      player_one = player_factory(%{name: "Testing filter"})
      player_two = player_factory()

      records = Stats.list(%{"name_filter" => player_one.name})
      ids = Enum.map(records, fn record -> record.id end)

      assert Enum.count(records) == 1
      assert player_one.id in ids
      refute player_two.id in ids
    end

    test "with partial name param given as filter must filter by name" do
      player_one = player_factory(%{name: "Testing filter"})
      player_two = player_factory()
      player_three = player_factory(%{name: "Random filter"})

      records = Stats.list(%{"name_filter" => "Testing"})
      ids = Enum.map(records, fn record -> record.id end)

      assert Enum.count(records) == 1
      assert player_one.id in ids
      refute player_two.id in ids
      refute player_three.id in ids

      records = Stats.list(%{"name_filter" => "filter"})
      ids = Enum.map(records, fn record -> record.id end)

      assert Enum.count(records) == 2
      assert player_one.id in ids
      refute player_two.id in ids
      assert player_three.id in ids
    end

    test "with name param that does not match as filter must return empty list" do
      player_factory(%{name: "Testing filter"})
      player_factory()

      records = Stats.list(%{"name_filter" => "Not valid name"})

      assert [] == records
    end
  end
end
