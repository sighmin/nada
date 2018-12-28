defmodule Nada.Repo do
  use Ecto.Repo,
    otp_app: :nada,
    adapter: Ecto.Adapters.Postgres
end
