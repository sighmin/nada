defmodule NadaWeb.FeatureCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.DSL
      import Wallaby.Query
      import NadaWeb.Router.Helpers
    end
  end

  setup _tags do
    {:ok, session} = Wallaby.start_session()
    on_exit fn -> Wallaby.end_session(session) end
    {:ok, session: session}
  end
end
