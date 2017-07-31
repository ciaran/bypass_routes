defmodule BypassRoutes do
  defmacro bypass_routes(bypass, opts \\ [], [do: block]) do
    default_plugs = build_default_plugs(opts)

    module_name = Module.concat(__CALLER__.module, BypassRouter)

    quote do
      defmodule unquote(module_name) do
        use Plug.Router

        unquote(default_plugs)

        plug :match
        plug :dispatch

        unquote(block)

        match _ do
          raise "No route matched the #{var!(conn).method} request to #{var!(conn).request_path}"
        end
      end

      ExUnit.Callbacks.on_exit(fn ->
        :code.purge(unquote(module_name))
        :code.delete(unquote(module_name))
      end)

      Bypass.expect(unquote(bypass), fn conn ->
        Bypass.pass(unquote(bypass))

        opts = unquote(module_name).init([])
        conn = unquote(module_name).call(conn, opts)

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
