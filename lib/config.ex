defmodule LiveSvelte.Config do
  @moduledoc """
  Configuration helpers for LiveSvelte.
  """

  @doc """
  Returns the configured JSON library.

  Defaults to `JSON` if not configured.

  ## Examples

      config :live_svelte, json_library: Jason

  """
  def json_library do
    Application.get_env(:live_svelte, :json_library, JSON)
  end

  @doc """
  Returns the configured SSR module.

  Defaults to `LiveSvelte.SSR.NodeJS` if not configured.

  ## Examples

      config :live_svelte, ssr_module: LiveSvelte.SSR.Bun

  """
  def ssr_module do
    Application.get_env(:live_svelte, :ssr_module, LiveSvelte.SSR.NodeJS)
  end

  @doc """
  Returns whether SSR is enabled.

  Defaults to `true` if not configured.

  ## Examples

      config :live_svelte, ssr: false

  """
  def ssr_enabled? do
    Application.get_env(:live_svelte, :ssr, true)
  end
end
