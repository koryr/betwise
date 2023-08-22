defmodule Betwise.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      BetwiseWeb.Telemetry,
      # Start the Ecto repository
      Betwise.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Betwise.PubSub},
      # Start Finch
      {Finch, name: Betwise.Finch},
      # Start the Endpoint (http/https)
      BetwiseWeb.Endpoint
      # Start a worker by calling: Betwise.Worker.start_link(arg)
      # {Betwise.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Betwise.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BetwiseWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
