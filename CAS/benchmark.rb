#require 'stringio'
require 'SymDesc'			# cas
require_relative 'ODE'	
require_relative 'test'
require 'ruby-prof'	# profiling
require 'csv'
require 'memory_profiler'

x, y = var :x, :y
function_1 = 48*x**3 - 84*x**2 + 42*x - 36
function_2 = -4*x**3  + 44*x - 10*x**2 - 30
function = -2*x*y**2
x_0 = 0
y_0 = 1
x_end = 1
order = 4
step_size = 0.001
#p primitiveEuclidean(function_1,function_2)
# profile the code
# !!!!!!!!!!!!!!!!!!!!!!!!!!1 = change name of the file 
CSV.open("rb.csv","w+") do |csv|
	csv << ["n_calls,total_tt,mem_alloc,objs"]
	for i in (0..4999) do
		#p i
		# ... code to profile ...
		RubyProf.start
		taylor(function, order, step_size)
		#ODE_eval(function, x_0, y_0, x_end, order, step_size)
		#primitiveEuclidean(function_1,function_2)
		result = RubyProf.stop

		MemoryProfiler.start
		taylor(function, order, step_size)
		#ODE_eval(function, x_0, y_0, x_end, order, step_size)
		#primitiveEuclidean(function_1,function_2)
		report = MemoryProfiler.stop
		objects = report.total_allocated #numero di oggetti
		mem_alloc = report.total_allocated_memsize #bytes

		calls = result.threads[0].methods
		n_calls = 0
		total_tt = 0.0

		calls.each do |numberofcalls|
			n_calls = n_calls + numberofcalls.called
			total_tt = total_tt + numberofcalls.self_time()
		end
		csv << [n_calls, total_tt, mem_alloc, objects]
	end
end


