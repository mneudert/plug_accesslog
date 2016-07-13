defmodule Plug.AccessLog.DefaultFormatter.RequestServingTime do
  @moduledoc """
  Calculates the seconds (or milliseconds) taken to serve the request.
  """

  use Timex

  @doc """
  Appends to log output.
  """
  @spec append(String.t, Plug.Conn.t, String.t | :seconds | :milliseconds | :microseconds) :: String.t
  def append(message, conn, "s"),  do: append(message, conn, :seconds)
  def append(message, conn, "ms"), do: append(message, conn, :milliseconds)
  def append(message, conn, "us"), do: append(message, conn, :microseconds)

  def append(message, conn, format), do: message <> serving_time(conn, format)

  defp serving_time(conn, format) do
    conn.private[:plug_accesslog]
    |> Map.get(:timestamp)
    |> Duration.from_erl()
    |> Duration.diff(Duration.now(), format)
    |> Kernel.*(-1)
    |> round()
    |> to_string()
  end
end
