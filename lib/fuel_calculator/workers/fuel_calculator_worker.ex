defmodule FuelCalculator.Worker do
  require Logger
  alias FuelCalculator.FuelCalculator
  use GenServer

  ## Client API

  @doc """
  Starts the GenServer.
  """
  def start_link(initial_state \\ %{}) do
    GenServer.start_link(__MODULE__, initial_state, name: __MODULE__)
  end

  @doc """
  Executes the flight program with the given total mass and program instructions.
  """
  def execute_flight_program(total_mass, program) do
    GenServer.call(__MODULE__, {:execute_flight_program, total_mass, program})
  end

  ## GenServer Callbacks

  def init(initial_state) do
    {:ok, initial_state}
  end

  def handle_call({:execute_flight_program, total_mass, program}, _from, state) do
    case FuelCalculator.execute_flight_program(total_mass, program) do
      {:ok, result} -> {:reply, result, state}
      {:error, msg} -> {:reply, msg, state} # return the error message txt
    end
  end

  # def terminate(reason, _state) do
  #   # Perform cleanup tasks here
  #   case reason do
  #     :normal -> Logger.info("FuelCalculator Work Terminated with :normal reason")
  #     _ -> Logger.info("FuelCalculator Work Terminated with unexpected reason: #{reason}")
  #   end
  #   :ok
  # end
end
