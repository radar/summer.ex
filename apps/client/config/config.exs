# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :client, Client.Repo,
  database: "railsbot",
  hostname: "localhost"

config :client, ecto_repos: [Client.Repo]
