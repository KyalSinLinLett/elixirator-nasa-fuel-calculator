defmodule FuelCalculator.FuelCalculator do
  @planet_gravity %{
    "earth" => 9.807,
    "moon" => 1.62,
    "mars" => 3.711
  }

  def execute_flight_program(total_mass, program) do
    try do
      result = execute_program(total_mass, Enum.reverse(program))
      {:ok, result}
    rescue
      e in ArgumentError ->
        {:error, e.message}
    end
  end

  # Base case when program is empty
  def execute_program(_, []), do: 0

  def execute_program(mass, _) when mass < 0 do
    raise ArgumentError, message: "Invalid mass: #{mass}"
  end

  # Execute program with valid instruction and planet
  def execute_program(total_mass, [{:launch, target} | remaining_program]) do
    fuel = calc_fuel_launch(total_mass, planet_gravity!(target))
    fuel + execute_program(fuel + total_mass, remaining_program)
  end

  def execute_program(total_mass, [{:land, target} | remaining_program]) do
    fuel = calc_fuel_land(total_mass, planet_gravity!(target))
    fuel + execute_program(fuel + total_mass, remaining_program)
  end

  # Pattern matching for invalid instructions
  def execute_program(_, [{instruction, _target} | _remaining_program]) do
    raise ArgumentError, message: "Invalid instruction: #{instruction}"
  end

  # Helper function to fetch gravity or raise error for invalid planets
  def planet_gravity!(target) do
    case Map.fetch(@planet_gravity, target) do
      {:ok, gravity} -> gravity
      :error -> raise ArgumentError, message: "Invalid planet: #{target}"
    end
  end

  def calc_fuel_launch(mass, gravity) do
    curr = Float.floor(mass * gravity * 0.042 - 33) |> trunc()

    if curr <= 0 do
      0
    else
      curr + calc_fuel_launch(curr, gravity)
    end
  end

  def calc_fuel_land(mass, gravity) do
    curr = Float.floor(mass * gravity * 0.033 - 42) |> trunc()

    if curr <= 0 do
      0
    else
      curr + calc_fuel_land(curr, gravity)
    end
  end
end
