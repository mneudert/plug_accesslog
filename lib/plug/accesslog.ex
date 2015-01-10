defmodule Plug.AccessLog do
  @moduledoc """
  AccessLog Plug
  """

  @behaviour Plug

  def init(opts), do: opts

  def call(conn, _opts), do: conn
end
