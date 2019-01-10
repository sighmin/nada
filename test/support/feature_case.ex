defmodule NadaWeb.FeatureCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.DSL
      import Wallaby.Query

      alias Nada.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      import NadaWeb.Router.Helpers
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Nada.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Nada.Repo, {:shared, self()})
    end

    metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(Nada.Repo, self())
    {:ok, session} = Wallaby.start_session(metadata: metadata)
    on_exit fn -> Wallaby.end_session(session) end
    {:ok, session: session, metadata: metadata}
  end
end
