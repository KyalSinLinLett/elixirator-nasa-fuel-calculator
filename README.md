# FuelCalculatorApp

### testing and running interactively on iex
```bash
iex -S mix
```

```elixir
ap = FuelCalculator.Worker.execute_flight_program 28801, [{:launch, "earth"}, {:land, "moon"}, {:launch, "moon"}, {:land, "earth"}]
# 51898
mm = FuelCalculator.Worker.execute_flight_program 14606, [{:launch, "earth"}, {:land, "mars"}, {:launch, "mars"}, {:land, "earth"}]
# 33388
pp = FuelCalculator.Worker.execute_flight_program 75432, [{:launch, "earth"}, {:land, "moon"}, {:launch, "moon"}, {:land, "mars"}, {:launch, "mars"}, {:land, "earth"}]
# 212161
```

### run tests
```bash
mix test
```

### setup
```bash
# this project doesnt have much dependencies !
mix deps.get
mix deps.compile
```

