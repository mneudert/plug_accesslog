defmodule Plug.AccessLog.WAL do
  @moduledoc """
  Write-Ahead-Log agent.
  """

  @doc """
  Starts the agent.
  """
  @spec start_link() :: Agent.on_start
  def start_link(), do: Agent.start_link(fn -> %{} end, name: __MODULE__)

  @doc """
  Flushes (returns and clears) all log messages.
  """
  @spec flush(String.t) :: list
  def flush(logfile) do
    Agent.get_and_update __MODULE__, fn messages ->
      { messages[logfile] || [], Map.put(messages, logfile, []) }
    end
  end

  @doc """
  Tracks a new log message for delayed writing.
  """
  @spec log(String.t, String.t) :: :ok
  def log(message, logfile) do
    Agent.update __MODULE__, fn (messages) ->
      Map.put(messages, logfile, [ message | messages[logfile] || [] ])
    end
  end
end
