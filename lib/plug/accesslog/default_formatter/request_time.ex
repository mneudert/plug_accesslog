defmodule Plug.AccessLog.DefaultFormatter.RequestTime do
  @moduledoc """
  Creates a formatted request time string.
  """

  use Timex

  @doc """
  Formats the log output.
  """
  @spec format(Plug.Conn.t()) :: iodata
  def format(%{private: %{plug_accesslog_localtime: localtime}}) do
    Timex.format!(localtime, "[%d/%b/%Y:%H:%M:%S %z]", :strftime)
  end
end
