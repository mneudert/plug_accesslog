defmodule Plug.AccessLog.Application do
  @moduledoc false

  use Application

  alias Plug.AccessLog.Logfiles
  alias Plug.AccessLog.WAL
  alias Plug.AccessLog.Writer

  def start(_type, _args) do
    options = [strategy: :one_for_one, name: Plug.AccessLog.Supervisor]

    children = [
      Logfiles,
      Writer,
      WAL
    ]

    Supervisor.start_link(children, options)
  end
end
