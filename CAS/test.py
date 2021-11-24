from sympy import gcdex
from sympy.abc import x
function_1 = 48*x**3 - 84*x**2 + 42*x - 36
function_2 = -4*x**3  + 44*x - 10*x**2 - 30
x_0 = 0
y_0 = 1
x_end = 1
order = 4
step_size = 0.001

print(gcdex(function_1, function_2)[2])


