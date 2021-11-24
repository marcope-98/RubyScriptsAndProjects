=begin
Patch.Notes 
  - In questa versione è possibile non solo calcolare i modelli lineari e quadratici (e relativi errori quadratici medi) con il metodo dei minimi quadrati,
	  ma anche loro composizione con altre funzioni
	- Il sistema è stato integrato con un metodo che permette il calcolo di qualunque metodo polinomiale
	- Sia dunque N-1 il grado del polinomio del modello che si vuole studiare, il codice calcola la matrice inversa e ne ritorna i coefficienti
 
  (si accettano consigli per cambiare il nome della funzione fx, vett e delle variabili i cui nomi sono di dubbia originalità)
=end


#------------------------------------------------------------------------Methods---------------------------------------------------------------------

# La funzione pot: 
#  1- Permette di fare prodotto elemento per elemento tra due vettori, 
#  2- elevazioni a potenza di ogni singolo elemento di un array
#  3- e in entrambi i casi ritorna la loro somma

def pot(a, t, s)
		q = Array.new

	# se t è un numero allora la funzione ritorna un vettore degli elementi del vettore a in ingresso elevati alla s-esima potenza
  if t.is_a?(Numeric) then
		for i in 0...a.size
		  q << (a[i])**s
		end

	# se t è un array allora la funzione ritorna un vettore del prodotto tra la i-esima componente di a e la i-esima componente di t elevata alla s-esima potenza 
	elsif t.is_a?(Array) then
  	for i in 0...a.size
    	q << a[i] * (t[i]**s)
  	end
	end

  # indipendentemente da quale condizione viene seguita la funzione ritornerà un vettore q (inizializzato all'inizio) e ne farà la sommatoria degli elementi
	è = 0
  q.each do |ò|
  	è += ò
  end
  return è
end


# per la definiione di un Array che contenga tutti i valori delle sommatorie di v all'esponente n che si necessita
# al posto di chiamare ogni volta la funzione pot quando abbiamo bisogno di una sommatoria, si è prferito definire una nuova funzione var.
# tale funzione serve principalmente a ritornare un vettore con le combinazioni di x**n o y*x**n che servono per la formulazione dei modelli matematici
# in questo modo al posto di chiamare ogni volta la funzione pot, si è creato un vettore di variabili

def var(v,ser,n)
var = Array.new
  for asd in 0..n
	  var << pot(v, ser, asd)
	end
	return var
end


# Calcolo dello scarto quadratico medio (sommatoria(f(x) - y[i])**2)/n

def error(a,b,alia)
  # si inizializza la variabile locale responsabile delle somme ei singoli errori quadratici
	err = 0
	
	# la funzione itera sui valori all'interno dei nostri array di dati (x e y, dove a == x e b == y)
	for i in 0...a.size

	  # per ogni coppia di valori la funzione inizializza una vaiabile locale s che sarà responsabile di sommare il valore del modello/polinomio scelto con i valori in x
	  s = 0
		for k in 0...N
		  # per ogni valore di x si svolge il calcolo del modello/polinomio scelto moltiplicando i coefficienti di tale polinomio (trovati con la funzione fx) per il valore 
			# della i-esima componente di x
			# si noti che il vettore dei coefficienti viene iterato dalla fine
		  s += alia[N-1-k]*(a[i]**k)
		end
    
		# per come viene calcolato l'errore quadratico medio si esegue la sommatoria della differenza tra il valore di s (ovvero il valore del polinomio che approssima meglio
		# i dati proposti con le componenti i-esime del vattore x al posto delle incognite) e i valori delle componenti i-esime di y e se ne calcola il singolo quadrato rima di sommarli tutti
    err += (s - b[i])**2
		
	end

	# al termine dei due cicli for e della sommatoria si avrà un valore di errore che deve essere normalizzato al numero di dati che vengono inseriti, ovvero alla dimensione dell'array x 
	return err / a.size
end


# Idea: dare un nozione di calcolo del determinante per matrici 2x2
# l'idea alla base era ricondursi a calcolare il deteminante di matrici 2*2, togliendo righe e colonne da una matrice n*n

def det2x2(x)
  # il determinante di una matrice 2*2 esegue la differenza tra il prodotto degli elementi della diagonale principale con il prootto degli elementi extradiagonali
	# la matrice in ingresso, dunque, è nella forma 	[a1 b1] 	ma si presenta come vettore nella forma [a1 b1 a2 b2] ovvero mette in succesione i vettori riga della matrice
	#                                               	[a2 b2] 
	det_2x2 = x[0]*x[3] - x[1]*x[2]
	return det_2x2 
end


# definiamo una funzione che mi permetta di togliere righe e colonne iterativamente


def laplace(x, k, o, n)
  # dove x è il vettore di cui si vogliono eliminare righe e colonne
	#      k è la posiione dalla fine del mio vettore-matrice di cui si vuole eliminare la colonna
	#      o è la riga che si vuole eliminare
	#      n è il numero di righe o colonne della matrice quadrata x

	q = x.dup

# eliminazione colonna k-esima (partendo a contare dalla fine con posizione zero l'ultima colonna)
# si è scelto di partire dalla fine della matrice in quanto togliere un valore in una riga diversa provocherebbe una traslazione dei valori,
# partendo dalla fine invece gli eventali elementi della matrice che vengono traslati non compromettono il risultato sperato

	i = q.size-1

		until i < 0

		  # sia i l'ultimo indice di quello che mi piace chiamare vettore-matrice la k indica di quante posizioni voglio spostarmi verso l'inizio
			# del vettore-matrice
			# es. se k = 0 q.delete_at(q.size-0) eliminerà l'ultimo valore della matrice q
			q.delete_at(i-k)

			# riducendo il valore dell'indice i di n (dove n è il numero di righe della mia matrice quadrata), ottengo esattamente l'elemento sopra a quello appena cancellato
			# es. sia 	[a1 a2 a3] 		elimino la colonna      [a1 a2 a3]																													impongo i = i-n = 8-3 = 5					[a1 a2 a3]
			#						[b1 b2 b3]  	in mezzo, ovvero  	    [b1 b2 b3]  ho eliminato il valore di indice (9-1-1 = 7)            all'iterata successiva elimino    [b1    b3]
			#						[c1 c2 c3] 		k = 1 (q.size-1-1)  	  [c1    c3]  (*si ricorda che gli indice degli array partono da 0    alla posizione (5-1)=(4)					[c1    c3]
			i -= n
		end

# eliminazione della o-esima riga
		s = n-1
   	until s == 0

		  # elimino la riga o-esima togliendo tutti i valori di indice o*(n-1) con n numero di righe della matrice quadrata in questione
			# itero tale passaggio per n volte in quanto n sono anche il numero di elementi in una riga
			q.delete_at(o*(n-1))
			s -= 1
   	end
	return q
end


# fedrizzi calcola il determinante di una matrice quadrata di dimensione qualsiasi iterando il metodo di laplace

def fedrizzi(x,n)

  # inizializzo la variabille locale che raccoglierà il valore del determinante
	res = 0

		# se la mia matrice ha un solo valore in ingresso il determinante sarà tale valore
		# condizione che mi permette di non ottenere nil o errori se decido di inserire una matrice con un solo valore
  	if n == 1
	  	res = x[0]
		
		# nel caso in cui dò in input una matrice 2*2 fedrizzi chiama la funzione det2x2 e ne calcola il determinante
  	elsif n == 2
	 		res = det2x2(x)
		
		# altrimenti esegue lo sviluppo di laplace rispetto alla prima riga
		# ovvero prende il vettore-matrice x (che se è giunto a questa parte della funzione ha numero di righe e colonne >2)
		# moltiplica -1**(somma tra il coefficiente di riga con quello di colonne) * (il valore del vettore matrice nell'intersezione tra la riga e la colonna)
		# calcola il determinante (chiamando se stesso) senza la prima riga e la (n-i)-esima colonna del vettore-matrice
		# la somma di tale valore è il determinante della matrice 
		else 
			for i in 0...n
	  	  res += ((-1)**(n-i))*x[n-1-i]*fedrizzi(laplace(x,i,0,n), n-1)
			end
  	end
	return res
end



# siamo riusciti a insegnare al calcolatore come calcolare il determinante di una matrice n*n 
# il passo successivo è riuscire ad esprimere la matrice dei cofattori (trasposta)
# di fatto fedrizzi calcola determinanti quindi ci sarà utile

def cofattori(vett,n)
	cofatt = Array.new
	# fa già la trasposta  itera o righe e t colonne cancellate per poi applicare fedrizzi e calcolare il determinante
	# invertendo l'ordine con cui calcolo la matrice dei cofattori ottengo già la trasposta:
	
	for t in 0...n
	# sto calcolando il complemento algebrico togliendo righe e tenendo fissa una colonna
		for o in 0...n
		# inserendo il complemento algebrico togliendo gli elementi presenti su una stessa colonna, per righe è come se stessi già facendo la trasposta
    	cofatt << ((-1)**(o+t))*fedrizzi(laplace(vett,n-1-t,o,n),n-1)
		end
	end
return cofatt
end


def matrice_inversa(vett, det_vett)

# una matrice che ha determinante nullo non può essere invertita
raise ArgumentError, "Non è possibile invertire la matrice" unless det_vett != 0

  inversa = Array.new
	# la matrice inversa si ottiene dividendo ogni elemento della matrice per il modulo del determinante della matrice (det_vett.abs) di cui si vuole calcolare l'inversa
  cofattori(vett,N).each do |arg|
														inversa << arg/(det_vett.abs).to_f
	 											 end
	return inversa
end

# vett sarà la matrice di cui mi interessa calcolare l'inversa:
# è una matrice simmetrica che mi raccoglie esclusivamente valori del tipo x**n che sono raccolti nel vettore v

def vett(v)
	skn = 0
	vett = Array.new

	until skn == N
	
		for i in 0...N
 	
	 	 	vett << v[(N-1)*2 - skn - i] 
		end
	
		skn += 1
	end
	
	return vett
end


# definiamo una funzione che calcoli le soluzioni richieste: ovvero che esegua il prodotto tra matrice e vettori
# la funzione fx esegue semplicemente il prodotto riga per colonna tra le righe della matrice inversa (sergey)
# e la colonna di r (dove si ricorda che r è una combinazione dei valori x e y del tipo y*(x**n)

def fx(r,sergey)
  # inizializziamo un vettore che mi riunisca tutti i coefficienti del polinomio di cui sto studiando il modello
	ans = Array.new 

  # introduziamo uno starter
  t = 0

	until t == N*N
	
	# introduciamo una variabile locale che raccoglie il valore di ogni prodotto riga per colonna tra la matrie inversa e il vettore colonna r
	# tale variabile verrà azzerata ad ogni iterata
		check = 0
	  
		for reus in 0...N
		
		  # si noti che il vettore r è "al contrario" quindi i valori che ci interessano moltiplicare per la prima riga della matrice inversa (sergey)
			# (pensati da sinistra verso destra) vanno moltiplicati per gli elementi del vettore colonna (pensato dal basso verso l'alto)
			check += sergey[t+reus]*r[(N-1)-reus]
	  end
    
		# inserisco i valori ottenuti nel vettore inizializzato all'inizio e proseguo all'iterata successiva o al termine del loop
		ans << check
    t += N
	end

	return ans
end



#----------------------------------------------------------------------------------------------------------------------------------------------------

# grado_polinomio = N-1
N = 3


z = [50, 100, 200, 300, 500]
m = [4300, 8200, 16000, 23500, 42000]

# Errori sul tipo di dati in esame
[z,m].each do |vett|
	vett.each do |d|
		raise ArgumentError, "I dati delle ascisse non sono del tipo richiesto" unless d.is_a?(Numeric)
	end
end


=begin

Funzioni: in Math.____(lg) inserire:
  
	-  'cos'  (     coseno)
  - 'acos'  (arco coseno)
	-  'sin'  (       seno)
	- 'asin'  (arco   seno)
	- ' tan'  (     tangente)
	- 'atan'  (arco tangente)

  - ' cosh' (       coseno iperbolico)
	- 'acosh' (arco   coseno iperbolico)
  - ' sinh'	(		 	    seno iperbolico)
	- 'asinh' (arco     seno iperbolico)
	- ' tanh' (     tangente iperbolica)
	- 'atanh' (arco tangente iperbolica)

	- 'exp'   (esponenziale)						 | si preferisca eseguire il logaritmo della y
	- 'log' 	(logaritmo naturale)       | piuttosto che un esponenziale del polinomio
	- 'log10' (logaritmo in base 10)		 | di grado 2

	- 'sqrt'  (radice quadrata)

  - nel caso non si volessero applicare funzioni, ma calcolare semplicemente il modello lineare o quadratico lasciare - {|lg| lg} - come blocco

=end

x = z.each.map(&:to_f).map{|lg| (lg)}
y = m.each.map(&:to_f).map{|lg| (lg)}

# v è il vettore che raccoglie la sommatoria delle potenze degli elementi di x
# se "i" è l'indice dell'i-esima componente del vettore v essa corrisponde a x**i
v = var(x,1,(N-1)*2)

# r è il vettore che raccoglie la sommatoria degli elementi di y e x nella forma y*(x**n)
# se "i" è l'indice dell'i-esima componente del vettore r essa corrisponde a y*(x**i)
r = var(y,x,N-1)

# sergey è la matrice inversa
sergey = matrice_inversa(vett(v),fedrizzi(vett(v),N))

# mazzoldi è la matrice che raccogli i coefficienti del polinomio di cui voglio studiare il modello
# in questo caso se "i" è l'indice dell'i-esima componente del vettore mazzoldi
# il polinomio sarà nella forma 		mazzoldi[i] * x^(N-1-i) 
mazzoldi = fx(r,sergey)

#----------------------------------------------------------------------------------------------------------------------------------------------------

print "Grado monomio".ljust(0)
print "        ----------------------------------------        "
puts "Valore coefficiente".rjust(20)

for i in 0...mazzoldi.size
  print "#{i}".ljust(0)
	print "                    ----------------------------------------        "
	puts "#{mazzoldi[N-1-i]}".rjust(18)
end

puts "L'errore quadratico medio è: #{error(x,y,mazzoldi)}"
