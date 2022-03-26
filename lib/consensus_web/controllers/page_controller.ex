defmodule ConsensusWeb.PageController do
  use ConsensusWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
