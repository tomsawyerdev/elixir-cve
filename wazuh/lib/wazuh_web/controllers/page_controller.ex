defmodule WazuhWeb.PageController do
  use WazuhWeb, :controller
  alias Wazuh.CveModel

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.

    items = CveModel.list()

    render(conn, :home, layout: false, message: "Hello", items: items)
  end
end
