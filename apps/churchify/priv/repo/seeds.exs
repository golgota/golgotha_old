# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Churchify.Repo.insert!(%Churchify.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Churchify.Auth

admin_email = System.get_env("ADMIN_EMAIL") || "admin@mail.com"

{:ok, _} = Auth.create_user(%{email: admin_email})
