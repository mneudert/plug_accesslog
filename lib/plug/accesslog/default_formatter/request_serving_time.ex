defmodule Plug.AccessLog.DefaultFormatter.RequestServingTime do
  @moduledoc """
  Calculates the seconds (or milliseconds) taken to serve the request.
  """

  use Timex

  @doc """
  Appends to log output.
  """
  @spec append(String.t, Plug.Conn.t, String.t | :secs | :msecs | :usecs) :: String.t
  def append(message, conn, "s"),  do: append(message, conn, :secs)
  def append(message, conn, "ms"), do: append(message, conn, :msecs)
  def append(message, conn, "us"), do: append(message, conn, :usecs)

  def append(message, conn, format), do: message <> serving_time(conn, format)

  defp serving_time(conn, format) do
    conn.private[:plug_accesslog]
    |> Map.get(:timestamp)
    |> Time.sub(:os.timestamp())
    |> Time.invert()
    |> Time.convert(format)
    |> round()
    |> to_string()
  end
end
