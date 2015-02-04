defmodule Plug.AccessLog.Logfiles do
  @moduledoc """
  Logfile agent.
  """

  @doc """
  Starts the logfile agent.
  """
  @spec start_link() :: Agent.on_start
  def start_link(), do: Agent.start_link(fn -> %{} end, name: __MODULE__)

  @doc """
  Returns the logfile device for writing.
  """
  @spec get(logfile :: String.t) :: File.io_device | nil
  def get(logfile) do
    case get_device(logfile) do
      nil                        -> open(logfile)
      device when is_pid(device) -> get_or_reopen(device, logfile)
      other_device               -> other_device
    end
  end

  defp get_or_reopen(device, logfile) do
    case File.exists?(logfile) && Process.alive?(device) do
      true  -> device
      false ->
        case File.open(logfile, [ :append, :utf8 ]) do
          { :error, _ }   -> nil
          { :ok, device } -> replace(logfile, device)
        end
    end
  end

  @doc """
  Opens a logfile for future writing.
  """
  @spec open(logfile :: String.t) :: File.io_device | nil
  def open(logfile) do
    case File.open(logfile, [ :append, :utf8 ]) do
      { :error, _ }   -> nil
      { :ok, device } -> set(logfile, device)
    end
  end

  @doc """
  Replaces the io_device associated with a logfile.

  The already registered (if any) io_device will be closed
  using `File.close/1`.

  The new io_device associated with the logfile will be returned.
  """
  @spec replace(logfile :: String.t, new_device :: File.io_device) :: File.io_device
  def replace(logfile, new_device) do
    case get_device(logfile) do
      nil        -> nil
      old_device -> File.close(old_device)
    end

    Agent.update(__MODULE__, &Map.put(&1, logfile, new_device))

    new_device
  end

  @doc """
  Sets the io_device associated with a logfile.

  If a logfile is already associated with an io_device the passed one
  will be closed using `File.close/1`.

  The new io_device associated with the logfile will be returned.
  """
  @spec set(logfile :: String.t, new_device :: File.io_device) :: File.io_device
  def set(logfile, new_device) do
    Agent.update(__MODULE__, &Map.put_new(&1, logfile, new_device))

    case get_device(logfile) do
      ^new_device -> new_device
      old_device  ->
        File.close(new_device)
        old_device
    end
  end


  # Internal utility methods

  defp get_device(logfile) do
    Agent.get(__MODULE__, &Map.get(&1, logfile, nil))
  end
end
