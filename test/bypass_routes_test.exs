defmodule BypassRoutesTest do
  use ExUnit.Case
  import BypassRoutes

  setup do
    bypass = Bypass.open

    {:ok, bypass: bypass}
  end

  test "hello world", %{bypass: bypass} do
    bypass_routes(bypass) do
      plug Plug.Parsers, parsers: [:json], json_decoder: Poison

      post "/message" do
        send_resp conn, 200, conn.params["message"]
      end
    end

    headers = %{"Content-Type" => "application/json"}
    body = Poison.encode!(%{"message" => "Hello World"})
    assert %{body: "Hello World"} = HTTPoison.post!("http://localhost:#{bypass.port}/message", body, headers)
  end

  test "multiple bypass_routes in same test module work", %{bypass: bypass} do
    bypass_routes(bypass) do
      get "/dummy" do
        send_resp conn, 200, "hi"
      end
    end
    assert %{body: "hi"} = HTTPoison.get!("http://localhost:#{bypass.port}/dummy")
  end

  test "multiple calls to the same bypass work", %{bypass: bypass} do
    bypass_routes(bypass) do
      get "/dummy" do
        send_resp conn, 200, "hi"
      end
    end
    assert %{body: "hi"} = HTTPoison.get!("http://localhost:#{bypass.port}/dummy")
    assert %{body: "hi"} = HTTPoison.get!("http://localhost:#{bypass.port}/dummy")
  end
end
