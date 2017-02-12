defmodule BypassRoutes do
  defmacro bypass_routes(bypass, opts \\ [], [do: block]) do
    default_plugs = build_default_plugs(opts)

    quote do
      Bypass.expect(unquote(bypass), fn conn ->
        Bypass.pass(unquote(bypass))

        defmodule BypassRouter do
          use Plug.Router

          unquote(default_plugs)

          plug :match
          plug :dispatch

          unquote(block)

          match _ do
            raise "No route matched the #{var!(conn).method} request to #{var!(conn).request_path}"
          end
        end

        opts = BypassRouter.init([])
        conn = BypassRouter.call(conn, opts)

        conn
      end)
    end
  end

  defp build_default_plugs([]) do
    quote do
      plug Plug.Parsers, parsers: [:json], json_decoder: Poison
    end
  end
end
