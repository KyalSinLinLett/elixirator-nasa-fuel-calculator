defmodule FuelCalculator.Supervisor do
  use Supervisor

  def start_link(_arg) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_args) do
    children = [
      %{
        id: FuelCalculator,
        start: {FuelCalculator.Worker, :start_link, [[]]},
        type: :worker,
        restart: :permanent
      }
    ]

    # max_restarts: 3: The supervisor will allow up to 3 restarts.
    # max_seconds: 5: These 3 restarts can happen within 5 seconds. If more than 3 crashes occur within that period, the supervisor itself will crash.
    opts = [
      strategy: :one_for_one,
      name: FuelCalculator.Supervisor,
      max_restarts: 3,
      max_seconds: 5
    ]

    Supervisor.init(children, opts)
  end
end
