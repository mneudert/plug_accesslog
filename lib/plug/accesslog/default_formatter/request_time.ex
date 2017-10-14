defmodule Plug.AccessLog.DefaultFormatter.RequestTime do
  @moduledoc """
  Creates a formatted request time string.
  """

  use Timex

  @doc """
  Formats the log output.
  """
  @spec format(Plug.Conn.t()) :: iodata
  def format(conn) do
    format_string = "[%d/%b/%Y:%H:%M:%S %z]"

    conn.private[:plug_accesslog]
    |> Map.get(:local_time)
    |> Timex.format!(format_string, :strftime)
  end
end
