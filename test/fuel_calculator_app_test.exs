defmodule FuelCalculatorAppTest do
  alias FuelCalculator.FuelCalculator
  use ExUnit.Case, async: true

  @apollo_program %{
    program: [{:launch, "earth"}, {:land, "moon"}, {:launch, "moon"}, {:land, "earth"}],
    fuel_required: 51898,
    equipment_mass: 28801
  }

  @mars_program %{
    program: [{:launch, "earth"}, {:land, "mars"}, {:launch, "mars"}, {:land, "earth"}],
    fuel_required: 33388,
    equipment_mass: 14606
  }

  @passengers_program %{
    program: [
      {:launch, "earth"},
      {:land, "moon"},
      {:launch, "moon"},
      {:land, "mars"},
      {:launch, "mars"},
      {:land, "earth"}
    ],
    fuel_required: 212_161,
    equipment_mass: 75432
  }

  # for checking the values from test task description is obtained
  describe "execute_program/2 with predefined mission programs" do
    test "apollo11 program" do
      assert FuelCalculator.execute_program(
               @apollo_program.equipment_mass,
               Enum.reverse(@apollo_program.program)
             ) ==
               @apollo_program.fuel_required
    end

    test "mars program" do
      assert FuelCalculator.execute_program(
               @mars_program.equipment_mass,
               Enum.reverse(@mars_program.program)
             ) ==
               @mars_program.fuel_required
    end

    test "passengers program" do
      assert FuelCalculator.execute_program(
               @passengers_program.equipment_mass,
               Enum.reverse(@passengers_program.program)
             ) == @passengers_program.fuel_required
    end
  end

  describe "execute_program/2 with invalid mass" do
    test "returns 0 when mass is zero" do
      assert FuelCalculator.execute_program(0, [{:launch, "earth"}]) == 0
    end

    test "raises an error when mass is negative" do
      assert_raise ArgumentError, "Invalid mass: -500", fn ->
        FuelCalculator.execute_program(-500, [{:launch, "earth"}])
      end
    end
  end

  describe "execute_program/2" do
    test "returns 0 when the program is empty" do
      assert FuelCalculator.execute_program(1000, []) == 0
    end

    test "calculates fuel for a launch from earth" do
      assert FuelCalculator.execute_program(1000, [{:launch, "earth"}]) == 517
    end

    test "calculates fuel for a land on moon" do
      assert FuelCalculator.execute_program(1000, [{:land, "moon"}]) == 11
    end

    test "calculates fuel for a full program with multiple steps" do
      program = [
        {:launch, "earth"},
        {:land, "moon"},
        {:launch, "moon"},
        {:land, "earth"}
      ]

      assert FuelCalculator.execute_program(1000, program) == 1226
    end

    test "calculates fuel for multiple launches and landings with varying planets" do
      program = [
        {:launch, "earth"},
        {:land, "mars"},
        {:launch, "mars"},
        {:land, "earth"}
      ]

      assert FuelCalculator.execute_program(1000, program) == 1599
    end

    test "calculates fuel for launch and land with different mass values" do
      assert FuelCalculator.execute_program(500, [{:launch, "earth"}]) == 209
      assert FuelCalculator.execute_program(2000, [{:land, "moon"}]) == 64
    end

    test "handles invalid instruction and raises an error" do
      program = [{:fly, "earth"}]

      assert_raise ArgumentError, "Invalid instruction: fly", fn ->
        FuelCalculator.execute_program(1000, program)
      end
    end

    test "handles invalid planet and raises an error" do
      program = [{:launch, "jupiter"}]

      assert_raise ArgumentError, "Invalid planet: jupiter", fn ->
        FuelCalculator.execute_program(1000, program)
      end
    end

    test "handles a complex program with repeated instructions" do
      program = [
        {:launch, "earth"},
        {:land, "moon"},
        {:launch, "moon"},
        {:land, "mars"},
        {:launch, "mars"},
        {:land, "earth"}
      ]

      assert FuelCalculator.execute_program(1500, program) == 3116
    end

    test "calculates fuel for just launch and land on mars" do
      assert FuelCalculator.execute_program(800, [{:launch, "mars"}, {:land, "mars"}]) == 158
    end

    test "calculates fuel for back-to-back launches" do
      program = [
        {:launch, "earth"},
        {:launch, "mars"}
      ]

      assert FuelCalculator.execute_program(1000, program) == 720
    end

    test "calculates fuel for back-to-back landings" do
      program = [
        {:land, "mars"},
        {:land, "moon"}
      ]

      assert FuelCalculator.execute_program(1000, program) == 95
    end

    test "handles program with no valid instructions" do
      program = [{:swim, "mars"}]

      assert_raise ArgumentError, "Invalid instruction: swim", fn ->
        FuelCalculator.execute_program(1000, program)
      end
    end

    test "calculates fuel for large mass with launch and land" do
      program = [{:launch, "earth"}, {:land, "mars"}]
      assert FuelCalculator.execute_program(50_000, program) == 46235
    end

    test "calculates fuel for minimal mass with launch and land" do
      program = [{:launch, "earth"}, {:land, "mars"}]
      assert FuelCalculator.execute_program(10, program) == 0
    end

    test "calculates fuel for unknown planet" do
      program = [{:launch, "pluto"}]
      assert_raise ArgumentError, "Invalid planet: pluto", fn ->
        FuelCalculator.execute_program(1000, program)
      end
    end

    test "calculates fuel for complex multi-step program with varying planets and mass" do
      program = [
        {:launch, "earth"},
        {:land, "moon"},
        {:launch, "mars"},
        {:land, "earth"}
      ]
      assert FuelCalculator.execute_program(4000, program) == 7559
    end
  end

  describe "planet_gravity!/1" do
    test "returns correct gravity for valid planets" do
      assert FuelCalculator.planet_gravity!("earth") == 9.807
      assert FuelCalculator.planet_gravity!("moon") == 1.62
      assert FuelCalculator.planet_gravity!("mars") == 3.711
    end

    test "raises error for invalid planet" do
      assert_raise ArgumentError, "Invalid planet: venus", fn ->
        FuelCalculator.planet_gravity!("venus")
      end
    end

    test "raises error for empty planet input" do
      assert_raise ArgumentError, "Invalid planet: ", fn ->
        FuelCalculator.planet_gravity!("")
      end
    end

    test "handles case-sensitivity for planets" do
      assert_raise ArgumentError, "Invalid planet: Earth", fn ->
        FuelCalculator.planet_gravity!("Earth")
      end
    end

    test "returns gravity for case-sensitive valid planets" do
      assert_raise ArgumentError, "Invalid planet: MARS", fn ->
        FuelCalculator.planet_gravity!("MARS")
      end
    end

    test "handles planet with spaces" do
      assert_raise ArgumentError, "Invalid planet: earth ", fn ->
        FuelCalculator.planet_gravity!("earth ")
      end
    end

    test "handles numeric input" do
      assert_raise ArgumentError, "Invalid planet: 123", fn ->
        FuelCalculator.planet_gravity!("123")
      end
    end
  end

  describe "calc_fuel_launch/2" do
    test "calculates fuel for launch from earth with varying mass" do
      assert FuelCalculator.calc_fuel_launch(500, 9.807) == 209
      assert FuelCalculator.calc_fuel_launch(1000, 9.807) == 517
      assert FuelCalculator.calc_fuel_launch(2000, 9.807) == 1171
    end

    test "calculates fuel for launch from moon with varying mass" do
      assert FuelCalculator.calc_fuel_launch(500, 1.62) == 1
      assert FuelCalculator.calc_fuel_launch(1000, 1.62) == 35
      assert FuelCalculator.calc_fuel_launch(2000, 1.62) == 103
    end

    test "returns 0 for launch when calculated fuel is negative or zero" do
      assert FuelCalculator.calc_fuel_launch(10, 9.807) == 0
      assert FuelCalculator.calc_fuel_launch(10, 1.62) == 0
    end

    test "calculates launch fuel for extreme mass values" do
      assert FuelCalculator.calc_fuel_launch(100_000, 9.807) == 69563
      assert FuelCalculator.calc_fuel_launch(1, 9.807) == 0
    end

    test "calculates launch fuel for planets with small gravity" do
      assert FuelCalculator.calc_fuel_launch(1000, 0.5) == 0
    end
  end

  describe "calc_fuel_land/2" do
    test "calculates fuel for landing on earth with varying mass" do
      assert FuelCalculator.calc_fuel_land(500, 9.807) == 119
      assert FuelCalculator.calc_fuel_land(1000, 9.807) == 329
    end

    test "calculates fuel for landing on moon with varying mass" do
      assert FuelCalculator.calc_fuel_land(500, 1.62) == 0
      assert FuelCalculator.calc_fuel_land(1000, 1.62) == 11
    end

    test "calculates fuel for landing on mars with varying mass" do
      assert FuelCalculator.calc_fuel_land(500, 3.711) == 19
      assert FuelCalculator.calc_fuel_land(1000, 3.711) == 80
    end

    test "returns 0 for land when calculated fuel is negative or zero" do
      assert FuelCalculator.calc_fuel_land(10, 9.807) == 0
      assert FuelCalculator.calc_fuel_land(10, 1.62) == 0
    end

    test "calculates landing fuel for extreme mass values" do
      assert FuelCalculator.calc_fuel_land(100_000, 9.807) == 47447
      assert FuelCalculator.calc_fuel_land(1, 9.807) == 0
    end

    test "calculates landing fuel for planets with small gravity" do
      assert FuelCalculator.calc_fuel_land(1000, 0.5) == 0
    end
  end
end
