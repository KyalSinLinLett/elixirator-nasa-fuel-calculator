# FuelCalculatorApp

### testing and running interactively on iex
```bash
iex -S mix
```

```elixir
ap = FuelCalculator.Worker.execute_flight_program 28801, [{:launch, "earth"}, {:land, "moon"}, {:launch, "moon"}, {:land, "earth"}]

mm = FuelCalculator.Worker.execute_flight_program 14606, [{:launch, "earth"}, {:land, "mars"}, {:launch, "mars"}, {:land, "earth"}]

pp = FuelCalculator.Worker.execute_flight_program 75432, [{:launch, "earth"}, {:land, "moon"}, {:launch, "moon"}, {:land, "mars"}, {:launch, "mars"}, {:land, "earth"}]

```

### run tests
```bash
mix test
```

