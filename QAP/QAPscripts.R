
readQAP<-function(name){ 
a <- read.delim(name,header=FALSE, sep ="")
n<-as.integer(a[1,1])
fl<-a[2:(n+1),1:n]
dis<-a[(n+2):(n+n+1),1:n]
d <- list(n=n, f= fl, d = dis)
return(d)
}

evaluarQAP<-function(sol, f, d){
  acum<-0
  n<-length(sol)
  for(i in 1:n){
    for(j in 1:n){
      acum = acum + f[i,j]*d[sol[i],sol[j]]   
    }
  }
  return(acum)
}

best<- function(p,f,d){
  new <- list()
  for (i in 1:length(p)) {
    new[i] <- evaluarQAP(p[[i]],f,d)
  }
  new[which.min(new)]
}

swap<-function(sol,i,j){
  piv<-sol[i]
  sol[i]<-sol[j]
  sol[j]<-piv
  sol
}

selection <- function(p,n,f,d,size_p){
  fitness <- list()
  i = 0
  for (solution in p) {
    fitness[i+1] <- evaluarQAP(solution,f,d)
    i = i + 1
  }
  i = 0
  select = list()
  tournament  = list()
  while (i < size_p) {
    x <- sample(1:length(fitness), 5, replace=F)
    tournament[1]<- fitness[[x[1]]]  
    tournament[2]<- fitness[[x[2]]]
    tournament[3]<- fitness[[x[3]]]
    tournament[4]<- fitness[[x[4]]]
    tournament[5]<- fitness[[x[5]]]
    select[i+1] = p[which.min(tournament)]
    i = i + 1
    
  }
  select 
}








reproduction_crossing<-function(p_prima, number,n){
  i <- 0
  new_list <- list()
  while (i < n) {
    x <- sample(1:n, 2, replace=F)
    new_list[[length(new_list) + 1]] <- crossing(p_prima[x[1]], p_prima[x[2]],number)
    i <- i + 1
  }
  new_list
}

crossing <- function(lista1, lista2,m){
  n = ceiling(length(lista1[[1]])/2)
  new_list = lista1[[1]][1:n]
  i <- 0
  j <- 0
  while (i < length(lista2[[1]])) {
    if(!lista2[[1]][i+1] %in% new_list){
      new_list[[length(new_list)+1]] = lista2[[1]][i+1]
    }
    i <- i + 1
  }
  new_list
}


mutation<- function(p_prima, number, n, prob,type){
  for (i in 1:n) {
    if(runif(1,0,1) < prob){
      if(type == 1){
        max_p_prima = max(p_prima[[i]])
        p_prima[[i]] <- p_prima[[i]]-1
        p_prima[[i]][ which.min(p_prima[[i]])] <- max_p_prima
      }
      else if(type==2){
        x <- sample(1:n, 2, replace=F)
        p_prima[[i]]<-swap(p_prima[[i]],x[1],x[2])
      }
      else{
        x <- sample(1:n, 6, replace=T)
        p_prima[[i]]<-swap(p_prima[[i]],x[1],x[2])
        p_prima[[i]]<-swap(p_prima[[i]],x[3],x[4])
        p_prima[[i]]<-swap(p_prima[[i]],x[5],x[6])
      }
    }
  }
  p_prima
  
}

evaluate_and_replace<- function(p_prima,p,f,d,n){
  i = 0
  evaluation_new = list()
  evaluation_old = list()
  result = list()
  j = 0
  while (i < n)  {
    evaluation_new[[i+1]] <- evaluarQAP(p_prima[[i+1]], f, d)
    evaluation_old[[i+1]] <- evaluarQAP(p[[i+1]], f, d)
    i = i + 1
  }
  aux_evaluation_new = evaluation_new
  aux_evaluation_old = evaluation_old
  n = ceiling(n*0.4)
  
  for (i in 1:n){
    result <- append(result,p_prima[which.min(evaluation_new)]) 
    evaluation_new[which.min(evaluation_new)] <- exp(99)
  }
  
  n = n+ceiling(n*0.2)
  for (i in 1:n){
    result <- append(result,p[which.min(evaluation_old)]) 
    evaluation_old[which.min(evaluation_old)] <- exp(99)
  }
  n = n+ceiling(n*0.2)
  for (i in 1:n){
    result <- append(result,p_prima[which.max(aux_evaluation_new)]) 
    aux_evaluation_new[which.max(aux_evaluation_new)] <- -1*exp(99)
  }
  
  n = length(p_prima)-n
  for (i in 1:n){
    result <- append(result,p[which.max(aux_evaluation_old)]) 
    aux_evaluation_old[which.max(aux_evaluation_old)] <- -1*exp(99)
  }
  result
  
}