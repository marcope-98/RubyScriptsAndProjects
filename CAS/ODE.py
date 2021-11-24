import sympy as sym
import numpy as np
#import cProfile # profiling
#import pstats 	# statistical display
#import io				#	input - output

#import csv
#from guppy import hpy 
#import time
#import multiprocessing as mp
#import psutil
#import os

x = sym.symbols('x')
y = sym.symbols('y')

def D(df, function):
	return sym.diff(df,x) + sym.diff(df,y) * function

def taylor(function, order, h = 1):
	d = function
	res = y
	for i in range(order):
			res += h ** (i+1) / sym.factorial(i+1) * d
			d = D(d,function)
	return res

def ODE_eval(function, x_0, y_0, x_end, order, step_size = 1):
	y_ = y_0
	res = taylor(function, order, step_size)
	for i in np.arange(x_0, x_end, step_size):
		y_ = res.evalf(subs={x:i, y:y_})
	return y_
		
"""
function = -2*x*y**2
x_0 = 0
y_0 = 1
x_end = 1
order = 4
step_size = 0.001



def monitor(target):
    worker_process = mp.Process(target=target)
    worker_process.start()
    p = psutil.Process(worker_process.pid)
# log cpu usage of `worker_process` every 10 ms
    cpu_percents = []
    while worker_process.is_alive():
      cpu_percents.append(p.cpu_percent())
      time.sleep(1.0)
    worker_process.join()
    worker_process.terminate()
    return cpu_percents

def function_to_eval():
	res = ODE_eval(-2*x*y**2, 0.0, 1.0, 1.0, 4, 0.001)

if __name__ == '__main__':
	with open('test.csv', 'w+') as f:
		for i in np.arange(0,500):
			print(i)
			cpu_percents = monitor(target=function_to_eval)
			f.write(str(np.mean(cpu_percents)) + "\n")
"""

