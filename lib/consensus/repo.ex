defmodule Consensus.Repo do
  use Ecto.Repo,
    otp_app: :consensus,
    adapter: Ecto.Adapters.Postgres
end
