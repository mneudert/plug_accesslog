defmodule Plug.AccessLog.Logfiles do
  @moduledoc """
  Logfile agent.
  """

  @doc """
  Starts the logfile agent.
  """
  @spec start_link() :: Agent.on_start
  def start_link(), do: Agent.start_link(fn -> %{} end, name: __MODULE__)
end
