defmodule Plug.AccessLog.Application do
  @moduledoc """
  AccessLog Application.

  Takes care of starting the state agent.
  """

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    options  = [ strategy: :one_for_one, name: __MODULE__.Supervisor ]
    children = [ worker(Plug.AccessLog.Logfiles, []) ]

    Supervisor.start_link(children, options)
  end
end
