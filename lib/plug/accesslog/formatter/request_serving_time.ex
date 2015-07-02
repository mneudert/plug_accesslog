defmodule Plug.AccessLog.Formatter.RequestServingTime do
  @moduledoc """
  Calculates the seconds (or milliseconds) taken to serve the request.
  """

  use Timex

  @doc """
  Appends to log output.
  """
  @spec append(String.t, Plug.Conn.t, :secs | :msecs) :: String.t
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
