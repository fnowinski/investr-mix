defmodule Investr.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      Investr.Repo,
    ]

    opts = [strategy: :one_for_one, name: Investr.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
