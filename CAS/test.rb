require 'SymDesc'			# cas

# accept an integer and return the absolute value
def n(alpha)
	return alpha >= 0 ? alpha : -alpha
end

#
def u(zeta)
	return zeta >= 0 ? 1 : -1
end


def rem(beta, gamma)
	return beta >= gamma || beta == 0? beta % gamma : gamma % beta
end

def euclid(a,b)

	if n(a) >= n(b) then
		c = n(a)
		d = n(b)	
	else
		c = n(b)
		d = n(a)
	end
	#c = n(a)
	#d = n(b)
	i = 0
	r = 0
	#puts String(i) + " ,r:" + String(r) + " ,c:" + String(c) + " ,d:" + String(d) 
	while d != 0 do
		
		i = i+1 
		r = rem(c,d)
		
		c = d
		d = r
		#puts String(i) + " ,r:" + String(r) + " ,c:" + String(c) + " ,d:" + String(d) 
	end
	return n(c)
end

def EEA(a,b,s,t)
	c = n(a)
	d = n(b)
	c_1 = 1
	d_1 = 0
	c_2 = 0
	d_2 = 1
	while d != 0 do
		q = Integer(c.quo(d))
		r = c - q*d
		r_1 = c_1 - q*d_1
		r_2 = c_2 - q*d_2
		c = d
		c_1 = d_1
		c_2 = d_2
		d = r
		d_1 = r_1
		d_2 = r_2
	end
	g = n(c)
	s = c_1/(u(a)*u(c))
	t = c_2/(u(b)*u(c))
	return g
end


def check_routine(facts, var)
	if facts.class == SymDesc::Int then
		coeff = Integer(facts.to_s)
		pp = 0
	elsif facts.class == SymDesc::Prod and facts.depends_on?(var)
	
		if facts.right.class == SymDesc::Variable then
		pp = 1
		coeff = Integer(facts.left.to_s)
		elsif facts.right.class == SymDesc::Power
		pp = Integer(facts.right.right.to_s)
		coeff = Integer(facts.left.to_s)
		end
	elsif facts.class == SymDesc::Power and facts.depends_on?(var)
		pp = Integer(facts.right.to_s)
		coeff = 1
	else
		coeff = 1
		pp = 1
	end 

	return [coeff,pp] 
end


def coeff_pp(function)
	vars = function.vars[0]
	expression = function.clone
	i = 0
	coeff = []
	pp = []
	u = []
	flag = false
	#p expression
	until [SymDesc::Power,SymDesc::Variable,SymDesc::Int, SymDesc::Prod, SymDesc::Neg].include?(expression.class) do
		
		if expression.class == SymDesc::Neg
			if expression.argument.class == SymDesc::Int 
			  coeff.append(expression.argument)
				u.append(-1)
			else 
				expression = expression.argument
			  flag = true
			end
		else

			#p expression.class
			if [SymDesc::Prod,SymDesc::Int, SymDesc::Variable].include?(expression.right.class)
				if expression.class == SymDesc::Sub 
					u.append(-1)
				else 
					u.append(+1)
				end
				temp = check_routine(expression.right, vars)
				coeff.append(temp[0])
				pp.append(temp[1])
				expression = expression.left
			else
				if expression.class == SymDesc::Sub or flag
					u.append(+1)
					flag = false
				else
					u.append(-1)
					flag = true
				end 
				temp = check_routine(expression.left, vars)
				expression = expression.right
				coeff.append(temp[0])
				pp.append(temp[1])
			end
		end
	#p expression
	end
	temp = check_routine(expression, vars)
	if flag or expression.class == SymDesc::Sub 
		u.append(-1)
	else  
		u.append(+1)
	end 
	coeff.append(temp[0])
	pp.append(temp[1]) 
	


	a, coeff = pp.zip(coeff).sort.transpose
	pp, u = pp.zip(u).sort.transpose

	for i in 0..pp[-1]
		if i != pp[i]
			pp.insert(i,i)
			coeff.insert(i,0)
			u.insert(i,0)
		end
	end
	return coeff.reverse, pp.reverse, u.reverse, vars
end



def recursive_GCD(coeff)
	res = euclid(coeff[0],coeff[1])
	for i in 2..coeff.size-1 do
		res = euclid(res, coeff[i])
	end

	return u(coeff[0])*res
end


def reconstruct_polynomial(coeffs_, pp_, u_, vars, boolean)
	boolean ? gcd = u_[0]*recursive_GCD(coeffs_) : gcd = 1
	new_fun = 0.symdescfy
	coeffs = coeffs_.reverse
	pp = pp_.reverse
	u = u_.reverse
	for i in 0..coeffs.size-1 do
		new_fun += u[i]*(coeffs[i]/gcd)*vars**pp[i]
	end 
	return new_fun, gcd
end




def prem(a,b)
	t_1 = coeff_pp(a)
	t_2 = coeff_pp(b)

	prem = []
	sign = []

	if t_1[1][0] < t_1[1][0] then
	  s = "string"
	else
		beta = (t_2[2][0]*t_2[0][0])**(t_1[1][0] - t_2[1][0] + 1)
		pquo = (beta*t_1[0][0]*t_2[2][0]) / (t_2[2][0]*t_2[0][0])
		prem.append(beta*t_1[0][0]*t_1[2][0]  - t_2[2][0]*pquo*t_2[0][0])
		sign.append(1)
		for i in 1..t_1[0].size-1
			if i <= t_2[1].size-1
				prem.append(beta*t_1[0][i]*t_1[2][i] - pquo*t_2[0][i]*t_2[2][i])
				sign.append(1)
			else
				prem.append(beta*t_1[0][i]*t_1[2][i])
				sign.append(1)
			end
		end
	end
	return reconstruct_polynomial(prem, t_1[1], sign, a.vars[0],false)[0]
end




def primitiveEuclidean(a,b)
	t_1 = coeff_pp(a)
	t_2 = coeff_pp(b)


	c, c_1 = reconstruct_polynomial(t_1[0],t_1[1], t_1[2], t_1[3], true)
	d, d_1 = reconstruct_polynomial(t_2[0],t_2[1], t_2[2], t_2[3], true)

	i = 0
	while true do

		r = prem(c,d)
		
		c = d.clone
		
		d = coeff_pp(r)
		
		if d[0].size == 1 and d[0][0] == 0 then break end
		d = reconstruct_polynomial(d[0],d[1],d[2],d[3], true)[0]
		
		
		i = i+1
	end
	gamma = euclid(recursive_GCD(t_1[0]),recursive_GCD(t_2[0]))
	g = gamma * c
	return g
end