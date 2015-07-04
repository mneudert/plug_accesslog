defmodule Plug.AccessLog.Application do
  @moduledoc """
  AccessLog Application.

  Takes care of starting the state agent.
  """

  use Application

  alias Plug.AccessLog.Logfiles
  alias Plug.AccessLog.Writer


  def start(_type, _args) do
    import Supervisor.Spec

    options  = [ strategy: :one_for_one, name: __MODULE__.Supervisor ]
    children = [
      worker(Logfiles, []),
      worker(GenEvent, [[ name: Writer ]])
    ]

    sup = Supervisor.start_link(children, options)
    :ok = GenEvent.add_handler(Writer, Writer, [])

    sup
  end
end
