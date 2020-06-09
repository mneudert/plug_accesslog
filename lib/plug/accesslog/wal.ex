defmodule Plug.AccessLog.WAL do
  @moduledoc false

  @doc """
  Starts the agent.
  """
  @spec start_link() :: Agent.on_start()
  def start_link, do: Agent.start_link(fn -> %{} end, name: __MODULE__)

  @doc """
  Flushes (returns and clears) all log messages.
  """
  @spec flush(String.t()) :: list
  def flush(logfile) do
    __MODULE__
    |> Agent.get_and_update(fn messages ->
      {messages[logfile] || [], Map.put(messages, logfile, [])}
    end)
    |> Enum.reverse()
  end

  @doc """
  Tracks a new log message for delayed writing.
  """
  @spec log(String.t(), String.t()) :: :ok
  def log(message, logfile) do
    Agent.update(__MODULE__, fn messages ->
      Map.put(messages, logfile, [message | messages[logfile] || []])
    end)
  end

  @doc """
  Returns the list of logfiles with entries.
  """
  @spec logfiles() :: list
  def logfiles do
    Agent.get(__MODULE__, &Map.keys/1)
  end
end
