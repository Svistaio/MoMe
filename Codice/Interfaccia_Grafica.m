function [sPL,sPM,sCI,sPT] = Interfaccia_Grafica()

    % Variabili globali per tracciare se sono stati premuti i bottoni; infatti Matlab, per qualche motivazione,
    % cambia «AvvioBott.Value» e «EsciBott.Value» da 0 a 1 solo finché si è all'interno della funzione di richiamo:
    % una volta fuori il suo valore è riportato a zero, come se non fosse stato premuto
    % (si v. «https://it.mathworks.com/matlabcentral/answers/394250-how-do-i-define-a-pushbutton-to-change-the-value-of-a-variable»)
    global avvia termina
    avvia = 0; termina = 0;

%% Casi studio

    global sCS   % Struttura dei casi di studio
    sCS = []; sCS.NCS = string([]);

    % Caso di studio all'avvio
        n = "CSA"; sCS.(n).Modello = "Caso di Studio all'avvio";
    sCS.(n).TipoL = 1; % Tipo di laplaciana
    sCS.(n).NCT = 1; sCS.(n).PCT = 1; sCS.(n).TipoPeso = 1; sCS.(n).TipoMisura = 1; sCS.(n).Proc = [1 1 1e-5];
    sCS.(n).TipoM = 1; % Tipo di modello
    sCS.(n).Car1 = 0.5; sCS.(n).Car2 = 0; sCS.(n).Car3 = 0;
    sCS.(n).Car4 = 0; sCS.(n).Car5 = 0; sCS.(n).Car6 = 0;
    sCS.(n).condDim = 0; sCS.(n).condAcc = 0; % Dipendenza dalla dimensione e dell'accumulazione dell'ultima catena
    sCS.(n).condLD = 0; sCS.(n).tipoLD = 1; % Presenza della dinamica e [nel caso] relativo tipo
    sCS.(n).condDeD = 0; sCS.(n).tipoDeD = 1; % Presenza della dinamica e [nel caso] relativo tipo
    sCS.(n).NI = "Entorhinal"; sCS.(n).CI1 = 0.1; sCS.(n).CI2 = 0;
    sCS.(n).TipoD = 1; % Tipo di discretizzazione in tempo
    sCS.(n).Passo = 0.001; sCS.(n).T = 100; % Parametri temporali
    sCS.(n).nIS = 0.1*sCS.(n).T/sCS.(n).Passo; % Numero d'istanti salvati
    sCS.(n).contrTemp = 1; % Presenza della contrazione temporale
    sCS.(n).risTemp   = 0; % Presenza del riscalamento temporale

    % Modello Fisher-Kolmogorov dell'articolo statico dimensionale
        n = "FKDS"; sCS.(n).Modello = "Fornari FK [statico/dimensionale]"; sCS.NCS(end+1) = sCS.(n).Modello;
    sCS.(n).TipoL = 1; % Tipo di laplaciana
    sCS.(n).NCT = 1; sCS.(n).PCT = 1; sCS.(n).TipoPeso = 1; sCS.(n).TipoMisura = 1; sCS.(n).Proc = [1 3 2*10^(-5)];
    sCS.(n).TipoM = 1; % Tipo di modello
    sCS.(n).Car1 = 0.5; sCS.(n).Car2 = 0; sCS.(n).Car3 = 0;
    sCS.(n).Car4 = 0; sCS.(n).Car5 = 0; sCS.(n).Car6 = 0;
    sCS.(n).condDim = 0; sCS.(n).condAcc = 0; % Dipendenza dalla dimensione e dell'accumulazione dell'ultima catena
    sCS.(n).condLD = 0; sCS.(n).tipoLD = 1; % Presenza della dinamica e [nel caso] relativo tipo
    sCS.(n).condDeD = 0; sCS.(n).tipoDeD = 1; % Presenza della dinamica e [nel caso] relativo tipo
    sCS.(n).NI = "Entorhinal"; sCS.(n).CI1 = 0.1; sCS.(n).CI2 = 0;
    sCS.(n).TipoD = 2; % Tipo di discretizzazione in tempo
    sCS.(n).Passo = 0.4; sCS.(n).T = 30; % Parametri temporali
    sCS.(n).nIS = sCS.(n).T/sCS.(n).Passo; % Numero d'istanti salvati
    sCS.(n).contrTemp = 0; % Presenza della contrazione temporale
    sCS.(n).risTemp   = 0; % Presenza del riscalamento temporale

    % Modello Eterodimero dell'articolo statico dimensionale
        n = "EDDS"; sCS.(n).Modello = "Fornari ED [statico/dimensioale]"; sCS.NCS(end+1) = sCS.(n).Modello;
    sCS.(n).TipoL = 1; % Tipo di laplaciana
    sCS.(n).NCT = 1; sCS.(n).PCT = 1; sCS.(n).TipoPeso = 1; sCS.(n).TipoMisura = 1; sCS.(n).Proc = [1 3 2*10^(-5)];
    sCS.(n).TipoM = 2; % Tipo di modello
    sCS.(n).Car1 = 1; sCS.(n).Car2 = 0.5; sCS.(n).Car3 = 0.5;
    sCS.(n).Car4 = 0.5; sCS.(n).Car5 = 0; sCS.(n).Car6 = 0;
    sCS.(n).condDim = 0; sCS.(n).condAcc = 0; % Dipendenza dalla dimensione e dell'accumulazione dell'ultima catena
    sCS.(n).condDeD = 0; sCS.(n).tipoDeD = 4; % Presenza della dinamica e [nel caso] relativo tipo
    sCS.(n).condLD = 0; sCS.(n).tipoLD = 1; % Presenza della dinamica e [nel caso] relativo tipo
    sCS.(n).NI = "Entorhinal"; sCS.(n).CI1 = 2; sCS.(n).CI2 = 0.1;
    sCS.(n).TipoD = 2; % Tipo di discretizzazione in tempo
    sCS.(n).Passo = 0.4; sCS.(n).T = 30; % Parametri temporali
    sCS.(n).nIS = sCS.(n).T/sCS.(n).Passo; % Numero d'istanti salvati
    sCS.(n).contrTemp = 0; % Presenza della contrazione temporale
    sCS.(n).risTemp   = 0; % Presenza del riscalamento temporale

    % Modello Smoluchowski Fornari statico dimensionale nodale
        n = "SMOFNDS"; sCS.(n).Modello = "Fornari SMO [nodo/dimensionale/statico]"; sCS.NCS(end+1) = sCS.(n).Modello;
    sCS.(n).TipoL = 1; % Tipo di laplaciana
    sCS.(n).NCT = 1; sCS.(n).PCT = 1; sCS.(n).TipoPeso = 1; sCS.(n).TipoMisura = 1; sCS.(n).Proc = [1 3 2*10^(-5)];
    sCS.(n).TipoM = 3; % Tipo di modello
    sCS.(n).Car1 = 50; sCS.(n).Car2 = 1; sCS.(n).Car3 = 0.5;
    sCS.(n).Car4 = 0; sCS.(n).Car5 = 10; sCS.(n).Car6 = 0.048*2;
    sCS.(n).condDim = 0; sCS.(n).condAcc = 0; % Dipendenza dalla dimensione e dell'accumulazione dell'ultima catena
    sCS.(n).condLD = 0; sCS.(n).tipoLD = 1; % Presenza della dinamica e [nel caso] relativo tipo
    sCS.(n).condDeD = 0; sCS.(n).tipoDeD = 1; % Presenza della dinamica e [nel caso] relativo tipo
    sCS.(n).NI = "Entorhinal"; sCS.(n).CI1 = 0.00016; sCS.(n).CI2 = 2;
    sCS.(n).TipoD = 1; % Tipo di discretizzazione in tempo
    sCS.(n).Passo = 0.04; sCS.(n).T = 60; % Parametri temporali
    sCS.(n).nIS = sCS.(n).T/sCS.(n).Passo; % Numero d'istanti salvati
    sCS.(n).contrTemp = 0; % Presenza della contrazione temporale
    sCS.(n).risTemp   = 0; % Presenza del riscalamento temporale

    %%%
    n = "LineaStandardoModiche"; sCS.(n).Modello = '';
    sCS.NCS(end+1) = sCS.(n).Modello; sCS.(n).direzione = 0;
    %%%

    % Modello Eterodimero dell'articolo statico dimensionale lento
        n = "EDASL"; sCS.(n).Modello = "Fornari ED [statico/dimensioale/lento]"; sCS.NCS(end+1) = sCS.(n).Modello;
    sCS.(n).TipoL = 1; % Tipo di laplaciana
    sCS.(n).NCT = 1; sCS.(n).PCT = 1; sCS.(n).TipoPeso = 1; sCS.(n).TipoMisura = 1; sCS.(n).Proc = [1 1 2e-6];
    sCS.(n).TipoM = 2; % Tipo di modello
    sCS.(n).Car1 = 0.01; sCS.(n).Car2 = 0.005; sCS.(n).Car3 = 0.005;
    sCS.(n).Car4 = 0.005; sCS.(n).Car5 = 0; sCS.(n).Car6 = 0;
    sCS.(n).condDim = 0; sCS.(n).condAcc = 0; % Dipendenza dalla dimensione e dell'accumulazione dell'ultima catena
    sCS.(n).condDeD = 0; sCS.(n).tipoDeD = 1; % Presenza della dinamica e [nel caso] relativo tipo
    sCS.(n).condLD = 0; sCS.(n).tipoLD = 1; % Presenza della dinamica e [nel caso] relativo tipo
    sCS.(n).NI = "Entorhinal"; sCS.(n).CI1 = 2; sCS.(n).CI2 = 0.1;
    sCS.(n).TipoD = 1; % Tipo di discretizzazione in tempo
    sCS.(n).Passo = 0.04; sCS.(n).T = 6000; % Parametri temporali
    sCS.(n).nIS = 5000; % Numero d'istanti salvati
    sCS.(n).contrTemp = 1; % Presenza della contrazione temporale
    sCS.(n).risTemp   = 0; % Presenza del riscalamento temporale

    % Modello Smoluchowski Fornari statico dimensionale retale
        n = "SMOFRDS"; sCS.(n).Modello = "Fornari SMO [rete/dimensionale/statico]"; sCS.NCS(end+1) = sCS.(n).Modello;
    sCS.(n).TipoL = 1; % Tipo di laplaciana
    sCS.(n).NCT = 1; sCS.(n).PCT = 1; sCS.(n).TipoPeso = 1; sCS.(n).TipoMisura = 1; sCS.(n).Proc = [1 1 7.5e-6];
    sCS.(n).TipoM = 3; % Tipo di modello
    sCS.(n).Car1 = 50; sCS.(n).Car2 = "1/83^2"; sCS.(n).Car3 = "0.5/83";
    sCS.(n).Car4 = 0; sCS.(n).Car5 = "10"; sCS.(n).Car6 = "0.048*2/83";
    sCS.(n).condDim = 0; sCS.(n).condAcc = 0; % Dipendenza dalla dimensione e dell'accumulazione dell'ultima catena
    sCS.(n).condLD = 0; sCS.(n).tipoLD = 1; % Presenza della dinamica e [nel caso] relativo tipo
    sCS.(n).condDeD = 0; sCS.(n).tipoDeD = 1; % Presenza della dinamica e [nel caso] relativo tipo
    sCS.(n).NI = "Entorhinal"; sCS.(n).CI1 = "0.00016"; sCS.(n).CI2 = "2/83";
    sCS.(n).TipoD = 1; % Tipo di discretizzazione in tempo
    sCS.(n).Passo = 0.04; sCS.(n).T = "10e3"; % Parametri temporali
    sCS.(n).nIS = 5000; % Numero d'istanti salvati
    % sCS.(n).nIS = sCS.(n).T/sCS.(n).Passo; % Numero d'istanti salvati
    sCS.(n).contrTemp = 1; % Presenza della contrazione temporale
    sCS.(n).risTemp   = 0; % Presenza del riscalamento temporale

    % Modello Smoluchowski Fornari statico adimensionale nodale
        n = "SMOFNAS"; sCS.(n).Modello = "Fornari SMO [nodo/adimensionale/statico]"; sCS.NCS(end+1) = sCS.(n).Modello;
    sCS.(n).TipoL = 1; % Tipo di laplaciana
    sCS.(n).NCT = 1; sCS.(n).PCT = 1; sCS.(n).TipoPeso = 1; sCS.(n).TipoMisura = 1; sCS.(n).Proc = [1 1 1e-3];
    sCS.(n).TipoM = 3; % Tipo di modello
    sCS.(n).Car1 = 50; sCS.(n).Car2 = "1/(2^2)/10"; sCS.(n).Car3 = "0.5/2/10";
    sCS.(n).Car4 = 0; sCS.(n).Car5 = "10/10"; sCS.(n).Car6 = "0.048*2/2/10";
    sCS.(n).condDim = 0; sCS.(n).condAcc = 0; % Dipendenza dalla dimensione e dell'accumulazione dell'ultima catena
    sCS.(n).condLD = 0; sCS.(n).tipoLD = 1; % Presenza della dinamica e [nel caso] relativo tipo
    sCS.(n).condDeD = 0; sCS.(n).tipoDeD = 1; % Presenza della dinamica e [nel caso] relativo tipo
    sCS.(n).NI = "Entorhinal"; sCS.(n).CI1 = "0.00016/10"; sCS.(n).CI2 = "2/2";
    sCS.(n).TipoD = 1; % Tipo di discretizzazione in tempo
    sCS.(n).Passo = 0.004; sCS.(n).T = "1.5e3"; % Parametri temporali
    sCS.(n).nIS = 5e3; % Numero d'istanti salvati
    % sCS.(n).nIS = sCS.(n).T/sCS.(n).Passo; % Numero d'istanti salvati
    sCS.(n).contrTemp = 1; % Presenza della contrazione temporale
    sCS.(n).risTemp   = 0; % Presenza del riscalamento temporale

    % Modello Smoluchowski Fornari statico adimensionale retale
        n = "SMOFRAS"; sCS.(n).Modello = "Fornari SMO [rete/adimensionale/statico]"; sCS.NCS(end+1) = sCS.(n).Modello;
    sCS.(n).TipoL = 1; % Tipo di laplaciana
    sCS.(n).NCT = 1; sCS.(n).PCT = 1; sCS.(n).TipoPeso = 1; sCS.(n).TipoMisura = 1; sCS.(n).Proc = [1 2 7.5e-6];
    sCS.(n).TipoM = 3; % Tipo di modello
    sCS.(n).Car1 = 50; sCS.(n).Car2 = "1/(2^2)/10/83^2"; sCS.(n).Car3 = "0.5/2/10/83";
    sCS.(n).Car4 = 0; sCS.(n).Car5 = "10/10"; sCS.(n).Car6 = "0.048*2/2/10/83";
    sCS.(n).condDim = 0; sCS.(n).condAcc = 0; % Dipendenza dalla dimensione e dell'accumulazione dell'ultima catena
    sCS.(n).condLD = 0; sCS.(n).tipoLD = 1; % Presenza della dinamica e [nel caso] relativo tipo
    sCS.(n).condDeD = 0; sCS.(n).tipoDeD = 1; % Presenza della dinamica e [nel caso] relativo tipo
    sCS.(n).NI = "Entorhinal"; sCS.(n).CI1 = "0.00016/10"; sCS.(n).CI2 = "2/2/83";
    sCS.(n).TipoD = 1; % Tipo di discretizzazione in tempo
    sCS.(n).Passo = 0.04; sCS.(n).T = "10e4"; % Parametri temporali
    sCS.(n).nIS = 5000; % Numero d'istanti salvati
    % sCS.(n).nIS = sCS.(n).T/sCS.(n).Passo; % Numero d'istanti salvati
    sCS.(n).contrTemp = 1; % Presenza della contrazione temporale
    sCS.(n).risTemp   = 0; % Presenza del riscalamento temporale

    % Modello Smoluchowski Goriely statico adimensionale relate
        n = "SMOGRAS"; sCS.(n).Modello = "Goriely SMO [rete/adimensionale/statico]"; sCS.NCS(end+1) = sCS.(n).Modello;
    sCS.(n).TipoL = 1; % Tipo di laplaciana
    sCS.(n).NCT = 1; sCS.(n).PCT = 1; sCS.(n).TipoPeso = 1; sCS.(n).TipoMisura = 1; sCS.(n).Proc = [1 2 2*10^(-5)];
    sCS.(n).TipoM = 3; % Tipo di modello
    sCS.(n).Car1 = 200; sCS.(n).Car2 = "0.01/(83^2)"; sCS.(n).Car3 = "0.01/83";
    sCS.(n).Car4 = 0; sCS.(n).Car5 = 1; sCS.(n).Car6 = "0.001/83";
    sCS.(n).condDim = 0; sCS.(n).condAcc = 0; % Dipendenza dalla dimensione e dell'accumulazione dell'ultima catena
    sCS.(n).condLD = 0; sCS.(n).tipoLD = 4; % Presenza della dinamica e [nel caso] relativo tipo
    sCS.(n).condDeD = 0; sCS.(n).tipoDeD = 1; % Presenza della dinamica e [nel caso] relativo tipo
    sCS.(n).NI = "Entorhinal"; sCS.(n).CI1 = "0.001"; sCS.(n).CI2 = "1/83";
    sCS.(n).TipoD = 1; % Tipo di discretizzazione in tempo
    sCS.(n).Passo = 0.04; sCS.(n).T = 120000; % Parametri temporali
    sCS.(n).nIS = 5000; % Numero d'istanti salvati
    sCS.(n).contrTemp = 1; % Presenza della contrazione temporale
    sCS.(n).risTemp   = 0; % Presenza del riscalamento temporale

    % Modello Smoluchowski Goriely stato adimensionale nodale
        n = "SMOGNAS"; sCS.(n).Modello = "Goriely SMO [nodo/adimensionale/statico]"; sCS.NCS(end+1) = sCS.(n).Modello;
    sCS.(n).TipoL = 1; % Tipo di laplaciana
    sCS.(n).NCT = 1; sCS.(n).PCT = 1; sCS.(n).TipoPeso = 1; sCS.(n).TipoMisura = 1; sCS.(n).Proc = [1 1 1e-4];
    sCS.(n).TipoM = 3; % Tipo di modello
    sCS.(n).Car1 = 200; sCS.(n).Car2 = "0.01"; sCS.(n).Car3 = "0.01";
    sCS.(n).Car4 = 0; sCS.(n).Car5 = 1; sCS.(n).Car6 = "0.001";
    sCS.(n).condDim = 0; sCS.(n).condAcc = 0; % Dipendenza dalla dimensione e dell'accumulazione dell'ultima catena
    sCS.(n).condLD = 0; sCS.(n).tipoLD = 4; % Presenza della dinamica e [nel caso] relativo tipo
    sCS.(n).condDeD = 0; sCS.(n).tipoDeD = 1; % Presenza della dinamica e [nel caso] relativo tipo
    sCS.(n).NI = "Entorhinal"; sCS.(n).CI1 = "0.001"; sCS.(n).CI2 = "1";
    sCS.(n).TipoD = 1; % Tipo di discretizzazione in tempo
    sCS.(n).Passo = 0.004; sCS.(n).T = 2e3; % Parametri temporali
    sCS.(n).nIS = 5e3; % Numero d'istanti salvati
    sCS.(n).contrTemp = 1; % Presenza della contrazione temporale
    sCS.(n).risTemp   = 0; % Presenza del riscalamento temporale

    %%%
    n = "LineaModificheDinamica"; sCS.(n).Modello = '';
    sCS.NCS(end+1) = sCS.(n).Modello; sCS.(n).direzione = 0;
    %%%

    % Modello Fisher-Kolmogorov dell'articolo dinamico dimensionale
        n = "FKDD"; sCS.(n) = sCS.("FKDS");
    sCS.(n).condLD = 1;    
    sCS.(n).Modello = "Fornari FK [dinamico/dimensionale]"; sCS.NCS(end+1) = sCS.(n).Modello;

    % Modello Eterodimero dell'articolo dinamico dimensionale
        n = "EDDD"; sCS.(n) = sCS.("EDDS");
    sCS.(n).condLD = 1;
    sCS.(n).Modello = "Fornari ED [dinamico/dimensionale]"; sCS.NCS(end+1) = sCS.(n).Modello;

    % Modello Smoluchowski Fornari dinamico dimensionale nodale
        n = "SMOFNDD"; sCS.(n) = sCS.("SMOFNDS");
    sCS.(n).condLD = 1;
    sCS.(n).Modello = "Fornari SMO [nodo/dimensionale/dinamico]"; sCS.NCS(end+1) = sCS.(n).Modello;

    % Modello Smoluchowski Fornari statico dimensionale nodale con accumulazione
        n = "SMOFNDSA"; sCS.(n) = sCS.("SMOFNDS");
    sCS.(n).condAcc = 1;
    sCS.(n).Modello = "Fornari SMO [nodo/dimensionale/statico/accumulazione]"; sCS.NCS(end+1) = sCS.(n).Modello;

    % Modello Smoluchowski Fornari statico dimensionale nodale con depurazioni eterogenee
        n = "SMOFNDSDE"; sCS.(n) = sCS.("SMOFNDS");
    sCS.(n).condDim = 1;
    sCS.(n).Modello = "Fornari SMO [nodo/dimensionale/statico/eterogeneo]"; sCS.NCS(end+1) = sCS.(n).Modello;

    % Modello Smoluchowski Fornari statico dimensionale nodale con tutte le modifiche
        n = "SMOFNDSDT"; sCS.(n) = sCS.("SMOFNDS");
    sCS.(n).condAcc = 1; sCS.(n).condDim = 1; sCS.(n).condLD = 1;
    sCS.(n).Modello = "Fornari SMO [nodo/dimensionale/complicato]"; sCS.NCS(end+1) = sCS.(n).Modello;


%% Figure principali per l'interfaccia e strutture necessarie

        % Posizione e dimensione della figura
    sF = []; % Struttura per le caratteristiche delle figure
    sF.x = 0; sF.y = 0; sF.l = 0.8; sF.a = 0.83;
    sF.P = [sF.x sF.y sF.l sF.a]; % «[left bottom width height]»

    fig = figure('Name','Interfaccia Grafica','NumberTitle','off','Units','Normalized', ...
                 'Position',sF.P,'Resize','off'); % Dà («on») o toglie («off») la possibilità di ridimensionare la figura
        movegui(fig,'center')

        global oggIG % Struttura degli oggetti grafici 
        oggIG = [];

        sT  = []; % Struttura per il testo da mostrare
        sT.Modello = "Selezione modello";
        sT.Matrice = "Selezione laplaciana";

        sT.Proc = ["Preprocessamento" "Posprocessamento"];
        sT.Pesi = ["N. di connettomi" "Tipo di peso" "Tipo di misura"];
        sT.FK = "α";
        sT.ED = ["γ" "μh" "μm" "κ"];
        sT.SMO = ["N. catene" "γ" "μ" "a" "f" "Dimensione" "Accumulazione"];

        sT.NInf = "Nodi infettabili";
        sT.CI = ["c0" "cs0" "cm0" "ka0" "c10"];

        sT.Tempo = ["Passo" "Intervallo" "Discretizzazione" "L dinamica" "μ dinamici" ...
                    "Contrazione" "Riscalamento" append(string(sCS.CSA.nIS)," istanti equispaziati salvati")];
        sT.CS = "Casi [di] studio";


        global sLSel % Struttura dedicata alle liste di selezione
        sLSel = [];

sLSel.vLaplaciana = ["Articolo" "Costruita"];

    sLSel.vNumCNT = ["418" "476"];

  sLSel.vTipoPeso = ["Connettività elettrica" ...
                     "Numero [medio] di fibre" ...
                     "Lunghezza [media] delle fibre" ...
                     "Anisotropia frazionaria"];

sLSel.vTipoMisura = ["Media" "Mediana"];

   sLSel.vPreProc = ["Singolo Peso - Somma lineare"...
                     "Singolo Peso - Massimo"...
                     "Singolo Peso - Somma pesata"...
                     "Doppio Peso - ΣFᵢ/ΣLᵢ"];

   sLSel.vPosProc = ["CDP - Costante di diffusione personalizzata" ...
                     "CDG - Costante di diffusione di Goriely" ...
                     "NSL - Normalizzazione spettrale [della matrice] L" ...
                     "Nessuna normalizzazione"];
                    %  "N1L - Normalizzazione uno [della matrice] L" ...
                    %  "NIL - Normalizzazione uniforme [della matrice] L" ...
                    %  "NGL - Normalizzazione gradale [della matrice] L" ...
                    %  "NGL+NSL" ...
                    %  "NSGA - Normalizzazione spettrale [delle matrici] G e A" ...
                    %  "NPRL - Normalizzazione per righe [della matrice] L" ...
                    %  "NPCL - Normalizzazione per colonne [della matrice] L" ...
                    %  "NPRL+NGL" ...
                    %  "NPCL+NGL" ...

   sLSel.vModelli = ["FK"  "Fisher-Kolmogorov"
                     "ED"  "Eterodimero"
                     "SMO" "Smoluchowski"];

    sLSel.vDiscrT = ["EE" "Eulero esplicito"
                     "EI" "Eulero implicito"];
    sLSel.vLTemp  = ["Misto cml" "Misto lmc" "Misto mcl" ...
                     "Iperbolica" "Esponenziale" "Guassiana"];


        sLSel.vNR = [
                     "Right Frontal - Lateral orbitofrontal"
                     "Right Frontal - Pars orbitalis"
                     "Right Frontal - Frontal pole"
                     "Right Frontal - Medial orbitofrontal"
                     "Right Frontal - Pars triangularis"
                     "Right Frontal - Pars opercularis"
                     "Right Frontal - Rostral middle frontal"
                     "Right Frontal - Superior frontal"
                     "Right Frontal - Caudal middle frontal"
                     "Right Frontal - Precentral"
                     "Right Parietal - Paracentral"
                     "Right Limbic - Rostral anterior cingulate"
                     "Right Limbic - Caudal anterior cingulate"
                     "Right Limbic - Posterior cingulate"
                     "Right Limbic - Isthmus cingulate"
                     "Right Parietal - Postcentral"
                     "Right Parietal - Supramarginal"
                     "Right Parietal - Superior parietal"
                     "Right Parietal - Inferior parietal"
                     "Right Parietal - Precuneus"
                     "Right Occipital - Cuneus"
                     "Right Occipital - Pericalcarine"
                     "Right Occipital - Lateral occipital"
                     "Right Occipital - Lingual"
                     "Right Temporal - Fusiform"
                     "Right Limbic - Parahippocampal"
                     "Right Limbic - Entorhinal"
                     "Right Temporal - Temporal pole"
                     "Right Temporal - Inferior temporal"
                     "Right Temporal - Middle temporal"
                     "Right Temporal - Bankssts"
                     "Right Temporal - Superior temporal"
                     "Right Temporal - Ttransverse temporal"
                     "Right Temporal - Insula"
                     "Right  Basal Ganglia - Right-Thalamus-Proper"
                     "Right Basal Ganglia - Right-Caudate"
                     "Right Basal Ganglia - Right-Putamen"
                     "Right Basal Ganglia - Right-Pallidum"
                     "Right Basal Ganglia - Right-Accumbens-Area"
                     "Right Temporal - Right-Hippocampus"
                     "Right Basal Ganglia - Right-Amygdala"
                     "Left Frontal - Lateral orbitofrontal"
                     "Left Frontal - Pars orbitalis"
                     "Left Frontal - Frontal pole"
                     "Left Frontal - Medial orbitofrontal"
                     "Left Frontal - Pars triangularis"
                     "Left Frontal - Pars opercularis"
                     "Left Frontal - Rostral middle frontal"
                     "Left Frontal - Superior frontal"
                     "Left Frontal - Caudal middle frontal"
                     "Left Frontal - Precentral"
                     "Left Parietal - Paracentral"
                     "Left Limbic - Rostral anterior cingulate"
                     "Left Limbic - Caudal anterior cingulate"
                     "Left Limbic - Posterior cingulate"
                     "Left Limbic - Isthmus cingulate"
                     "Left Parietal - Postcentral"
                     "Left Parietal - Supramarginal"
                     "Left Parietal - Superior parietal"
                     "Left Parietal - Inferior parietal"
                     "Left Parietal - Precuneus"
                     "Left Occipital - Cuneus"
                     "Left Occipital - Pericalcarine"
                     "Left Occipital - Lateral occipital"
                     "Left Occipital - Lingual"
                     "Left Temporal - Fusiform"
                     "Left Limbic - Parahippocampal"
                     "Left Limbic - Entorhinal"
                     "Left Temporal - Temporal pole"
                     "Left Temporal - Inferior temporal"
                     "Left Temporal - Middle temporal"
                     "Left Temporal - Bankssts"
                     "Left Temporal - Superior temporal"
                     "Left Temporal - Transverse temporal"
                     "Left Temporal - Insula"
                     "Left Basal Ganglia - Left-Thalamus-Proper"
                     "Left Basal Ganglia - Left-Caudate"
                     "Left Basal Ganglia - Left-Putamen"
                     "Left Basal Ganglia - Left-Pallidum"
                     "Left Basal Ganglia - Left-Accumbens-Area"
                     "Left Temporal - Left-Hippocampus"
                     "Left Basal Ganglia - Left-Amygdala"
                     "Brainstem"
                     ];
        
                    % "Frontal" ...
                    % "Parietal" ...
                    % "Limbic" ...
                    % "Occipital" ...
                    % "Temporal" ...
                    % "Basal Ganglia" ...
                    % "Brain Stem" ...
                    % "Entorhinal"


%% Grafo celebrale

    sF.l = 0.5; sF.a = 0.74;
    sF.x = 0.05; sF.y = 1-0.02-sF.a;
    sF.P = [sF.x sF.y sF.l sF.a];

    tiledlayout(1,1,"TileSpacing","compact","Padding","compact",'Position',sF.P); nexttile;
    global sPNI % Struttura dei punti dei nodi infetti
    f = @(src,event,indice) FRCliccoNodiInfetti(src,event,indice);
    [sPNI,~] = Cervello3D(f);

    sO = []; % Struttura delle dimensioni dell'oggetto
    sO.sep = 0.005;
    sO.l = .075;            % «[width]»
    sO.a = .04;             % «[height]»
    sO.y = .02;             % «[bottom]»
    sO.x = 0;               % «[left]
    sO.dimT = 10;           % Dimensione testo
    sO.staccoT = 0.03;      % Stacco inferiore tra testo statico e dinamico

    sO.P = [sO.x sO.y+sO.staccoT sO.l sO.a];
    uicontrol('Style','text','FontSize',sO.dimT,'String','Azimuto:','Visible','on','Enable','on', ...
              'HorizontalAlignment','right','Units','Normalized','Position',sO.P);
    sO.P = [sO.x sO.y sO.l sO.a];
    uicontrol('Style','text','FontSize',sO.dimT,'String','Elevazione:','Visible','on','Enable','on', ...
              'HorizontalAlignment','right','Units','Normalized','Position',sO.P);

    sO.x = sO.x+sO.l+sO.sep;
    sO.P = [sO.x sO.y+sO.staccoT sO.l sO.a];
    tAz = uicontrol('Style','text','FontSize',sO.dimT,'String','0°','Visible','on','Enable','on', ...
                    'HorizontalAlignment','left','Units','Normalized','Position',sO.P);
    est = get(tAz,'Extent'); est(3) = est(3)+0.01; tAz.Position(3) = est(3);
    sO.P = [sO.x sO.y sO.l sO.a];
    tEl = uicontrol('Style','text','FontSize',sO.dimT,'String','0°','Visible','on','Enable','on', ...
                    'HorizontalAlignment','left','Units','Normalized','Position',sO.P);
    est = get(tEl,'Extent'); est(3) = est(3)+0.01; tEl.Position(3) = est(3);

    sO.x = sO.x+est(3)+sO.sep; sO.y = sO.y+0.015; sO.a = sO.a-0.01;
    sO.P = [sO.x sO.y+sO.staccoT sO.l sO.a];
    azCursore = uicontrol('Style','slider','Min',0,'Max',360,'Value',str2double(strrep(tAz.String,'°','')),'Visible','on', ...
                          'Enable','on','Units','Normalized','Position',sO.P,'Callback',@FRCursoreAzimuto);
        oggIG.azCursore = azCursore;
    sO.P = [sO.x sO.y sO.l sO.a];
    elCursore = uicontrol('Style','slider','Min',-90,'Max',90,'Value',str2double(strrep(tEl.String,'°','')),'Visible','on', ...
                          'Enable','on','Units','Normalized','Position',sO.P,'Callback',@FRCursoreElevazione);
        oggIG.elCursore = elCursore;

    sO.x = sO.x+sO.l+sO.sep; sO.l = sO.l/2.75;
    sO.P = [sO.x sO.y+sO.staccoT sO.l sO.a];
    dAz = uicontrol('Style','edit','string','0°','Visible','on', ...
                    'Enable','on','Units','Normalized','Position',sO.P);
        oggIG.Az = [dAz tAz];
    sO.P = [sO.x sO.y sO.l sO.a];
    dEl = uicontrol('Style','edit','string','0°','Visible','on', ...
                    'Enable','on','Units','Normalized','Position',sO.P);
        oggIG.El = [dEl tEl];

    sO.x = sO.x+sO.l+sO.sep; sO.l = 0.05; sO.a = 0.045;
    sO.y = sO.y+sO.staccoT-sO.a/2;
    sO.P = [sO.x sO.y sO.l sO.a];
    bIV = uicontrol('Style','pushbutton','string','Imposta','Visible','on', ...
                    'Enable','on','Units','Normalized','Position',sO.P,...
                    'Callback',@FRImpostaVista);
        oggIG.BottIV = bIV;

    % t = timer('ExecutionMode','fixedRate','Period', 0.1,'TimerFcn', @(src,event)SeguiVista(src,event,p));
    % start(t);


%% Oggetti grafici interattivi

        %%% Laplaciana %%%
    rigRif = [0.9 linspace(0.775,0.35,6)]; % «[bottom]»
    colRif = linspace(0.65,0.9,3);  % Ascisse delle colonne di riferimento

    sO = []; % Struttura delle dimensioni dell'oggetto
    sO.x = colRif(1);       % «[left]
    sO.r = 2;               % Riga iniziale
    sO.y = rigRif(sO.r);    % «[bottom]»
    sO.l = .075;            % «[width]»
    sO.a = .04;             % «[height]»
    sO.dimT = 10;           % Dimensione testo
    sO.staccoT = 0.025;      % Stacco inferiore tra testo statico e dinamico


    sO.P = [sO.x-sO.l/2 sO.y+sO.staccoT sO.l sO.a];
    tNumCNT = uicontrol('Style','text','Visible','on','Enable','on','String',sT.Pesi(1), ...
                        'Units','Normalized','FontSize',sO.dimT,'Position',sO.P);
    sO.P = [sO.x-sO.l/2 sO.y sO.l sO.a];
    dNumCNT = uicontrol('Style','popupmenu','Visible','on','Enable','on','String',sLSel.vNumCNT,...
                         'Value',1,'FontSize',sO.dimT,'Units','Normalized','Position',sO.P);    
        oggIG.NumCNT = [dNumCNT tNumCNT];

    minMax = [0 100]; rid = 0.02;
    sO.l = sO.l - sO.l/2;
    sO.r = sO.r + 1; sO.y = rigRif(sO.r);
    sO.P = [sO.x-sO.l sO.y-0.01 sO.l+rid sO.a];
    tCursore = uicontrol('Style','text','Visible','on','Enable','on','String','% Connettomi', ...
                         'Units','Normalized','Position',sO.P);
    sO.P = [sO.x+rid sO.y sO.l-rid sO.a];
    dCursore = uicontrol('Style','edit','Visible','on','Enable','on','String',string(sCS.CSA.PCT), ...
                         'Units','Normalized','Position',sO.P,'Callback',{@FRCursoreT,minMax});
    sO.l = sO.l*2;
    sO.P = [sO.x-sO.l/2 sO.y+sO.staccoT+0.015 sO.l sO.a-0.01];
    cCursore = uicontrol('Style','slider','Min',minMax(1),'Max',minMax(2),'Value',str2double(dCursore.String),'Visible','on', ...
                         'Enable','on','Units','Normalized','Position',sO.P,'Callback',@FRCursoreD);
        oggIG.Cursore = [cCursore dCursore tCursore];

    sO.r = sO.r + 1; sO.y = rigRif(sO.r);
    sO.P = [sO.x-sO.l/2 sO.y+sO.staccoT sO.l sO.a];
    tTipoPeso = uicontrol('Style','text','Visible','on','Enable','on','String',sT.Pesi(2),'FontSize',sO.dimT, ...
                         'Units','Normalized','Position',sO.P);
    sO.P = [sO.x-sO.l/2 sO.y sO.l sO.a];
    dTipoPeso = uicontrol('Style','popupmenu','Visible','on','Enable','on','String',sLSel.vTipoPeso,...
                         'Value',sCS.CSA.TipoPeso,'FontSize',sO.dimT,'Units','Normalized','Position',sO.P);    
        oggIG.TipoPeso = [dTipoPeso tTipoPeso];

    sO.r = sO.r + 1; sO.y = rigRif(sO.r);
    sO.P = [sO.x-sO.l/2 sO.y+sO.staccoT sO.l sO.a];
    tTipoMisura = uicontrol('Style','text','Visible','on','Enable','on','String',sT.Pesi(3),'FontSize',sO.dimT, ...
                            'Units','Normalized','Position',sO.P);
    sO.P = [sO.x-sO.l/2 sO.y sO.l sO.a];
    dTipoMisura = uicontrol('Style','popupmenu','Visible','on','Enable','on','String',sLSel.vTipoMisura,...
                            'Value',sCS.CSA.TipoMisura,'FontSize',sO.dimT,'Units','Normalized','Position',sO.P);    
        oggIG.TipoMisura = [dTipoMisura tTipoMisura];

    sO.r = sO.r + 1; sO.y = rigRif(sO.r);
    sO.P = [sO.x-sO.l/2 sO.y+sO.staccoT sO.l sO.a];
    tPreProc = uicontrol('Style','text','Visible','on','Enable','on','String',sT.Proc(1),'FontSize',sO.dimT, ...
                         'Units','Normalized','Position',sO.P);
    est = get(tPreProc,'Extent'); tPreProc.Position(3) = est(3); tPreProc.Position(1) = sO.x-est(3)/2;
    sO.P = [sO.x-sO.l/2 sO.y sO.l sO.a];
    dPreProc = uicontrol('Style','popupmenu','Visible','on','Enable','on','String',sLSel.vPreProc,'Value',sCS.CSA.Proc(1), ...
                         'FontSize',sO.dimT,'Units','Normalized','Position',sO.P,'Callback',@FRSingoloDoppioPeso);
        oggIG.PreProc = [dPreProc tPreProc];

    sO.r = sO.r + 1; sO.y = rigRif(sO.r);
    sO.P = [sO.x-sO.l/2 sO.y+sO.staccoT sO.l sO.a];
    tPosProc = uicontrol('Style','text','Visible','on','Enable','on','String',sT.Proc(2),'FontSize',sO.dimT, ...
                         'Units','Normalized','Position',sO.P);
    est = get(tPosProc,'Extent'); tPosProc.Position(3) = est(3); tPosProc.Position(1) = sO.x-est(3)/2;
    sO.P = [sO.x-sO.l/2 sO.y sO.l sO.a];
    dPosProc = uicontrol('Style','popupmenu','Visible','on','Enable','on','String',sLSel.vPosProc, ...
                         'Value',sCS.CSA.Proc(2),'FontSize',sO.dimT,'Units','Normalized','Position',sO.P,...
                         'Callback',@FRCDPersonalizzata);
        oggIG.PosProc = [dPosProc tPosProc];
    sO.a = sO.a-0.01; sO.y = sO.y-sO.a;
    sO.P = [sO.x-sO.l/2 sO.y sO.l sO.a];
    dCDP = uicontrol('Style','edit','Visible','on','Enable','on','String',sCS.CSA.Proc(3), ...
                     'FontSize',sO.dimT,'Units','Normalized','Position',sO.P);    
        oggIG.CDP = dCDP;
    FRCDPersonalizzata(oggIG.PosProc(1),[])

    sO.r = 1; sO.y = rigRif(sO.r); sO.a = sO.a+0.01;
    sO.P = [sO.x-sO.l/2 sO.y+sO.staccoT sO.l sO.a];
    tSelMatr = uicontrol('Style','text','String',sT.Matrice,'Visible','on','Enable','on','FontSize',sO.dimT, ...
                         'Units','Normalized','Position',sO.P);
    est = get(tSelMatr,'Extent'); tSelMatr.Position(3) = est(3); tSelMatr.Position(1) = sO.x-est(3)/2;
       sO.P = [sO.x-sO.l/2 sO.y sO.l sO.a];
    dSelMatr = uicontrol('Style','popupmenu','Visible','on','Enable','on','String',sLSel.vLaplaciana,...
                         'Value',sCS.CSA.TipoL,'Units','Normalized','Position',sO.P, ...
                         'CallBack',@FRSelezioneMatrice,'FontSize',sO.dimT);
        oggIG.SelMatr = [dSelMatr tSelMatr];
        FRSelezioneMatrice(dSelMatr,[])
        if(oggIG.SelMatr(1).Value == 2)
            FRSingoloDoppioPeso(dPreProc,[])
        end


       %%% Parametri dei modelli %%%
    sO.c    = 2;   % Colonna
    sO.x = colRif(2); % «[left]
    sO.r    = 2;   % Riga iniziale
    sO.y = rigRif(sO.r); % «[bottom]»
    sO.l = .075; % «[width]»
    sO.a = .04; % «[height]»
    sO.dimT    = 10;   % Dimensione testo
    sO.staccoT = 0.025; % Stacco inferiore tra testo statico e dinamico


    sO.P = [sO.x-sO.l/2 sO.y+sO.staccoT+0.025 sO.l sO.a];
    tst = uicontrol('Style','text','FontSize',sO.dimT,'String','Parametri','Visible','on','Enable','on', ...
                    'Units','Normalized','Position',sO.P);
    est = get(tst,'Extent'); tst.Position(3) = est(3); tst.Position(1) = sO.x-est(3)/2;

    sO.P = [sO.x-sO.l/2 sO.y+sO.staccoT sO.l sO.a];
    tCar1 = uicontrol('Style','text','FontSize',sO.dimT,'String',sT.SMO(1),'Visible','on','Enable','on', ...
                      'Units','Normalized','Position',sO.P);
    sO.P = [sO.x-sO.l/2 sO.y sO.l sO.a];
    dCar1 = uicontrol('Style','edit','Visible','on','Enable','on','String',sCS.CSA.Car1,...
                      'Units','Normalized','Position',sO.P,'Callback',@FRCursoreIstantiSalvati);    
        oggIG.Car1 = [dCar1 tCar1];

    sO.r = sO.r + 1; sO.y = rigRif(sO.r);
    sO.P = [sO.x-sO.l/2 sO.y+sO.staccoT sO.l sO.a];
    tCar2 = uicontrol('Style','text','FontSize',sO.dimT,'String',sT.SMO(2),'Visible','on','Enable','on', ...
                      'Units','Normalized','Position',sO.P);
    sO.P = [sO.x-sO.l/2 sO.y sO.l sO.a];
    dCar2 = uicontrol('Style','edit','Visible','on','Enable','on','String',sCS.CSA.Car2,...
                      'Units','Normalized','Position',sO.P);    
        oggIG.Car2 = [dCar2 tCar2];

    sO.r = sO.r + 1; sO.y = rigRif(sO.r);
    sO.P = [sO.x-sO.l/2 sO.y+sO.staccoT sO.l sO.a];
    tCar3 = uicontrol('Style','text','FontSize',sO.dimT,'String',sT.SMO(3),'Visible','on','Enable','on', ...
                      'Units','Normalized','Position',sO.P);
    sO.P = [sO.x-sO.l/2 sO.y sO.l sO.a];
    dCar3 = uicontrol('Style','edit','Visible','on','Enable','on','String',sCS.CSA.Car3,...
                      'Units','Normalized','Position',sO.P);    
        oggIG.Car3 = [dCar3 tCar3];

    sO.r = sO.r + 1; sO.y = rigRif(sO.r);
    sO.P = [sO.x-sO.l/2 sO.y+sO.staccoT sO.l sO.a];
    tCar4 = uicontrol('Style','text','FontSize',sO.dimT,'String',sT.SMO(4),'Visible','off','Enable','on', ...
                      'Units','Normalized','Position',sO.P);
    sO.P = [sO.x-sO.l/2 sO.y sO.l sO.a];
    dCar4 = uicontrol('Style','edit','Visible','off','Enable','on','String',sCS.CSA.Car4,...
                      'Units','Normalized','Position',sO.P);
        oggIG.Car4 = [dCar4 tCar4];

    sO.P(1) = sO.P(1); sO.P(2) = sO.P(2)+sO.staccoT+0.005; sO.P(4) = sO.P(4)*.75;
    dCAcc = uicontrol('Style','checkbox','Visible','on','Enable','on','Value',sCS.CSA.condAcc, ...
                      'FontSize',sO.dimT,'String',sT.SMO(7),'Units','Normalized','Position',sO.P);
    est = get(dCAcc,'Extent'); dCAcc.Position(3) = est(3)+0.0115; dCAcc.Position(1) = sO.x-est(3)/2-0.005;
        oggIG.CAcc = dCAcc;

    sO.P(2) = sO.P(2)-sO.staccoT-0.006;
    dCDim = uicontrol('Style','checkbox','Visible','on','Enable','on','Value',sCS.CSA.condDim, ...
                      'FontSize',sO.dimT,'String',sT.SMO(6),'Units','Normalized','Position',sO.P);
    est = get(dCDim,'Extent'); dCDim.Position(3) = est(3)+0.0115; dCDim.Position(1) = sO.x-est(3)/2-0.005;
        oggIG.CDim = dCDim;

    sO.r = sO.r + 1; sO.y = rigRif(sO.r);
    sO.P = [sO.x-sO.l/2 sO.y+sO.staccoT sO.l sO.a];
    tCar5 = uicontrol('Style','text','FontSize',sO.dimT,'String',sT.SMO(4),'Visible','on','Enable','on', ...
                      'Units','Normalized','Position',sO.P);
    sO.P = [sO.x-sO.l/2 sO.y sO.l sO.a];
    dCar5 = uicontrol('Style','edit','Visible','on','Enable','on','String',sCS.CSA.Car5,...
                      'Units','Normalized','Position',sO.P);    
        oggIG.Car5 = [dCar5 tCar5];

    sO.r = sO.r + 1; sO.y = rigRif(sO.r);
    sO.P = [sO.x-sO.l/2 sO.y+sO.staccoT sO.l sO.a];
    tCar6 = uicontrol('Style','text','FontSize',sO.dimT,'String',sT.SMO(5),'Visible','on','Enable','on', ...
                      'Units','Normalized','Position',sO.P);
    sO.P = [sO.x-sO.l/2 sO.y sO.l sO.a];
    dCar6 = uicontrol('Style','edit','Visible','on','Enable','on','String',sCS.CSA.Car6, ...
                      'Units','Normalized','Position',sO.P);
        oggIG.Car6 = [dCar6 tCar6];

    sO.r = 1; sO.y = rigRif(sO.r);
    sO.x = (sO.x+colRif(sO.c+1))/2;
    sO.P = [sO.x-sO.l/2 sO.y+sO.staccoT sO.l sO.a];
    tSelMod = uicontrol('Style','text','String',sT.Modello,'FontSize',sO.dimT,'Visible','on','Enable','on', ...
                      'Units','Normalized','Position',sO.P);
    est = get(tSelMod,'Extent'); tSelMod.Position(3) = est(3); tSelMod.Position(1) = sO.x-est(3)/2;
    sO.P = [sO.x-sO.l/2 sO.y sO.l sO.a];
    dSelMod = uicontrol('Style','popupmenu','Visible','on','Enable','on','String',sLSel.vModelli(:,2),...
                        'Units','Normalized','Position',sO.P,'FontSize',sO.dimT, ...
                        'Value',sCS.CSA.TipoM,'CallBack',{@FRVisibilitaCaratteristiche,sT});
        oggIG.SelMod = [dSelMod tSelMod];


        %%% Condizioni iniziali %%%
    sO.x = colRif(3); % «[left]
    sO.r    = 2;   % Riga iniziale
    sO.y = rigRif(sO.r); % «[bottom]»
    sO.l = .075; % «[width]»
    sO.a = .04; % «[height]»
    sO.dimT    = 10;   % Dimensione testo
    sO.staccoT = 0.03; % Stacco inferiore tra testo statico e dinamico

    sO.P = [sO.x-sO.l/2 sO.y+sO.staccoT+0.025 sO.l sO.a];
    tst = uicontrol('Style','text','FontSize',sO.dimT,'String','Condizioni iniziali','Visible','on','Enable','on', ...
                    'Units','Normalized','Position',sO.P);
    est = get(tst,'Extent'); tst.Position(3) = est(3); tst.Position(1) = sO.x-est(3)/2;

    sO.y = rigRif(sO.r);
    sO.P = [sO.x-sO.l/2 sO.y+sO.staccoT sO.l sO.a];
    tNInf = uicontrol('Style','text','FontSize',sO.dimT,'String',sT.NInf,'Visible','on','Enable','on', ...
                      'Units','Normalized','Position',sO.P);
    r = 5.5; sO.y = sO.y-sO.a*(r-1); sO.a = sO.a*r; % Modifica r per allunga la lista
    l = 0.05; sO.l = sO.l + l;
    sO.P = [sO.x-sO.l/2 sO.y sO.l sO.a];
    dNInf = uicontrol('Style','listbox','FontSize',sO.dimT,'Visible','on','Enable','on','String',sLSel.vNR,...
                      'Max',sLSel.vNR.length,'Min',0,'Units','Normalized','Position',sO.P,...
                      'Value',[],'Callback',@FRListaNodiInfetti);    
        oggIG.NInf = [dNInf tNInf];

    sO.r = sO.r+3;
    sO.y = rigRif(sO.r)+0.035; sO.a = sO.a/r;
    sO.P = [sO.x-sO.l/2 sO.y sO.l sO.a];
    dTrovaNI = uicontrol('Style','edit','Visible','on','Enable','on','String',sCS.CSA.NI,...
                         'FontSize',sO.dimT,'Units','Normalized','Position',sO.P);    
        oggIG.TrovaNI = dTrovaNI;

    sO.l = sO.l/2; sO.y = sO.y-sO.a;
    sO.P = [sO.x-sO.l sO.y sO.l sO.a];
    bTrova = uicontrol('Style','pushbutton','string','Trova','Visible','on','Enable','on', ...
                       'Units','Normalized','Position',sO.P,'Callback',@FRTrovaNI);
        oggIG.BottTrova = bTrova;
    sO.P = [sO.x sO.y sO.l sO.a];
    bReset = uicontrol('Style','pushbutton','string','Resetta','Visible','on','Enable','on', ...
                       'Units','Normalized','Position',sO.P,'Callback',@FRResettaNI);
        oggIG.BottReset = bReset;

    FRTrovaNI([],[]) % Funzione per impostare i nodi infetti del caso di studio all'avvio

    sO.x = colRif(3);
    sO.l = sO.l*2-l; sO.r = sO.r + 1; sO.y = rigRif(sO.r);
    sO.P = [sO.x-sO.l/2 sO.y+sO.staccoT sO.l sO.a];
    tCI1 = uicontrol('Style','text','FontSize',sO.dimT,'String',sT.CI(1),'Visible','on','Enable','on', ...
                      'Units','Normalized','Position',sO.P);
    sO.P = [sO.x-sO.l/2 sO.y sO.l sO.a];
    dCI1 = uicontrol('Style','edit','Visible','on','Enable','on','String',sCS.CSA.CI1,...
                      'Units','Normalized','Position',sO.P);    
        oggIG.CI1 = [dCI1 tCI1];

    sO.r = sO.r + 1; sO.y = rigRif(sO.r);
    sO.P = [sO.x-sO.l/2 sO.y+sO.staccoT sO.l sO.a];
    tCI2 = uicontrol('Style','text','FontSize',sO.dimT,'String',sT.CI(2),'Visible','off','Enable','on', ...
                      'Units','Normalized','Position',sO.P);
    sO.P = [sO.x-sO.l/2 sO.y sO.l sO.a];
    dCI2 = uicontrol('Style','edit','Visible','off','Enable','on','String',sCS.CSA.CI2,...
                      'Units','Normalized','Position',sO.P);    
        oggIG.CI2 = [dCI2 tCI2];


       %%% Parametri temporali %%%
    sO.y = rigRif(end)-0.12;

    sO.x = colRif(2);
    sO.P = [sO.x-sO.l/2 sO.y+2*sO.staccoT sO.l sO.a];
    tst = uicontrol('Style','text','FontSize',sO.dimT,'String','Parametri temporali','Visible','on','Enable','on', ...
                        'Units','Normalized','Position',sO.P);
    est = get(tst,'Extent'); tst.Position(3) = est(3); tst.Position(1) = sO.x-est(3)/2;

    sO.x = colRif(1);
    sO.P = [sO.x-sO.l/2 sO.y+sO.staccoT sO.l sO.a];
    tPassoT = uicontrol('Style','text','FontSize',sO.dimT,'String',sT.Tempo(1),'Visible','on','Enable','on', ...
                        'Units','Normalized','Position',sO.P);
    sO.P = [sO.x-sO.l/2 sO.y sO.l sO.a];
    dPassoT = uicontrol('Style','edit','Visible','on','Enable','on','String',sCS.CSA.Passo,...
                        'Units','Normalized','Position',sO.P,'Callback',@FRCursoreIstantiSalvati);    
        oggIG.PassoT = [dPassoT tPassoT];

    sO.x = colRif(2);
    sO.P = [sO.x-sO.l/2 sO.y+sO.staccoT sO.l sO.a];
    tPeriodoT = uicontrol('Style','text','FontSize',sO.dimT,'String',sT.Tempo(2),'Visible','on','Enable','on', ...
                          'Units','Normalized','Position',sO.P);
    sO.P = [sO.x-sO.l/2 sO.y sO.l sO.a];
    dPeriodoT = uicontrol('Style','edit','Visible','on','Enable','on','String',sCS.CSA.T,...
                          'Units','Normalized','Position',sO.P,'Callback',@FRCursoreIstantiSalvati);
        oggIG.PeriodoT = [dPeriodoT tPeriodoT];

    sO.x = colRif(3);
    sO.P = [sO.x-sO.l/2 sO.y+sO.staccoT sO.l sO.a];
    tDiscrT = uicontrol('Style','text','FontSize',sO.dimT,'String',sT.Tempo(3),'Visible','on','Enable','on', ...
                          'Units','Normalized','Position',sO.P);
    sO.P = [sO.x-sO.l/2 sO.y sO.l sO.a];
    dDiscrT = uicontrol('Style','popupmenu','Visible','on','Enable','on','String',sLSel.vDiscrT(:,2),...
                        'Value',sCS.CSA.TipoD,'FontSize',sO.dimT,'Units','Normalized','Position',sO.P);    
        oggIG.DiscrT = [dDiscrT tDiscrT];

    sO.y = sO.y-0.085;

    sO.x = (colRif(1)+colRif(2))/2;
    sO.P = [sO.x-sO.l/2 sO.y sO.l sO.a*.9];
    dLTemp = uicontrol('Style','popupmenu','Visible','on','Enable','on','String',sLSel.vLTemp,...
                        'Value',sCS.CSA.tipoLD,'FontSize',sO.dimT,'Units','Normalized','Position',sO.P);    
    sO.P = [sO.x-sO.l/2 sO.y+sO.staccoT+0.0075 sO.l sO.a];
    cLTemp = uicontrol('Style','checkbox','Visible','on','Enable','on','Value',sCS.CSA.condLD,'FontSize',sO.dimT,...
                       'String',sT.Tempo(4),'Units','Normalized','Position',sO.P,'Callback',{@FRAttivaDinamica,dLTemp});
    est = get(cLTemp,'Extent'); cLTemp.Position(3) = est(3)+0.0115; cLTemp.Position(1) = sO.x-est(3)/2-0.005;
        oggIG.LTemp = [dLTemp cLTemp];

    sO.x = (colRif(2)+colRif(3))/2;
    sO.P = [sO.x-sO.l/2 sO.y sO.l sO.a*.9];
    dDeTemp = uicontrol('Style','popupmenu','Visible','off','Enable','on','String',sLSel.vLTemp(1:3),...
                        'Value',sCS.CSA.tipoDeD,'FontSize',sO.dimT,'Units','Normalized','Position',sO.P);    
    sO.P = [sO.x-sO.l/2 sO.y+sO.staccoT+0.0075 sO.l sO.a];
    cDeTemp = uicontrol('Style','checkbox','Visible','on','Enable','on','Value',sCS.CSA.condDeD,'FontSize',sO.dimT,...
                       'String',sT.Tempo(5),'Units','Normalized','Position',sO.P,'Callback',{@FRAttivaDinamica,dDeTemp});
    est = get(cDeTemp,'Extent'); cDeTemp.Position(3) = est(3)+0.0115; cDeTemp.Position(1) = sO.x-est(3)/2-0.006;
        oggIG.DeTemp = [dDeTemp cDeTemp];
        
        FRAttivaDinamica(oggIG.LTemp(2),[],oggIG.LTemp(1))
        FRAttivaDinamica(oggIG.DeTemp(2),[],oggIG.DeTemp(1))

    sO.y = sO.y-0.075;
    sO.a = 0.03;
    sO.l = 0.15;
    sO.x = colRif(2);
    sO.staccoT = 0.04;

    sO.P = [sO.x-sO.l/2 sO.y+sO.staccoT sO.l sO.a];
    tIS = uicontrol('Style','text','FontSize',sO.dimT,'String',sT.Tempo(8),'Visible','on','Enable','on', ...
                    'HorizontalAlignment','left','Units','Normalized','Position',sO.P);
    est = get(tIS,'Extent'); tIS.Position(3) = est(3); tIS.Position(1) = sO.x-est(3)/2;

    sO.P = [sO.x-sO.l/2 sO.y sO.l sO.a];
    cIS = uicontrol('Style','slider','Min',1,'Max',sCS.CSA.nIS,'Value',sCS.CSA.nIS,'Visible','on', ...
                    'Enable','on','Units','Normalized','Position',sO.P,'Callback',@FRCursoreIstantiSalvati);
        oggIG.IS = [tIS cIS];

    sO.sep = 0.01;

    % sO.P = [sO.x-sO.l-sO.sep sO.y-sO.staccoT sO.l sO.a];
    sO.P = [sO.x-sO.l/2 sO.y-sO.staccoT sO.l sO.a];
    cContrTemp = uicontrol('Style','checkbox','Visible','on','Enable','on','Value',sCS.CSA.contrTemp, ...
                         'FontSize',sO.dimT,'String',sT.Tempo(6),'Units','Normalized','Position',sO.P);
    est = get(cContrTemp,'Extent');
    cContrTemp.Position(3) = est(3)+0.0115;
    % cContrTemp.Position(1) = sO.x-est(3)-sO.sep-0.006;
    cContrTemp.Position(1) = sO.x-est(3)/2-0.006;
        oggIG.ContrTemp = cContrTemp;

    sO.P = [sO.x+sO.sep sO.y-sO.staccoT sO.l sO.a];
    cRisTemp = uicontrol('Style','checkbox','Visible','off','Enable','on','Value',sCS.CSA.risTemp, ...
                         'FontSize',sO.dimT,'String',sT.Tempo(7),'Units','Normalized','Position',sO.P);
    est = get(cRisTemp,'Extent');
    cRisTemp.Position(3) = est(3)+0.0115;
    cRisTemp.Position(1) = sO.x+sO.sep-0.006;
        oggIG.RisTemp = cRisTemp;

    FRCursoreIstantiSalvati([],[])
    FRVisibilitaCaratteristiche(dSelMod,[],sT)


%% Tasti d'interazione

        % Parametri
    colRif = linspace(0.39,0.61,3);
    sO.x = colRif(2); % «[left]
    sO.r    = 2;   % Riga iniziale
    sO.y = 0.02; % «[bottom]»
    sO.l = 0.1; % «[width]»
    sO.a = 0.085; % «[height]»
    sO.dimT    = 12;   % Dimensione testo
    sO.staccoT = 0.03; % Stacco inferiore tra testo statico e dinamico

        %%% Riavvio
    sO.P = [sO.x-sO.l/2 sO.y sO.l sO.a];
    RiAvvioBott = uicontrol('Style','pushbutton','Enable','off','FontSize',sO.dimT,'String','Riavvia', ...
                            'Units','Normalized','Position',sO.P,'CallBack',@RiAvvio);

        %%% Avvio
    sO.x = colRif(1);
    sO.P = [sO.x-sO.l/2 sO.y sO.l sO.a];
    uicontrol('Style','pushbutton','Enable','on','FontSize',sO.dimT,'String','Avvia', ...
              'Units','Normalized','Position',sO.P,'CallBack',{@Avvio, RiAvvioBott});

        %%% Esci
    sO.x = colRif(3);
    sO.P = [sO.x-sO.l/2 sO.y sO.l sO.a];
    uicontrol('Style','pushbutton','FontSize',sO.dimT,'String','Esci', ...
              'Units','Normalized','Position',sO.P,'CallBack',@Esci);

        %%% Selezione dei casi di studio
    sO.x = colRif(2); sO.y = sO.y + 0.055; sO.dimT = 10;
    sO.P = [sO.x-sO.l/2 sO.y+sO.staccoT sO.l sO.a]; % «[left bottom width height]»
    uicontrol('Style','text','Visible','on','Enable','on','String',sT.CS, ...
              'FontSize',sO.dimT,'Units','Normalized','Position',sO.P);
    sO.P = [sO.x-sO.l/2 sO.y sO.l sO.a];
    dCS = uicontrol('Style','popupmenu','Visible','on','Enable','on','FontSize',sO.dimT,'String',sCS.NCS(:), ...
                    'Units','Normalized','Position',sO.P,'CallBack',{@FRCasiStudio,sT});
        oggIG.CS = dCS;


    % Ciclo «while» per fermare il programma finché il bottone «AvvioBott» non è stato premuto
    while(avvia == 0 && termina == 0)
        pause(0.01) % Pausa di 0.01 secondi: necessaria per dare respiro a Matlab, altrimenti neanche genera la figura precedente
    end


%% Traduzione delle stringhe inserite in tutte i dati necessari alla simulazione

        sPL = []; % Struttura dei parametri della laplaciana
    sPL.TipoL = oggIG.SelMatr(1).Value;
    if(sPL.TipoL == 2) % Matrice costruita

        sPL.PCT  = str2double(oggIG.Cursore(2).String);
        sPL.PreProc = oggIG.PreProc(1).Value; % Preprocessamento 

            %%% Costruzione del percoso
        if(sPL.PreProc<4) % Singolo peso

            switch oggIG.NumCNT(1).Value
                case 1 % 418 Connettomi
                    percorso = "../Dati/BCT3_418";
                case 2 % 476 Connettomi
                    percorso = "../Dati/BCT3_476";
            end
            switch oggIG.TipoPeso(1).Value
                case 1 % «ElecticalConnectivity»
                    percorso = append(percorso,"_ElecticalConnectivity");
                case 2 % «FiberCount»
                    percorso = append(percorso,"_FiberCount");
                case 3 % «FiberLength»
                    percorso = append(percorso,"_FiberLength");
                case 4 % «FractionalAnisotropy»
                    percorso = append(percorso,"_FractionalAnisotropy");
            end
            switch oggIG.TipoMisura(1).Value
                case 1 % «Mean»
                    percorso = append(percorso,"_mean.csv");
                case 2 % «Median»
                    percorso = append(percorso,"_median.csv");
            end
            sPL.percorso = percorso;

        else  % Doppio peso

            percorso = string(zeros(2,1));
            switch oggIG.NumCNT(1).Value
                case 1 % 418 Connettomi
                    percorso(1) = "../Dati/BCT3_418";
                    percorso(2) = "../Dati/BCT3_418";
                case 2 % 476 Connettomi
                    percorso(1) = "../Dati/BCT3_476";
                    percorso(2) = "../Dati/BCT3_476";
            end
            percorso(1) = append(percorso(1),"_FiberCount");
            percorso(2) = append(percorso(2),"_FiberLength");
            switch oggIG.TipoMisura(1).Value
                case 1 % «Mean»
                    percorso(1) = append(percorso(1),"_mean.csv");
                    percorso(2) = append(percorso(2),"_mean.csv");
                case 2 % «Median»
                    percorso(1) = append(percorso(1),"_median.csv");
                    percorso(2) = append(percorso(2),"_median.csv");
            end
            sPL.percorso = percorso;

        end

    else % Altrimenti la matrice è dell'articolo e quindi si danno dati vuoti

        sPL.PuntiReg = sLSel.vNR;
        sPL.percorso = "";
        sPL.PreProc = "";
        sPL.PCT      = "";

    end

    sPL.PosProc = oggIG.PosProc(1).Value; % Posprocessamento
    switch sLSel.vPosProc(sPL.PosProc)
        case "CDG - Costante di diffusione di Goriely"
            sPL.CD = 2*10^(-5); % Costante di diffusione (v. prospetto a p. 12 della filza «Goriely 2019 II {19-12-2024}»)
        case "CDP - Costante di diffusione personalizzata"
            sPL.CD = str2num(oggIG.CDP.String,Evaluation="restricted");
        otherwise % Altrimenti non si definisce alcuna costante di diffusione
    end % Definizione della costante di diffusione

    
        %%% Raccolta dati (v. «https://pitgroup.org/connectome/#manual»)
    % percorso = [
    %             "../Dati/BCT3_418_ElecticalConnectivity_mean.csv" "../Dati/BCT3_418_ElecticalConnectivity_median.csv"
    %             "../Dati/BCT3_418_FiberCount_mean.csv"            "../Dati/BCT3_418_FiberLength_mean.csv"
    %             "../Dati/BCT3_476_ElecticalConnectivity_mean.csv" "../Dati/BCT3_476_ElecticalConnectivity_median.csv"
    %             "../Dati/BCT3_476_FiberCount_mean.csv"            "../Dati/BCT3_476_FiberCount_median.csv"
    %             "../Dati/BCT3_476_FiberLength_mean.csv"           "../Dati/BCT3_476_FiberLength_median.csv"
    %             "../Dati/BCT3_476_FractionalAnisotropy_mean.csv"  "../Dati/BCT3_476_FractionalAnisotropy_median.csv"
    %             ];
        % Prima dell'interfaccia s'inseriva tutto a mano

        sPM = []; % Struttura dei parametri del modello
        sCI = []; % Struttura delle condizioni iniziali

    nModello    = oggIG.SelMod(1).Value;
    sPM.modello = sLSel.vModelli(nModello,1);
    switch sPM.modello
        case "FK" % Modello di Fisher-Kolmogorov

                %Parametri
            sPM.nC   = 1; % Lunghezza massima delle catene malate
            sPM.nN   = length(sLSel.vNR); % Numero di nodi considerati
            sPM.alfa = str2num(oggIG.Car1(1).String,Evaluation="restricted"); % Tasso di conversione sane->malate
            
                % Condizioni iniziali
            sCI.seme = oggIG.NInf(1).Value; % Luogo in cui inizia la diffusione di prioni
            sCI.c0   = str2num(oggIG.CI1(1).String,Evaluation="restricted"); % Concentrazione iniziale di proteine malate nei semi

        case "ED" % Modello Eterodimero

                % Parametri
            sPM.nC      = 1; % Lunghezza massima delle catene malate
            sPM.nN      = length(sLSel.vNR); % Numero di nodi considerati
            sPM.k0      = str2num(oggIG.Car1(1).String); % Tasso di produzione delle cellule sane
            sPM.k1      = str2num(oggIG.Car2(1).String,Evaluation="restricted"); % Tasso di depurazione delle proteine sane
            sPM.k1tilde = str2num(oggIG.Car3(1).String,Evaluation="restricted"); % Tasso di depurazione delle proteine malate
            sPM.k12     = str2num(oggIG.Car4(1).String,Evaluation="restricted"); % Tasso di conversione sane->malate

                % Condizioni iniziali
            sCI.seme = oggIG.NInf(1).Value+83; % Luogo in cui inizia la diffusione di prioni
            sCI.cs0  = str2num(oggIG.CI1(1).String,Evaluation="restricted"); % Concentrazione iniziale di proteine sane
            sCI.cm0  = str2num(oggIG.CI2(1).String,Evaluation="restricted"); % Concentrazione iniziale di proteine malate nei semi

                % Calcolo delle caratteristiche omogenee
            % sPM.cmInf = (sPM.k1/(sPM.k12*sPM.k1tilde))*(sPM.k12*(sPM.k0/sPM.k1)-sPM.k1tilde);
            % sPM.csInf = sPM.k0/(sPM.k1+sPM.k12*sPM.cmInf);
            sPM.cmInf = (sPM.k0*sPM.k12-sPM.k1tilde*sPM.k1)/(sPM.k1tilde*sPM.k12);
            sPM.csInf = sPM.k1tilde/sPM.k12;
            % Queste formule si ricavano prendendo il sistema del modello eterodimero, si annullano
            % le derivate in tempo e in spazio e si risolve cercando i punti di equilibrio

        case "SMO" % Modello di Smoluchowski

                % Parametri
            sPM.nC  = str2num(oggIG.Car1(1).String,Evaluation="restricted"); % Lunghezza massima delle catene malate
            sPM.nN  = length(sLSel.vNR); % Numero di nodi considerati

            sPM.dim = oggIG.CDim(1).Value; % Controllo per la dimensione delle catene
            sPM.acc = oggIG.CAcc(1).Value; % Controllo per l'accumulazione dell'ultima catena

            sPM.k0  = str2num(oggIG.Car2(1).String,Evaluation="restricted"); % Tasso di produzione delle proteine sane
            sPM.k1  = str2num(oggIG.Car3(1).String,Evaluation="restricted"); % Tasso di depurazione delle proteine sane
            sPM.k2  = sPM.k1; % Tasso di depurazione delle proteine malate [sclusa l'ultima catena, ossia per i<n]
            sPM.kn  = sPM.k2*(1-sPM.acc);

            sPM.a   = str2num(oggIG.Car5(1).String,Evaluation="restricted"); % Tasso di aggregazione delle catene malate
            sPM.f   = str2num(oggIG.Car6(1).String,Evaluation="restricted"); % Tasso di frammentazione delle catene malate

                % Condizioni iniziali
            sCI.seme = oggIG.NInf(1).Value; % Luogo in cui inizia la diffusione di prioni
            sCI.ka0  = str2num(oggIG.CI1(1).String,Evaluation="restricted"); % Tasso di nucleazione delle proteine nei nodi in sPM.SMO.seme
            sCI.c10  = str2num(oggIG.CI2(1).String,Evaluation="restricted"); % Concentrazione iniziale dei monomeri sani su tutt'i nodi

            % Il limite inferiore del numero di catene rispetto alla
            % formulazione del sistema di Smoluchowski è, per il momento, 5
            % a causa della condizione di validità della sommatoria di
            % frammentazione per la cantena c2 in cui vale n-3>=2 ⟹ n>=5


                % Calcolo delle caratteristiche omogenee
            nN = sPM.nN; % Numero di nodi associato a nN per brevità di scrittura
            q  = length(sCI.seme); % Numero dei nodi infetti

                % Parametri omogonei
            gamma = sPM.k0;            % Tasso di produzione sana
            mi    = sPM.k1;            % Tasso di depurazione
            f     = sPM.f;             % Tasso di frazionamento
            ka    = sCI.ka0*(q/nN);    % Tasso di nucleazione
            a     = sPM.a;             % Tasso d'aggregazione

                % Stima normalizzata di m_∞
            c3 = 2*a*ka;
            c2 = 4*ka*mi+f*(6*ka-a);
            c1 = 2*(mi^2)+f*(3*mi+a*(gamma/mi));
            c0 = -gamma*(2*mi+3*f);
            r  = roots([c3 c2 c1 c0]);

            b = r>0 & (real(r)==r); % Controlla quali elementi di r sono positivi e reali
            sPM.mInf = min(r(b));

                % Stime normalizzate di M_∞ e P_∞
            sPM.MInf = gamma/mi-sPM.mInf;
            sPM.PInf = (mi*sPM.MInf-2*ka*(sPM.mInf^2))/(a*sPM.mInf);

                % Stime nodali di m_∞, M_∞ e P_∞
            sPM.mInfN = sPM.mInf;
            sPM.MInfN = sPM.MInf;
            sPM.PInfN = sPM.PInf;
            sPM.MTotN = gamma/mi;

                % Stime retali di m_∞, M_∞ e P_∞
            sPM.mInfR = sPM.mInfN*nN;
            sPM.MInfR = sPM.MInfN*nN;
            sPM.PInfR = sPM.PInfN*nN;
            sPM.MTotR = sPM.MTotN*nN;

                % Stima della distribuzione astintotica
            nRap = @(n) (2*mi+n*f).^2-2*a*f*sPM.mInf; % Numeratore del rapporto
            dRap = 4*a*sPM.mInf*(f+mi);          % Denominatore del rapporto
            nEsp = @(n) 4*(f+mi)^2-(2*mi+n*f).^2;
            dEsp = 4*a*f*sPM.mInf;
            sPM.cInf = @(n) sPM.PInfR*(nRap(n)./dRap).*exp(nEsp(n)./dEsp);

                % Stima della catena con concentrazione massima
            sPM.nMax = round(sqrt(6*a*(sPM.mInf/f))-2*mi/f);

            %{
                Vecchio codice per il conto dei valori asintotici in cui
                si adimensionalizzavano i parametri prima d'applicare le formule

                % In essenza questi blocchi successivi adimensionalizzano i parametri
                % rispetto ad a e a m0, calcolano le concentrazioni asintotiche e,
                % infine, le riportano dimensionali moltiplicando per m0

                    % Parametri omogonei
                gammaH = sPM.k0;            % Tasso omogeneo di produzione sana
                miH    = sPM.k1;            % Tasso omogeneo di depurazione
                betaH  = sPM.f;             % Tasso omogeneo di frazionamento
                kaH    = sCI.ka0*(q/nN);    % Tasso omogeneo di nucleazione
                % kaH    = sCI.ka0;    % Tasso omogeneo di nucleazione

                % m0 = gammaH/miH;  % Massa conservata omogenea dimensionale
                m0 = 1;             % Mole sana di riferimento

                    % Parametri adimensionalizzati
                gamma = gammaH/(sPM.a*(m0^2)); % Tasso adimensionale di produzione
                mi    = miH/(sPM.a*m0);        % Tasso adimensionale di depurazione
                beta  = betaH/(sPM.a*m0);      % Tasso adimensionale di frammentazione
                ka    = kaH/sPM.a;             % Tasso adimensionale di nucleazione
        
                    % Stima normalizzata di m_∞
                c3 = 2*ka;
                c2 = 4*ka*mi+(6*ka-1)*beta;
                c1 = 2*(mi)^2+beta*(3*mi+gamma/mi);
                c0 = -gamma*(2*mi+3*beta);
                r  = roots([c3 c2 c1 c0]);

                b = r>0 & (real(r)==r); % Controlla quali elementi di r sono positivi e reali
                sPM.mInf = min(r(b));

                    % Stime normalizzate di M_∞ e P_∞
                sPM.MInf = gamma/mi-sPM.mInf;
                sPM.PInf = (mi*sPM.MInf-2*(sPM.mInf)^2*ka)/sPM.mInf;

                    % Stime nodali di m_∞, M_∞ e P_∞
                sPM.mInfN = sPM.mInf*m0;
                sPM.MInfN = sPM.MInf*m0;
                sPM.PInfN = sPM.PInf*m0;
                sPM.MTotN = m0;
                % La ragione per cui bisogna moltiplicare per m0 discende dal
                % fatto che si è adimensionalizzata la concentrazione dividendo
                % per m0 (v. (31) a p. 6 di «Goriely 2019 Networks II {19-12-2024}»)

                % Dunque tale prodotto riporta le concentrazioni a essere dimensionali,
                % proprietà vale a prescindere dal valore preciso di m0 scelto,
                % che sia 1, gammaH/miH o arbitrario

                    % Stime retali di m_∞, M_∞ e P_∞
                sPM.mInfR = sPM.mInfN*nN;
                sPM.MInfR = sPM.MInfN*nN;
                sPM.PInfR = sPM.PInfN*nN;
                sPM.MTotR = sPM.MTotN*nN;

                    % Stima della distribuzione astintotica
                sPM.cInf = @(n) sPM.PInfR*(((2*mi+n*beta).^2-2*sPM.mInf*beta)./(4*sPM.mInf*(beta+mi))) ...
                                .*exp((4*(beta+mi)^2-(2*mi+n*beta).^2)./(4*beta*sPM.mInf));

                    % Stima della catena con concentrazione massima
                sPM.nMax = round(sqrt((6*sPM.mInf)/beta)-2*mi/beta); 
            %}

            %{
                % Forma vecchia retale

                % In essenza questi blocchi successivi svolgono i seguenti passi
                % Parametri retali -> p. omogenei -> p. o. adimensionali -> p. retali a.
                % E tutto ciò per considerare le giuste versioni dei parametri
                % da usare nella formula per ricavare la frazione di m0 a
                % cui tenderà la massa sana dopo un lungo tempo

                    % Traduzione dei parametri retali nei parametri omogonei
                gammaH = sPM.k0*(nN^2); % Tasso omogeneo di produzione sana
                miH    = sPM.k1*nN;     % Tasso omogeneo di depurazione
                betaH  = sPM.f*nN;      % Tasso omogeneo di frazionamento
                kaH    = sCI.ka0;       % Tasso omogeneo di nucleazione

                q  = length(sCI.seme); % Numero dei nodi infetti
                m0 = gammaH/miH;       % Massa conservata omogenea dimensionale

                    % Calcolo dei parametri omogenei adimensionalizzati
                gammaA = gammaH/(sPM.a*(m0^2)); % Tasso omogeneo adimensionale di produzione
                miA    = miH/(sPM.a*m0);        % Tasso omogeneo adimensionale di depurazione
                betaA  = betaH/(sPM.a*m0);      % Tasso omogeneo adimensionale di frammentazione
                kaA    = kaH/sPM.a;             % Tasso omogeneo adimensionale di nucleazione
        
                    % Traduzione dei parametri adimensionali omogenei nei parametri retali adimensionali
                gamma = gammaA/(nN^2); % Tasso retale adimensionale di produzione
                mi    = miA/nN;        % Tasso retale adimensionale di depurazione
                beta  = betaA/nN;      % Tasso retale adimensionale di frammentazione
                ka    = kaA;           % Tasso retale adimensionale di nucleazione

                    % Calcolo delle radici per la stima superiore di m_∞
                c3 = 2*q*ka/nN;
                c2 = 4*q*ka*mi+(6*q*ka-nN)*beta;
                c1 = 2*(mi*nN)^2+beta*(nN^2)*(3*mi+gamma/mi);
                c0 = -gamma*(nN^3)*(2*mi+3*beta);
                r  = roots([c3 c2 c1 c0]);

                    % Calcolo delle radici per la stima inferiore di m_∞
                % c3 = 2*q*ka/nN;
                % c2 = 4*q*ka*(mi+beta);
                % c1 = 2*(mi*nN)^2+beta*nN*(2*mi*nN+1);
                % c0 = -2*gamma*(nN^3)*(mi+beta);
                % r  = roots([c3 c2 c1 c0]);

                % Ho notato che la stima superiore coincide, in tutti gli
                % esempi considerati, col valore asintotico esatto; questo
                % risultato, in fondo, è prevedibile visto che a p. 10 di
                % «Goriely 2019 Networks II {19-12-2024}» si trascura c_2
                % ottenendo una soluzione indistinguibile da quella completa

                    % Stime normalizzate di m_∞, M_∞ e P_∞
                b = r>0 & (real(r)==r); % Controlla quali elementi di r sono positivi e reali
                sPM.mInf = min(r(b));
                sPM.MInf = 1-sPM.mInf;
                sPM.PInf = (nN*mi*sPM.MInf-2*(sPM.mInf)^2*ka*(q/nN))/sPM.mInf;

                    % Stima della distribuzione astintotica e del valore massimo
                sPM.cInf = @(n) sPM.PInfR*((nN*(2*mi+n*beta).^2-2*sPM.mInf*beta)./(4*sPM.mInf*(beta+mi))) ...
                                .*exp((4*(beta+mi)^2*nN-nN*(2*mi+n*beta).^2)./(4*beta*sPM.mInf));
                sPM.nMax = round(sqrt((6*sPM.mInf)/(beta*nN))-2*mi/beta);
                    % Si v. eqq. (87, 88) a p. 12 dell'articolo «Goriely 2019 Networks II {19-12-2024}»
            %}

            %{
                % Forma vecchia retale e con mi=gamma

                q  = length(sCI.seme); % Numero dei nodi infetti
                m0 = gammaH/miH;       % Massa conservata omogenea

                    % Calcolo dei parametri omogenei adimensionalizzati
                betaA = betaH/(sPM.a*m0); % Tasso omogeneo adimensionale di frammentazione
                miA   = miH/(sPM.a*m0);   % Tasso omogeneo adimensionale di depurazione
                kaA   = kaH/sPM.a;        % Tasso omogeneo adimensionale di nucleazione

                    % Traduzione dei parametri adimensionali omogenei nei parametri retali adimensionali
                beta = betaA/nN;  % Tasso retale adimensionale di frammentazione
                mi   = miA/nN;    % Tasso retale adimensionale di depurazione
                ka   = kaA;       % Tasso retale adimensionale di nucleazione

                    % Calcolo delle radici per la stima di m_∞
                c3 = 2*q*ka/nN;
                c2 = 4*q*ka*mi + (6*q*ka/nN-1)*beta*nN;
                c1 = beta*nN*(3*mi*nN+m0)+2*(mi*nN)^2;
                c0 = -m0*mi*(2*mi+3*beta)*(nN^2);
                % c1 = beta*nN*(3*mi*nN+1)+2*(mi*nN)^2;
                % c0 = -mi*(2*mi+3*beta)*(nN^2);
                r  = roots([c3 c2 c1 c0]);
            %}

    end

        sPT = []; % Struttura dei parametri temporali
    nDiscrT    = oggIG.DiscrT(1).Value;
    sPT.discrT = sLSel.vDiscrT(nDiscrT);
    sPT.T      = str2num(oggIG.PeriodoT(1).String,Evaluation="restricted");
    sPT.dt     = str2num(oggIG.PassoT(1).String,Evaluation="restricted");

    % Ciclo while per avere un numero di passi sufficiente a raggiungere
    % l'intervallo T [necessario nel caso in cui dt non sia un bel numero]
    sPT.nt = floor(sPT.T/sPT.dt);
    if(sPT.nt*sPT.dt < sPT.T)
        sPT.nt = sPT.nt + 1;
    end
    sPT.ns = oggIG.IS(2).Value;

        % Condizioni temporali
    sPT.CondLD    = oggIG.LTemp(2).Value;
    sPT.TipoLD    = oggIG.LTemp(1).Value;
    sPT.CondDeD   = oggIG.DeTemp(2).Value;
    sPT.TipoDeD   = oggIG.LTemp(1).Value;
    sPT.contrTemp = oggIG.ContrTemp(1).Value;
    sPT.risTemp   = oggIG.RisTemp(1).Value;

        % Caratteristiche per la contrazione temporale
    if(sPT.contrTemp == 1)
        sPT.Teps = sPT.dt*sPT.ns;
        sPT.eps  = sPT.Teps/sPT.T;
    else
        sPT.eps  = 1;
    end

        % Costante di adimensionalizzazione temporale
    if(sPT.risTemp == 1)
        sPT.Ad = 30/sPT.T;
    else % «[30 anni]/[periodo inserito]»
        sPT.Ad = 1;
    end

        % Si può scrivere «it(is(s))» per un certo «s» che scandisce «1:ns»
    sPT.it = (0:sPT.nt)*sPT.dt*sPT.Ad;
    sPT.is = round(linspace(0,sPT.nt,sPT.ns+1))+1;


    Disattiva_Oggetti()
    drawnow % Disattiva immediatamente gli oggetti

end


%% Funzioni ausiliari e di richiamo

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Funzioni ausiliari %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%

function Disattiva_Oggetti()

    global oggIG sPNI

    oggetti = string(fieldnames(oggIG));

    for o = 1:length(oggetti)
        for s = 1:length(oggIG.(oggetti(o)))
            if(~strcmp(oggIG.(oggetti(o))(s).Style,'text'))
                oggIG.(oggetti(o))(s).Enable = 'off';
            end % Se l'oggetto non è di tipo testo allora disattivalo
        end
    end

    punti = string(fieldnames(sPNI));

    for p = 1:sPNI.nN
        sPNI.(punti(p)).HitTest = 'off';
    end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Funzioni di richiamo %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Le funzioni di richiamo («callback») richiedono due ingressi: «source» e «event»; la prima contiene le informazioni
% su ciò che è stato premuto d'altra parte mentre la seconda è inutile per cui è sufficiente ignorarli mediante «~»

% Per chiamare una funzione di richiamo dentro un'altra funzione di richiamo si veda la preziosa risposta qui
% (https://stackoverflow.com/questions/1819232/how-do-i-execute-a-callback-function-from-another-function-file-in-matlab)

    % Nodi infetti
function FRListaNodiInfetti(src,~)

    global sPNI oggIG

    iNISel = src.Value; % Indice dei nodi considerati
    sPNI.vNSC(iNISel) = mod(sPNI.vNSC(iNISel)+1,2);
        % S'impongono i nodi selezionati facendoli alternare di stato: se erano
        % 0 diventano 1 e viceversa se erano 1 (il mod in base due serve a ciò)
    
    for n = 1:length(sPNI.vNSC) % Per tutti i nodi
        campo = append("N",string(n));
        if(sPNI.vNSC(n) == 1) % Se il nodo è stato selezionato si cambia il colore
            sPNI.(campo).FaceColor = [1 0 1];
        else               % Altrimenti si ristabilisce il suo colore originale
            sPNI.(campo).FaceColor = [0.5 0.5 0.5];
        end
    end

    sel = find(sPNI.vNSC);
    oggIG.NInf(1).Value = sel;

end

function FRCliccoNodiInfetti(~,~,indice)

    global oggIG sPNI

    campo = append("N",string(indice));
    if(sPNI.vNSC(indice) == 0)
        sPNI.vNSC(indice) = 1;
        sPNI.(campo).FaceColor = [1 0 1];
    else
        sPNI.vNSC(indice) = 0;
        sPNI.(campo).FaceColor = [0.5 0.5 0.5];
    end

    sel = find(sPNI.vNSC);
    oggIG.NInf(1).Value = sel;

end

function FRTrovaNI(~,~)

    global oggIG sPNI
    
    parola = oggIG.TrovaNI(1).String;

    if(~isempty(parola))
        parola = string(parola);
        oggIG.TrovaNI(1).String = '';
    
        iN = Trova_Indici(parola);
        sPNI.vNSC(iN) = zeros(length(iN),1);
        % Si pone il loro stato nullo cosicché FRListaNodiInfetti li attivi,
        % per evitare che il loro stato venga semplicemente alternato
        
        oggIG.NInf(1).Value = iN;
        FRListaNodiInfetti(oggIG.NInf(1),[])
    end

end

function FRResettaNI(~,~)

    global oggIG sPNI
    iNAttivi = find(sPNI.vNSC);
    oggIG.NInf(1).Value = iNAttivi;
    FRListaNodiInfetti(oggIG.NInf(1),[])

end

    % Vista grafo
function FRCursoreAzimuto(srg,~)

    global oggIG

    azimuto = floor(srg.Value);
    oggIG.Az(1).String = append(string(azimuto),"°");

    FRImpostaVista([],[])

end

function FRCursoreElevazione(srg,~)

    global oggIG

    elevazione = floor(srg.Value);
    oggIG.El(1).String = append(string(elevazione),"°");

    FRImpostaVista([],[])

end

function FRImpostaVista(srg,~)

    global oggIG

    if(~isempty(srg))
        azimuto    = floor(str2double(oggIG.Az(2).String));
        if(~isnan(azimuto))
            if(azimuto<0)
                azimuto = 0;
            elseif(azimuto>360)
                azimuto = 360;
            end
            oggIG.Az(1).String = append(string(azimuto),'°');
            oggIG.Az(2).String = '';
        else
            azimuto = str2double(strrep(oggIG.Az(1).String,'°',''));
        end

        elevazione = floor(str2double(oggIG.El(2).String));
        if(~isnan(elevazione))
            if(elevazione<-90)
                elevazione = -90;
            elseif(elevazione>90)
                elevazione = 90;
            end
            oggIG.El(1).String = append(string(elevazione),'°');
            oggIG.El(2).String = '';
        else
            elevazione = str2double(strrep(oggIG.El(1).String,'°',''));
        end

        view(azimuto,elevazione)
    else
        azimuto    = str2double(strrep(oggIG.Az(1).String,'°',''));
        elevazione = str2double(strrep(oggIG.El(1).String,'°',''));
        view(azimuto,elevazione)
    end

end

function FRSingoloDoppioPeso(srg,~)

    global oggIG
    
    tipoPeso = srg.Value;
    if(tipoPeso == 4)
        oggIG.TipoPeso(1).Visible = "off";
        oggIG.TipoPeso(2).Visible = "off";
    else
        oggIG.TipoPeso(1).Visible = "on";
        oggIG.TipoPeso(2).Visible = "on";
    end

end

% function SeguiVista(~,~,fig)
% 
%     global oggIG
% 
%     [azimuto,elevazione] = view(fig);
% 
%     prevAz = str2double(strrep(oggIG.Az(1).String,'°',''));
%     prevEl = str2double(strrep(oggIG.El(1).String,'°',''));
% 
%     if(azimuto~=prevAz || elevazione~=prevEl)
%         oggIG.Az(1).String = append(string(floor(azimuto)),'°');
%         oggIG.El(1).String = append(string(floor(elevazione)),'°');
%     end
% 
% end

    % Selezioni
function FRCasiStudio(srg,~,sT)

    global oggIG sCS sPNI

    nomiCS = fieldnames(sCS);
    CS = string(nomiCS(srg.Value+2));

    if(~isempty(sCS.(CS).Modello))
            % Dati sulla matrice laplaciana
        oggIG.SelMatr(1).Value    = sCS.(CS).TipoL;
        oggIG.NumCNT(1).Value     = sCS.(CS).NCT;
        oggIG.Cursore(2).String   = sCS.(CS).PCT;
        oggIG.TipoPeso(1).Value   = sCS.(CS).TipoPeso;
        oggIG.TipoMisura(1).Value = sCS.(CS).TipoMisura;
        oggIG.PreProc(1).Value    = sCS.(CS).Proc(1);
        oggIG.PosProc(1).Value    = sCS.(CS).Proc(2);
        oggIG.CDP.String          = sCS.(CS).Proc(3);
        FRCDPersonalizzata(oggIG.PosProc(1),[])
        FRSelezioneMatrice(oggIG.SelMatr(1),[])
        if(oggIG.SelMatr(1).Value == 2)
            FRSingoloDoppioPeso(oggIG.PreProc(1),[])
        end
        FRCursoreT(oggIG.Cursore(2),[],[0 100])

            % Dati sul modello e condizioni iniziali
        oggIG.SelMod(1).Value = sCS.(CS).TipoM;
        oggIG.Car1(1).String  = sCS.(CS).Car1;
        oggIG.Car2(1).String  = sCS.(CS).Car2;
        oggIG.Car3(1).String  = sCS.(CS).Car3;
        oggIG.Car4(1).String  = sCS.(CS).Car4;
        oggIG.CAcc.Value      = sCS.(CS).condAcc;
        oggIG.CDim.Value      = sCS.(CS).condDim;
        oggIG.Car5(1).String  = sCS.(CS).Car5;
        oggIG.Car6(1).String   = sCS.(CS).Car6;
        FRVisibilitaCaratteristiche(oggIG.SelMod(1),[],sT)

        oggIG.NInf(1).Value   = Trova_Indici(sCS.(CS).NI);
        oggIG.CI1(1).String   = sCS.(CS).CI1;
        oggIG.CI2(1).String   = sCS.(CS).CI2;
        sPNI.vNSC = zeros(length(sPNI.vNSC),1);
        FRListaNodiInfetti(oggIG.NInf(1),[])

        
            % Dati sul tempo
        oggIG.PassoT(1).String   = sCS.(CS).Passo;
        oggIG.PeriodoT(1).String = sCS.(CS).T;
        oggIG.IS(2).Value        = sCS.(CS).nIS;
        oggIG.DiscrT(1).Value    = sCS.(CS).TipoD;
        oggIG.LTemp(2).Value     = sCS.(CS).condLD;
        oggIG.LTemp(1).Value     = sCS.(CS).tipoLD;
        oggIG.DeTemp(2).Value    = sCS.(CS).condDeD;
        oggIG.DeTemp(1).Value    = sCS.(CS).tipoDeD;
        oggIG.ContrTemp(1).Value = sCS.(CS).contrTemp;
        oggIG.RisTemp(1).Value   = sCS.(CS).risTemp;
        FRCursoreIstantiSalvati([],[])
        FRAttivaDinamica(oggIG.LTemp(2),[],oggIG.LTemp(1))
        FRAttivaDinamica(oggIG.DeTemp(2),[],oggIG.DeTemp(1))

        sCS.("LineaStandardoModiche").direzione = sign(find("LineaStandardoModiche" == string(nomiCS))-2-srg.Value);
        sCS.("LineaModificheDinamica").direzione = sign(find("LineaModificheDinamica" == string(nomiCS))-2-srg.Value);
    else
        srg.Value = srg.Value+sCS.(CS).direzione;
        FRCasiStudio(srg,[],sT)
    end

end

function FRSelezioneMatrice(srg,~)

    global oggIG

    % Selezione della matrice con cui simulare
    switch srg.Value
        case 1 % 'Matrice dell'articolo'
            oggIG.Cursore(1).Visible = "off";
            oggIG.Cursore(2).Visible = "off";
            oggIG.Cursore(3).Visible = "off";

            oggIG.NumCNT(1).Visible = "off";
            oggIG.NumCNT(2).Visible = "off";

            oggIG.TipoPeso(1).Visible = "off";
            oggIG.TipoPeso(2).Visible = "off";

            oggIG.TipoMisura(1).Visible = "off";
            oggIG.TipoMisura(2).Visible = "off";

            oggIG.PreProc(1).Visible = "off";
            oggIG.PreProc(2).Visible = "off";

            oggIG.PosProc(1).Visible = "on";
            oggIG.PosProc(2).Visible = "on";

        case 2 % 'Matrice costruita'
            oggIG.Cursore(1).Visible = "on";
            oggIG.Cursore(2).Visible = "on";
            oggIG.Cursore(3).Visible = "on";

            oggIG.NumCNT(1).Visible = "on";
            oggIG.NumCNT(2).Visible = "on";

            oggIG.TipoPeso(1).Visible = "on";
            oggIG.TipoPeso(2).Visible = "on";

            oggIG.TipoMisura(1).Visible = "on";
            oggIG.TipoMisura(2).Visible = "on";

            oggIG.PreProc(1).Visible = "on";
            oggIG.PreProc(2).Visible = "on";

            oggIG.PosProc(1).Visible = "on";
            oggIG.PosProc(2).Visible = "on";

            
    end

end

function FRVisibilitaCaratteristiche(srg,~,sT)

    global oggIG

        % Si spengono tutte le luci per poi accendere solo alcune
    oggIG.Car1(1).Visible = "off";
    oggIG.Car1(2).Visible = "off";
    oggIG.Car2(1).Visible = "off";
    oggIG.Car2(2).Visible = "off";
    oggIG.Car3(1).Visible = "off";
    oggIG.Car3(2).Visible = "off";
    oggIG.Car4(1).Visible = "off";
    oggIG.Car4(2).Visible = "off";
    oggIG.CAcc.Visible    = "off";
    oggIG.CDim.Visible    = "off";
    oggIG.Car5(1).Visible = "off";
    oggIG.Car5(2).Visible = "off";
    oggIG.Car6(1).Visible = "off";
    oggIG.Car6(2).Visible = "off";
    oggIG.CI1(1).Visible = "off";
    oggIG.CI1(2).Visible = "off";
    oggIG.CI2(1).Visible = "off";
    oggIG.CI2(2).Visible = "off";


    switch srg.Value
        case 1 % FK - Parametri visibili: alfa, c0
                % Alfa
            oggIG.Car1(1).Visible = "on";
            oggIG.Car1(2).Visible = "on";
            oggIG.Car1(2).String = sT.FK;
            
                % c0
            oggIG.CI1(1).Visible = "on";
            oggIG.CI1(2).Visible = "on";
            oggIG.CI1(2).String = sT.CI(1);
            
        case 2 % ED - Parametri visibili: k0, k1, k̃1, k12, cs0, cm0
                % k0
            oggIG.Car1(1).Visible = "on";
            oggIG.Car1(2).Visible = "on";
            oggIG.Car1(2).String = sT.ED(1);
            
                % k1
            oggIG.Car2(1).Visible = "on";
            oggIG.Car2(2).Visible = "on";
            oggIG.Car2(2).String = sT.ED(2);
            
                % k̃1
            oggIG.Car3(1).Visible = "on";
            oggIG.Car3(2).Visible = "on";
            oggIG.Car3(2).String = sT.ED(3);
            
                % k12
            oggIG.Car4(1).Visible = "on";
            oggIG.Car4(2).Visible = "on";
            oggIG.Car4(2).String = sT.ED(4);
            
                % cs0
            oggIG.CI1(1).Visible = "on";
            oggIG.CI1(2).Visible = "on";
            oggIG.CI1(2).String = sT.CI(2);
            
                % cm0
            oggIG.CI2(1).Visible = "on";
            oggIG.CI2(2).Visible = "on";
            oggIG.CI2(2).String = sT.CI(3);
            
        case 3 % SMO - Parametri visibili: N. catene, k0, k1, Dimensione, a, f ,ka0

                % N. catene
            oggIG.Car1(1).Visible = "on";
            oggIG.Car1(2).Visible = "on";
            oggIG.Car1(2).String = sT.SMO(1);
            
                % k0
            oggIG.Car2(1).Visible = "on";
            oggIG.Car2(2).Visible = "on";
            oggIG.Car2(2).String = sT.SMO(2);
            
                % k1
            oggIG.Car3(1).Visible = "on";
            oggIG.Car3(2).Visible = "on";
            oggIG.Car3(2).String = sT.SMO(3);

                % Accumulazione e Dimensione
            oggIG.CAcc.Visible    = "on";
            oggIG.CDim.Visible    = "on";
            
                % a
            oggIG.Car5(1).Visible = "on";
            oggIG.Car5(2).Visible = "on";
            oggIG.Car5(2).String = sT.SMO(4);
            
                % f
            oggIG.Car6(1).Visible = "on";
            oggIG.Car6(2).Visible = "on";
            oggIG.Car6(2).String = sT.SMO(5);
            oggIG.Car6(1).Visible = "on";
            
                % ka0
            oggIG.CI1(1).Visible = "on";
            oggIG.CI1(2).Visible = "on";
            oggIG.CI1(2).String = sT.CI(4);
            
                % c10
            oggIG.CI2(1).Visible = "on";
            oggIG.CI2(2).Visible = "on";
            oggIG.CI2(2).String = sT.CI(5);
            
    end

end

    % Altro
function FRCursoreD(srg,~)
    global oggIG
    oggIG.Cursore(2).String = num2str(round(srg.Value));
end

function FRCursoreT(srg,~,minMax)
    global oggIG

    numero = round(str2double(srg.String));

    if(numero<minMax(1))
        oggIG.Cursore(1).Value = minMax(1);
        oggIG.Cursore(2).String = string(minMax(1));
    elseif(numero>minMax(2))
        oggIG.Cursore(1).Value = minMax(2);
        oggIG.Cursore(2).String = string(minMax(2));
    else
        oggIG.Cursore(1).Value = numero;
    end
    
end

function FRAttivaDinamica(srg,~,oggetto)

    global oggIG

    if(srg.Value == 0)
        oggetto.Visible = 'off';
    else
        oggetto.Visible = 'on';
    end

    % if(oggIG.LTemp(2).Value || oggIG.DeT
    % emp(2).Value)
    %     oggIG.RisTemp(1).Value = 1;
    %     oggIG.RisTemp(1).Enable = 'off';
    % else
    %     oggIG.RisTemp(1).Enable = 'on';
    % end

end

function FRCDPersonalizzata(srg,~)

    global sLSel oggIG

    selPosProc = srg.Value;
    switch sLSel.vPosProc(selPosProc)
        case "CDP - Costante di diffusione personalizzata"
            oggIG.CDP.Visible = 'on';
        otherwise % Se è qualunque altra opzione
            oggIG.CDP.Visible = 'off';

    end

end

function FRCursoreIstantiSalvati(~,~)

    global oggIG sLSel

    nN = length(sLSel.vNR);
    switch oggIG.SelMod(1).Value
        case 1
            nE = nN;
        case 2
            nE = 2*nN;
        case 3
            nC = str2num(oggIG.Car1(1).String,Evaluation="restricted");
            nE = nC*nN;
    end % Numero di elementi per ogni istante

    T  = str2num(oggIG.PeriodoT(1).String,Evaluation="restricted");
    dt = str2num(oggIG.PassoT(1).String,Evaluation="restricted");
    nt = T/dt;

        % Si sottrae -1 perché se si dovesse scegliere nSmax come il numero d'istanti
        % salvati ns alla sarebbe sicuro, ossia possibile, sommare +1 a ns
    nSmax = floor((16*1024^3)/(nE*8))-1;
    if(nt<nSmax)
        nSmax = nt;
    end % Se il numero totale di istanti salvabili è minore degli istanti totali 
    oggIG.IS(2).Max = nSmax;
    oggIG.IS(2).SliderStep = [.9/nSmax 9.9/nSmax]+1e-6;
        % Si somma 1e-6 perché il minimo valore accettabile è proprio
        % quello: nel caso 1/nSmax avesse 6 zeri dopo la virgola, allora
        % quel 1e-6 garantirebbe la validità del valore

    nSel = round(oggIG.IS(2).Value); % Numero selezionato
    if(nSel>=nSmax)
        oggIG.IS(2).Value = nSmax;
        testo = append(string(nSmax)," istanti equispaziati salvati");
        oggIG.IS(1).String = testo;
    else
        oggIG.IS(2).Value = nSel;
        testo = append(string(nSel)," istanti equispaziati salvati");
        oggIG.IS(1).String = testo;
    end

    est = get(oggIG.IS(1),'Extent');
    xC = oggIG.IS(1).Position(1);
    lC = oggIG.IS(1).Position(3);

    oggIG.IS(1).Position(1) = xC+(lC-est(3))/2;
    oggIG.IS(1).Position(3) = est(3);

end

    % Bottoni
function Avvio(srg,~,RiAvvioBott)
        % Variabile globale per tracciare se è stato premuto il bottone; infatti Matlab, per qualche motivazione,
        % cambia «AvvioBott.Value» da 0 a 1 solo finché si è all'interno della funzione di richiamo: una volta fuori il
        % suo valore è riportato a zero, come se non fosse stato premuto
    global avvia
    avvia = 1;

        % Disabilità il bottone d'avvio e abilità quello di riavvio
    srg.Enable         = 'off';
    RiAvvioBott.Enable = 'on';
end

function RiAvvio(~,~)
    run Grafo_Celebrale.m;
end

function Esci(~,~)
    global termina avvia

    if(avvia == 0) % Se non si è avviato il codice
        termina = 1;
    else           % Se non si è avviato il codice
        close all
    end
end
