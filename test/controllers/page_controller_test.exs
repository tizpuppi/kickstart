defmodule Kickstart.PageControllerTest do
  use Kickstart.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "KickStart"
  end
end
