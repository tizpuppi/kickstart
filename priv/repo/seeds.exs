# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Kickstart.Repo.insert!(%Kickstart.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Kickstart.Repo
alias Kickstart.User
alias Kickstart.Authentication

user = %User{username: "test", email: "test@example.com", password: "123456"}
identity = %Authentication{provider: "identity",
                           uid: user.email,
                           token: Comeonin.Bcrypt.hashpwsalt(user.password),
                           user: user}

Repo.insert!(identity)

