defmodule DoubanShowDup.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Starts a worker by calling: DoubanShowDup.Worker.start_link(arg)
      # {DoubanShowDup.Worker, arg}
      DoubanShowDup.Database,
      DoubanShowDup.Movie
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DoubanShowDup.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
