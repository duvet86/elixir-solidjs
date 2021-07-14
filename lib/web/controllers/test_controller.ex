defmodule Web.TestController do
  use Web, :controller

  def index(conn, _params) do
    json(conn, %{test: "Test"})
  end
end
