defmodule WazuhWeb.CveControllerTest do
  use WazuhWeb.ConnCase, async: true

  test "GET /api/cves returns a list of cve", %{conn: conn} do
    conn = get(conn, ~p"/api/cves")
    response =json_response(conn, 200)
    #IO.inspect(response,label: "response")
    item = Enum.at(response,0)
    assert length(response) > 0
    assert Map.has_key?(item,"id") == true
    assert Map.has_key?(item,"published") == true
  end

  test "GET /api/cves/CVE-2025-20060 returns a cve", %{conn: conn} do
    conn = get(conn, ~p"/api/cves/CVE-2025-20060")
    item =json_response(conn, 200)
    #IO.inspect(item,label: "item")
    assert Map.has_key?(item,"id") == true
    assert Map.has_key?(item,"published") == true
  end

  test "GET /api/cves/CVE-404 returns 404", %{conn: conn} do
    conn = get(conn, ~p"/api/cves/CVE-404")
    item =json_response(conn, 404)
    #IO.inspect(item,label: "item")
    assert Map.has_key?(item,"status") == true
    assert Map.has_key?(item,"message") == true
  end

end
