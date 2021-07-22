import random
import matplotlib.pyplot as plt
import time
def randomSolution(n):
    #Se genera una solución inicial aleatoria, ya que si se realiza random no es factible 
    #la mayor parte del tiempo
    return [*range(0,n,1)]


def feasible(matrix, solution):
    '''
    Entrada: Matriz que indica si los nodos son adyacentes
             Solución a evaluar
    Proceso: Recorre la solución y comprueba en la matriz si los nodos adyacentes tienen
             o no los mismos colores.
    Salida: True o False si es factible o no.

    '''
    j = 0
    while j < len(matrix):
        i = 0
        while i < len(matrix):
            if(matrix[j][i] == 1 and solution[i] == solution[j] and i!=j):
                return False
            i += 1
        j += 1
    return True

def neighbor(matrix, solution, colors):
    '''
    Entrada: Matriz que indica si los nodos son adyacentes
             Solución a evaluar
             Colores existentes 
    Proceso: Se obtiene una posición aleatoria y se evalúa los colores de los nodos adyacentes
             a esta, de manera que estos sean descartados al crear la nueva solución y que esta sea factible.
    Salida: Nueva solución. 
    '''
    pos = random.randint(0,len(solution)-1)
    i = 0
    new_colors = colors.copy()
    aux_solution = solution.copy()
    while i < len(matrix):
        if(matrix[pos][i] == 1 and pos!=i and aux_solution[i] in new_colors):
            new_colors.remove(aux_solution[i])
        i += 1
    new_color = new_colors[random.randint(0,len(new_colors)-1)]
    aux_solution[pos] = new_color
    return aux_solution

def fitness(solution):
    '''
    Entrada: Solución actual
    Proceso: Se calcula la cantidad de colores diferentes que tiene la solución actual.
    Salida: Cantidad de colores que usa la solución
    '''
    return len(set(solution))

def create_neighbors(solution, matrix, colors, size): 
    '''
    Entrada: Solución actual
             Matriz de adyacencia
             Listado de colores
             Tamaño de la vecindad 
    Proceso: Se crean los vecinos seleccionando el valor a reemplazar de manera aleatoria y se restringen los colores
             a aquellos que no se encuentran entre los nodos adyacentes, de esta manera se logra evitar la infactibilidad.
             Se retornan todos los vecinos generados.
    Salida:  Todos los vecinos generados.
    ''' 
    i = 0
    neighbors = []
    while i < size:
        new_neighbor = neighbor(matrix, solution, colors).copy()
        neighbors.append(new_neighbor[:])
        i = i + 1
    return neighbors

def best_neighbor(neighbors,n):
    '''
    Entrada: Vecindad
             Número de elementos que tiene cada solución
    Proceso: Se recorren los vecinos, se calcula su fitness y se entrega el que tiene un mejor desempeño.
    Salida:  Mejor vecino y fitness.
    '''
    best_fitness = n
    best_neighbor = []
    for element in neighbors:
        if(best_fitness > fitness(element)):
            best_fitness = fitness(element)
            best_neighbor = element.copy()
    return best_neighbor, best_fitness

def decrease_criterion(tabu_list):
    '''
    Entrada: Lista tabu 
    Proceso: Se disminuye en 1 los valores que son mayores a 0 y que indican que el movimiento se encuentra
             en la lista tabu.
    Salida:  Lista tabu actualizada
    '''
    i = 0
    while i < len(tabu_list):
        j = 0
        while j < len(tabu_list):
            if(tabu_list[i][j] > 0):
                tabu_list[i][j] -= 1
            j = j + 1
        i = i + 1
    return tabu_list

def remove_neighbor(neighbors,n):
    '''
    Entrada: Lista de vecinos 
             Elementos en cada solución
    Proceso: Se recorren los vecinos y se elimina aquel que es el mejor, debido a que ya se encuentra el
             movimiento que realiza en la lista tabu
    Salida:  Lista de vecinos actualizada
    '''
    best, aux = best_neighbor(neighbors,n)
    count = 0
    for i in neighbors:
        if i == best:
            neighbors.remove(i)
    return neighbors


def comparison(s,neighbors,tabu_list, aspiration_criterion,n):
    '''
    Entrada:
    Proceso: Se selecciona la mejor solución, se determina la modificación que se realizó para saber si es que se encuentra o no
             en la lista tabu. Si se encuentra, se descarta la solución y se busca otra en el vecindario. Si no se encuentra, el 
             movimiento se agrega a la lista tabu, se disminuye el criterio de aspiración para el resto de los elementos y se 
            retorna la solución como la mejor. 
            Si la nueva solución y la anterior son iguales, se conserva y se continúa iterando. 
    Salida: Mejor solución encontrada
    '''
    i = 0
    aux = True
    while(aux):
        s_prima,b_fitness = best_neighbor(neighbors,n)
        i = 0 
        while i < len(s):
            if(s[i] != s_prima[i] and tabu_list[s[i]][s_prima[i]] == 0 and fitness(s) >= b_fitness):
                tabu_list = decrease_criterion(tabu_list)
                tabu_list[s[i]][s_prima[i]] = aspiration_criterion
                tabu_list[s_prima[i]][s[i]] = aspiration_criterion
                return s_prima
            elif(s[i] != s_prima[i] and tabu_list[s[i]][s_prima[i]] == 0 and fitness(s) < b_fitness):
                return s
            elif(s[i] != s_prima[i] and tabu_list[s[i]][s_prima[i]] > 0):
                neighbors = remove_neighbor(neighbors,n)
                i = len(s)
            elif(i == len(s)-1 and s[i] == s_prima[i]):
                return s
            i += 1
    return s


def initial_tabu(n):
    '''
    Proceso: Genera la lista de lista para almacenar la matriz que representa la lista tabu.
    '''
    return [[0 for col in range(n)] for row in range(n)]




'''
VARIABLES A MODIFICAR
'''
start_time = time.time()

n = 87                      #Cantidad de nodos
name = "grafo87.txt"       #Nombre del archivo de entrada
aspiration_criterion = 5    #Criterio de aspiración (iteraciones en que se conserva un intercambio en la lista tabu)
size = 30                   #Tamaño de la vecindad
iteraciones= 10000          #Número de iteraciones

colors = randomSolution(n).copy()
f = open(name, "r")
lista = []
graph = initial_tabu(n)

for linea in f:
    linea = linea.split(" ")
    graph[int(linea[1])-1][int(linea[2].split("\n")[0])-1] = 1
    graph[int(linea[2].split("\n")[0])-1][int(linea[1])-1] = 1

s = randomSolution(n).copy()
tabu_list = initial_tabu(n)

best_all = []
for i in range(0,iteraciones):
    all_neighbors = (create_neighbors(s, graph, colors, size)).copy()
    s = comparison(s,all_neighbors,tabu_list, aspiration_criterion,n)
    best_all.append(fitness(s))
elapsed_time = time.time() - start_time
print("El valor óptimo de colores es: " + str(fitness(s)))
print("El tiempo de ejecución es de: " + str(elapsed_time) + " segundos")
plt.plot(best_all)
plt.savefig("Ejemplo.jpg")





