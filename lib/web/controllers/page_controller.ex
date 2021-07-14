defmodule Web.PageController do
  use Web, :controller

  def index(conn, _params) do
    conn
    |> put_resp_header("content-type", "text/html; charset=utf-8")
    |> Plug.Conn.send_file(200, Application.app_dir(:elixir_app, "priv/static/index.html"))
  end
end
