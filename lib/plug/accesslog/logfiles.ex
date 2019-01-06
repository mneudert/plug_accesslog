defmodule Plug.AccessLog.Logfiles do
  @moduledoc """
  Logfile agent.
  """

  require Logger

  @doc """
  Starts the logfile agent.
  """
  @spec start_link() :: Agent.on_start()
  def start_link, do: Agent.start_link(fn -> %{} end, name: __MODULE__)

  @doc """
  Returns the logfile device for writing.
  """
  @spec get(String.t()) :: File.io_device() | nil
  def get(logfile) do
    case get_device(logfile) do
      {nil, nil} ->
        open(logfile)

      {device, inode} when is_pid(device) ->
        get_or_reopen({device, inode}, logfile)

      {other_device, _} ->
        other_device
    end
  end

  @doc """
  Opens a logfile for future writing.
  """
  @spec open(String.t()) :: File.io_device() | nil
  def open(logfile) do
    case File.open(logfile, [:append, :utf8]) do
      {:ok, device} ->
        set(logfile, device)

      {:error, error} ->
        log_open_error(logfile, error)
        nil
    end
  end

  @doc """
  Replaces the io_device associated with a logfile.

  The already registered (if any) io_device will be closed
  using `File.close/1`.

  The new io_device associated with the logfile will be returned.
  """
  @spec replace(String.t(), File.io_device()) :: File.io_device()
  def replace(logfile, new_device) do
    case get_device(logfile) do
      {nil, nil} -> nil
      {old_device, _} -> File.close(old_device)
    end

    logstate = {new_device, inode(logfile)}

    Agent.update(__MODULE__, &Map.put(&1, logfile, logstate))

    new_device
  end

  @doc """
  Sets the io_device associated with a logfile.

  If a logfile is already associated with an io_device the passed one
  will be closed using `File.close/1`.

  The new io_device associated with the logfile will be returned.
  """
  @spec set(String.t(), File.io_device()) :: File.io_device()
  def set(logfile, new_device) do
    logstate = {new_device, inode(logfile)}

    Agent.update(__MODULE__, &Map.put_new(&1, logfile, logstate))

    case get_device(logfile) do
      {^new_device, _} ->
        new_device

      {old_device, _} ->
        File.close(new_device)
        old_device
    end
  end

  # Internal utility methods

  defp get_device(logfile) do
    Agent.get(__MODULE__, &Map.get(&1, logfile, {nil, nil}))
  end

  defp get_or_reopen({device, inode}, logfile) do
    case Process.alive?(device) && inode == inode(logfile) do
      true ->
        device

      false ->
        case File.open(logfile, [:append, :utf8]) do
          {:ok, device} ->
            replace(logfile, device)

          {:error, error} ->
            log_open_error(logfile, error)
            nil
        end
    end
  end

  defp inode(logpath) do
    case File.stat(logpath) do
      {:ok, stat} -> stat.inode
      _ -> nil
    end
  end

  defp log_open_error(logfile, error) do
    Logger.error("Failed to open logfile #{inspect(logfile)} for writing: #{inspect(error)}")
  end
end
