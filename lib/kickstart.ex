defmodule Kickstart do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Kickstart.Repo, []),
      # Start the endpoint when the application starts
      supervisor(Kickstart.Endpoint, []),
      # Start your own worker by calling: Kickstart.Worker.start_link(arg1, arg2, arg3)
      # worker(Kickstart.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Kickstart.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Kickstart.Endpoint.config_change(changed, removed)
    :ok
  end
end
