defmodule Plug.AccessLog.Writer do
  @moduledoc false

  use GenServer

  alias Plug.AccessLog.Logfiles
  alias Plug.AccessLog.WAL

  @doc """
  Starts the message writer.
  """
  @spec start_link(any) :: GenServer.on_start()
  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(%{}) do
    interval =
      :plug_accesslog
      |> Application.get_env(:wal, [])
      |> Keyword.get(:flush_interval, 100)

    timer = Process.send_after(self(), :trigger, interval)
    state = %{flush_interval: interval, flush_timer: timer}

    {:ok, state}
  end

  def terminate(_reason, %{flush_timer: timer}) do
    _ = Process.cancel_timer(timer)

    :ok
  end

  def handle_info(:trigger, %{flush_interval: interval} = state) do
    Enum.each(WAL.logfiles(), &write/1)

    timer = Process.send_after(self(), :trigger, interval)
    state = %{state | flush_timer: timer}

    {:noreply, state}
  end

  defp write(logfile) do
    with [_ | _] = messages <- logfile |> WAL.flush() |> Enum.intersperse("\n"),
         io when not is_nil(io) <- Logfiles.get(logfile) do
      IO.puts(io, messages)
    else
      _ -> :ok
    end
  end
end
