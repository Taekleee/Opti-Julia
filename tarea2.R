# Se crea la población inicial a partir de summulated anealing
filename<- "bur26a.dat"
instancia<-readQAP(filename)
n <- instancia$n
i<- 0
p <- list()
while (i < 20) {
  p[[i+1]] <- (SA_QAP("bur26a.dat",0.8,2000, 0.1, 2,2,0))
  i <- i +1
}
for (i in 1:50) {
  p[[i]] <- sample(1:26,26) 
   }

#Algoritmo genético
t = 0
size_p = 50
prob = 0.1
final <- list()
while (t < 20) {
  #Selección: Torneo
  p_prima <- selection(p,n,instancia$f,instancia$d,size_p)
  p_prima <- reproduction_crossing(p_prima, length(p_prima),size_p)
  p_prima <- mutation(p_prima, length(p_prima),size_p, prob,2)
  p <- evaluate_and_replace(p_prima,p,instancia$f, instancia$d,length(p_prima)) 
  final[t+1] <- best(p,instancia$f,instancia$d)
  t = t + 1
}

