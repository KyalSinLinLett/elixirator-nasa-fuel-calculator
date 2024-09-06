# quick solution in python and POC that the formulas work!

import math

def calc_fuel_launch(mass, gravity):
    curr = math.floor(mass * gravity * 0.042 - 33) 
    if (curr <= 0): return 0
    return curr + calc_fuel_launch(curr, gravity)

def calc_fuel_land(mass, gravity):
    curr = math.floor(mass * gravity * 0.033 - 42)
    if (curr <= 0): return 0
    return curr + calc_fuel_land(curr, gravity)

def execute_flight_program(total_mass, program):
    if (len(program) == 0): return 0

    instruction, target = program.pop(len(program)-1)
    
    if (instruction == "launch"): 
        fuel = calc_fuel_launch(total_mass, planet_gravity[target])
    if (instruction == "land"): 
        fuel = calc_fuel_land(total_mass, planet_gravity[target])
    
    print(f"{instruction}-{target} => {fuel}")
    
    return (fuel) + execute_flight_program(fuel+total_mass, program)

planet_gravity = {
    "earth": 9.807,
    "moon": 1.62,
    "mars": 3.711
}

ap11CMS_mass = 28801
mars_mass = 14606
passenger_mass = 75432

flight_program = [("land", "earth")]
apollo11_flight_program = [("launch", "earth"), ("land", "moon"), ("launch", "moon"), ("land", "earth")]
mars_flight_program = [("launch", "earth"), ("land", "mars"), ("launch", "mars"), ("land", "earth")]
passenger_flight_program = [("launch", "earth"), ("land", "moon"), ("launch", "moon"),  ("land", "mars"), ("launch", "mars"), ("land", "earth")]

curr = ap11CMS_mass

# f = 0
# for p in apollo11_flight_program:
#     fuel = execute_flight_program(curr, [p])
#     f += fuel
#     print(fuel)
#     # curr += fuel
# print(f)
# print(curr)
ap11 = execute_flight_program(ap11CMS_mass, apollo11_flight_program)
# pp = execute_flight_program(passenger_mass, passenger_flight_program)
# m = execute_flight_program(mars_mass, mars_flight_program)
print(ap11)
print((ap11-51898) / ap11 * 100)

# print(pp)
# print((pp- 212161) / pp * 100)
 
# print(m)
# print((m- 33388) / m * 100)
 
# print(execute_flight_program(ap11CMS_mass, flight_program))
 