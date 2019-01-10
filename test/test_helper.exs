ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Nada.Repo, :manual)

{:ok, _} = Application.ensure_all_started(:ex_machina)
{:ok, _} = Application.ensure_all_started(:wallaby)
Application.put_env(:wallaby, :base_url, NadaWeb.Endpoint.url())
