# Se crea la población inicial a partir de summulated anealing
filename<- "had12.dat"
instancia<-readQAP(filename)
n <- instancia$n

i<- 0
p <- list()
#while (i < 20) {
#  p[[i+1]] <- (SA_QAP("bur26a.dat",0.8,2000, 0.1, 2,2,0))
#  i <- i +1
#}

time<- proc.time()
size_p = 100
for (i in 1:size_p) {
  p[[i]] <- sample(1:n,n) 
   }

#Algoritmo genético
t = 0
prob = 0.1
final <- list()
while (t < 100) {
  #Selección: Torneo
  p_prima <- selection(p,n,instancia$f,instancia$d,size_p)
  p_prima <- reproduction_crossing(p_prima, length(p_prima),size_p)
  p_prima <- mutation(p_prima, length(p_prima),size_p, prob,3)
  p <- evaluate_and_replace(p_prima,p,instancia$f, instancia$d,length(p_prima)) 
  final[t+1] <- best(p,instancia$f,instancia$d)
  t = t + 1
}

print(proc.time()-time)

#bur26a.dat1
#bur26a.dat2
#bur26a.dat3

#had12.dat1
#had12.dat2
#had12.dat3

#rou15.dat1
#rou15.dat2
#rou15.dat3

#chr18a.dat1
#chr18a.dat2
#chr18a.dat3

#nug12.dat1
#nug12.dat2
#nug12.dat3

#chr15c.dat1
#chr15c.dat2
#chr15c.dat3

