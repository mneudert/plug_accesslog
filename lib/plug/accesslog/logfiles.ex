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
      nil    -> open(logfile)
      device -> device
    end
  end

  @doc """
  Opens a logfile for future writing.
  """
  @spec open(logfile :: String.t) :: File.io_device | nil
  def open(logfile) do
    case File.open(logfile, [ :write, :utf8 ]) do
      { :error, _ }   -> nil
      { :ok, device } -> save_device(logfile, device)
    end
  end


  defp get_device(logfile) do
    Agent.get(__MODULE__, &Map.get(&1, logfile, nil))
  end

  defp save_device(logfile, new_device) do
    Agent.update(__MODULE__, &Map.put_new(&1, logfile, new_device))

    case get_device(logfile) do
      ^new_device -> new_device
      old_device  ->
        File.close(new_device)
        old_device
    end
  end
end
