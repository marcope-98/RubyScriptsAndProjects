require "SymDesc"
include SymDesc

x, y = var :x, :y


class Integer
	def factorial
		(1..self).reduce(1, :*)
	end
end

def D(d, function)
	x, y = var :x, :y
	return  d.diff(x) + d.diff(y) * function
end

def taylor(function, order, step_size = ONE)
	step_size = step_size.symdescfy # convert step_size to symbolic symdesc_variable?
	y = var :y
	y_i = y
	d = function
	order.times do |i|
		y_i += step_size**(i+1)/(i+1).factorial * d 
		d = D(d, function) 
	end
	return y_i
end

def ODE_eval(function, x_0, y_0, x_end, order, step_size = 1)
	x_ = function.vars[0]
	y_ = function.vars[1]
	s = {x_.name => x_0, y_.name => y_0}
	taylor_to_proc = taylor(function, order, step_size).to_proc
	for i in (x_0..x_end-step_size).step(step_size)
		res = taylor_to_proc.call(s)
		s[x_.name] += step_size
		s[y_.name] = res
	end
	return res
end
