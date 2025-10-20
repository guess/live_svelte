if Code.ensure_loaded?(Bun) do
  defmodule LiveSvelte.SSR.Bun do
    @moduledoc """
    SSR renderer implementation using Bun instead of NodeJS.

    This module uses the Bun.Supervisor pool to execute server-side rendering
    of Svelte components using Bun's fast JavaScript runtime.

    ## Configuration

    To use this module, configure it in your application.ex:

        children = [
          {Bun.Supervisor, [pool_size: 4]},
          # ... other children
        ]

    And set it as the SSR module in config.exs:

        config :live_svelte, ssr_module: LiveSvelte.SSR.Bun

    The server.js file should be built and available at `priv/svelte/server.js`.
    """

    alias LiveSvelte.Config

    @behaviour LiveSvelte.SSR

    @impl LiveSvelte.SSR
    def render(name, props, slots) do
      server_path = server_path()
      wrapper_path = wrapper_path()

      try do
        # Call Bun to execute the wrapper with server_path, component name, props, and slots
        case Bun.call(
               wrapper_path,
               [
                 server_path,
                 name,
                 Config.json_library().encode!(props),
                 Config.json_library().encode!(slots)
               ],
               cd: Path.dirname(server_path),
               timeout: 5000
             ) do
          {:ok, output} ->
            Config.json_library().decode!(output)

          {:error, {exit_code, output}} ->
            raise """
            Bun SSR render failed with exit code #{exit_code}:
            #{output}
            """
        end
      catch
        :exit, {:noproc, _} ->
          message = """
          Bun.Supervisor is not configured. Please add the following to your application.ex:
          {Bun.Supervisor, [pool_size: 4]},
          """

          raise %LiveSvelte.SSR.NotConfigured{message: message}
      end
    end

    @doc """
    Returns the path to the server.js file for SSR.

    By default, this returns `priv/svelte/server.js` in the current application.
    """
    def server_path do
      {:ok, path} = :application.get_application()
      Application.app_dir(path, "/priv/svelte/server.js")
    end

    @doc """
    Returns the path to the Bun SSR wrapper script.

    This wrapper script is provided by the live_svelte library and handles
    importing the server.js module and calling the render function.
    """
    def wrapper_path do
      Path.join(:code.priv_dir(:live_svelte), "bun_ssr_wrapper.js")
    end
  end
end
