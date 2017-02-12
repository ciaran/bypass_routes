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
end
