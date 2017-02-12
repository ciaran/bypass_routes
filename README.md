# BypassRoutes

Provides an easy to way set up responses when using [Bypass](https://github.com/PSPDFKit-labs/bypass) in your tests.

## Installation

The package can be installed by adding `bypass_routes` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:bypass_routes, "~> 0.1.0", only: :test},
  ]
end
```

## Usage

Once your [`bypass`](https://github.com/PSPDFKit-labs/bypass) is set up as usual,
you can call `bypass_routes/1` to configure your responses:

```elixir
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
```

See the docs for [`Plug.Router`](https://hexdocs.pm/plug/Plug.Router.html) for details about route matching.
