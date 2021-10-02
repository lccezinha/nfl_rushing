# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     NflRushing.Repo.insert!(%NflRushing.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

{:ok, result} = NflRushing.Stats.Parser.parse_players("priv/rushing.json")

NflRushing.Repo.insert_all(NflRushing.Stats.Player, result)
