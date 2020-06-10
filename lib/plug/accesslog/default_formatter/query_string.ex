defmodule Plug.AccessLog.DefaultFormatter.QueryString do
  @moduledoc """
  Logs the query string.
  """

  @doc """
  Formats the log output.
  """
  @spec format(Plug.Conn.t()) :: iodata
  def format(%{query_string: ""}), do: ""
  def format(%{query_string: query}), do: ["?", query]
end
