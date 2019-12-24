defmodule LiveViewWeb.PagesController do

  import Phoenix.LiveView.Controller
  use LiveViewWeb, :controller

  def init(opts) do
    IO.puts("Initializing")
    opts
  end

  def call(conn, _opts) do
    IO.puts("Calling")
    conn
  end

  def index(conn, _) do
    IO.puts("-----------------Running controller------------------")
    """
    conn
    |> Plug.Conn.put_resp_header(conn, 'Access-Control-Allow-Origin', '*')
    |> Plug.Conn.put_resp_header(conn, 'test', 'value')
    |> Plug.Conn.put_status(:ok)
    |> Plug.Conn.send_resp("")
    |> live_render(LiveViewWeb.PagesView)
    """
    conn
    |> live_render(LiveViewWeb.PagesView, session: %{})
  end
end
