defmodule FuelCalculatorApp.Application do
  use Application

  def start(_type, _args) do
    children = [
      FuelCalculator.Supervisor
    ]

    opts = [strategy: :one_for_one, name: FuelCalculatorApp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
