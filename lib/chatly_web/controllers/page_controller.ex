defmodule ChatlyWeb.PageController do
  use ChatlyWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
