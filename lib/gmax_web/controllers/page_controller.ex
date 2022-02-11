defmodule GmaxWeb.PageController do
  use GmaxWeb, :controller

  plug :put_layout, false when action in [:index, :privacy, :terms, :faq, :howitworks]

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def privacy(conn, _params) do
    render(conn, "privacy.html")
  end

  def terms(conn, _params) do
    render(conn, "terms.html")
  end

  def faq(conn, _params) do
    render(conn, "faq.html")
  end

  def howitworks(conn, _params) do
    render(conn, "howitworks.html")
  end
end
