
# %% Librerie

    # Libreria per creare e manipolare grafi e reti
import networkx as nx

    # Libreria per lavorare con molti oggetti matematici
import numpy as np

    # Modulo della librerai «matplotlib» per la visualizzazione di grafici («plt.figure()», «ax.scatter» eccetera)
import matplotlib.pyplot as plt

    # Comando necessario per aggiornare correttamente i grafici in modalità interattiva
from IPython.display import display

# %% Grafo e figura

    # Carica la filza «graphml»
G = nx.read_graphml("./Connettoma_Prova.graphml")

    # Crea una figura
fig = plt.figure()
ax = fig.add_subplot(111,projection='3d')

    # Imposta la vista del plottaggio
ax.view_init(elev=90,azim=90)
plt.tight_layout()

# %% Coordinate e plottamento

    # Disegna i nodi
p = np.zeros((83,3))
for i in G.nodes():
    c = G.nodes[i]
    p[int(i)-1,0] = c['dn_position_x']
    p[int(i)-1,1] = c['dn_position_y']
    p[int(i)-1,2] = c['dn_position_z']

ax.scatter(p[:,0],p[:,1],p[:,2],c='r',s=50)

    # Comandi per aggiornare la figura qualunque sia la modalità usata
plt.show()   # Mostra quanto plottato «non» in modalità interattiva
display(fig) # Mostra quanto plottato in modalità interattiva

# %% Laplaciana singola

A = np.zeros((83,83))

for ni in G.adj:
    iNI = int(ni) # Inidce del nodo iniziale
    if(G.adj[ni] != 0):
        for nf in G.adj[ni]:
            iNF = int(nf) # Inidce del nodo finale

            nF = G.adj[ni][nf]['number_of_fibers']
            fL = G.adj[ni][nf]['fiber_length_mean']

            A[iNI-1,iNF-1] = nF/fL
    else: # Se il nodo non è connesso ad altri nodi si pone il valore della laplaciana nullo
        A[iNI,iNF] = 0

cax = plt.matshow(A,cmap='viridis')
plt.colorbar(cax)
plt.show() # Mostra quanto plottato «non» in modalità interattiva

# %% Laplaciana media

def CalcolaLaplciana(G):
    A = np.zeros((83,83))

    for ni in G.adj:
        iNI = int(ni) # Inidce del nodo iniziale
        if(G.adj[ni] != 0):
            for nf in G.adj[ni]:
                iNF = int(nf) # Inidce del nodo finale

                nF = G.adj[ni][nf]['number_of_fibers']
                fL = G.adj[ni][nf]['fiber_length_mean']

                A[iNI-1,iNF-1] = nF/fL
        else: # Se il nodo non è connesso ad altri nodi si pone il valore della laplaciana nullo
            A[iNI,iNF] = 0

    return A

with open("./Nomi_Filze_Connettomi.txt","r") as lista:
    nomi = lista.readlines()

AMedia = np.zeros((83,83))

for paziente in nomi:
    paziente = "./"+paziente.strip() # Si rimuovono gli spazi bianchi e gli accapi

    G = nx.read_graphml(paziente)
    A = CalcolaLaplciana(G)

    AMedia += A

AMedia /= len(nomi)

cax = plt.matshow(AMedia,cmap='viridis')
plt.colorbar(cax)
plt.show() # Mostra quanto plottato «non» in modalità interattiva

# %% Scrittura LMedia

np.savetxt("./Matrice_Adiacenza_Media.txt",AMedia,delimiter=",")

# %% Note finali

# plt.show(block=True) # Mostra quanto plottato evitando che la finestra si chiuda alla fine dell'esecuzione della filza «.py»; da usare solo qualora la modalità è interattiva, ossia quando v'è «plt.ion()»
