import cProfile # profiling
import pstats 	# statistical display
import io				#	input - output
import sympy as sym
import csv
from ODE import taylor, ODE_eval, x, y
from sympy import gcdex
from sympy.abc import x
import numpy as np
from guppy import hpy
import psutil


# variables used
function_1 = 48*x**3 - 84*x**2 + 42*x - 36
function_2 = -4*x**3  + 44*x - 10*x**2 - 30
function = -2*x*y**2
x_0 = 0
y_0 = 1
x_end = 1
order = 4
step_size = 0.001

# open csv file
with open('py.csv', 'w+') as file:
	# write headers on file
	file.write("n_calls,total_tt,mem_alloc,objs\n")
	# insert expressione / function here	
	for i in np.arange(0,5000):
		print(i)   # uncomment to follow the index of the loop
		# for memory allocation-------------------------------------------
		h = hpy()
		h.setrelheap()
		# uncomment one of the following
		#taylor(function, order, step_size)
		ODE_eval(function, x_0, y_0, x_end, order, step_size)
		#gcdex(function_1, function_2)
		f = h.heap()			# report saved as a var
		# end of memory allocation----------------------------------------
		# memory allocation
		memory_alloc = f.size
		# objects allocated
		objects = str(f).split('\n')[0].split(' ')[5]

		# for timing------------------------------------------------------
		pr = cProfile.Profile()
		pr.enable()
		# uncomment one of the following
		#taylor(function, order, step_size)
		ODE_eval(function, x_0, y_0, x_end, order, step_size)
		#gcdex(function_1, function_2)
		pr.disable()
		#end of profiing--------------------------------------------------

		# manage profiler report to gather timing
		s = io.StringIO()
		ps = pstats.Stats(pr, stream=s)#.sort_stats(sortby)
		ps.print_stats()
		# write on file
		file.write(str(ps.total_calls) + "," + str(ps.total_tt) + "," + str(memory_alloc) + "," + objects + "\n")
