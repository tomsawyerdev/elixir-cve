defmodule WazuhWeb.CvesController do
  use WazuhWeb, :controller

  alias Wazuh.CveModel

  # action_fallback(WazuhWeb.FallbackController)

  #
  def index(conn, _params) do
    items = CveModel.list()
    render(conn, :index, items: items)
  end

  def show(conn, %{"id" => cve_id}) do
    item = CveModel.get(cve_id)
    # item or 404
    case item do
      [e] -> render(conn, :show, item: e)
      [] -> conn |> put_status(404) |> json(%{"status" => 404, "message" => "not found object"})
    end
  end

  def export(conn, %{"id" => cve_id}) do
    # IO.puts("Export---------------")
    item = CveModel.get(cve_id)

    case item do
      [e] -> sendattachment(conn, e.jsondata, e.cveid)
      [] -> sendattachment(conn, %{"status" => 404, "message" => "not found object"}, "empty")
    end
  end

  # https://hexdocs.pm/phoenix/Phoenix.Controller.html#send_download/3
  defp sendattachment(conn, json_data, name) do
    # IO.inspect(json_data, label: "json data")
    conn
    |> put_resp_content_type("text/json")
    |> put_resp_header("content-disposition", ~s[attachment; filename="#{name}.json"])
    |> put_root_layout(false)
    |> json(json_data)
  end
end
