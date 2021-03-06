defmodule YourUrlEx.UrlControllerTest do
  use YourUrlEx.ConnCase

  alias YourUrlEx.Url
  @valid_attrs %{ original_url: "http://google.com" }
  @invalid_attrs %{ original_url: nil }
  @token Phoenix.Token.sign(YourUrlEx.Endpoint, System.get_env("AUTHORIZATION_TOKEN_SALT"), "DarthVader")

  setup %{conn: conn} do
    conn = conn
           |> put_req_header("accept", "application/json")
           |> put_req_header("token", @token)

    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, url_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    url = Repo.insert! %Url{ clicks: 20, original_url: "http://yahoo.com", url_hash: "AA223344" }

    conn = get conn, url_path(conn, :show, %Url{id: url.url_hash })
    assert json_response(conn, 200)["data"] == %{
      "clicks" => url.clicks,
      "original_url" => url.original_url,
      "short_url" => "#{YourUrlEx.Endpoint.url}/#{url.url_hash}"}
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, url_path(conn, :create), url: @valid_attrs
    assert json_response(conn, 201)["data"]["short_url"]
    assert Repo.get_by(Url, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, url_path(conn, :create), url: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    url = Repo.insert! %Url{ clicks: 20, original_url: "http://yahoo.com", url_hash: "AA223344" }
    conn = delete conn, url_path(conn, :delete, %Url{ id: url.url_hash })
    assert response(conn, 204)
    refute Repo.get(Url, url.id)
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, url_path(conn, :show, -1)
    end
  end

  test "renders page not found when token is invalid", %{conn: conn} do
    conn = conn |> put_req_header("token", "notAValidToken")

    conn = get(conn, url_path(conn, :index))

    assert conn.status == 401
    assert conn.resp_body == "Not Authorised"
  end
end
