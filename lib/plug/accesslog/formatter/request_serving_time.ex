defmodule Plug.AccessLog.Formatter.RequestServingTime do
  @moduledoc """
  Calculates the seconds taken to serve the request.
  """

  use Timex

  @doc """
  Appends to log output.
  """
  @spec append(String.t, Plug.Conn.t) :: String.t
  def append(message, conn), do: message <> serving_time(conn)

  defp serving_time(conn) do
    conn.private[:plug_accesslog]
    |> Map.get(:timestamp)
    |> Time.sub(:os.timestamp())
    |> Time.invert()
    |> Time.convert(:secs)
    |> round()
    |> to_string()
  end
end
