defmodule Plug.AccessLog.DefaultFormatter.RequestServingTime do
  @moduledoc """
  Calculates the time taken to serve the request.
  """

  use Timex

  @type time_format :: String.t() | :seconds | :milliseconds | :microseconds

  @doc """
  Formats the log output.
  """
  @spec format(Plug.Conn.t(), time_format) :: iodata
  def format(conn, "s"), do: format(conn, :seconds)
  def format(conn, "ms"), do: format(conn, :milliseconds)
  def format(conn, "us"), do: format(conn, :microseconds)

  def format(%{private: %{plug_accesslog_timestamp: timestamp}}, format) do
    timestamp
    |> Duration.from_erl()
    |> Duration.diff(Duration.now(), format)
    |> Kernel.*(-1)
    |> round()
    |> to_string()
  end
end
