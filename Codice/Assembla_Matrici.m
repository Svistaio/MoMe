function Assembla_Matrici(sPL,sPT,sPM)

    % Questa funzione definisce una struttura per indentificare i nodi a
    % partire dalle regioni; nel mentre si definiscono anche la matrice di
    % adiacenza (A), dei gradi (G) e della connettività (L) del grafo ridotto

        %%% Costruzione della matrice laplaciana %%%
    Preprocessamento_MatriceL(sPL);

        %%% Posprocessamento %%%
    Posprocessamento_MatriceL(sPL)

        %%% Dinamicitià %%%
    Dipendenza_Temporale(sPT,sPM)

end % readtable("../Dati/BCT3_418_FiberCount_mean.csv")

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Funzioni ausiliari %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%

function Preprocessamento_MatriceL(sPL)

    global L A G
    global sML sReg

    forma   = sPL.TipoL;

    sReg = []; % Struttura che a ogni regione vi associa gl'indici dei punti del grafo al suo interno

    if(forma == 1)  % Articolo

        sReg.PuntiReg = sPL.PuntiReg;

            % Matrice laplaciana
        percorso = "../Dati/Article_Laplacian.csv";
        L  = readmatrix(percorso);

            % Matrice d'adiacenza e dei gradi
        A = diag(diag(L)) - L;
        G = diag(sum(A,2));

        % percorso = "../Risorse/Matrice Adiacenza/Matrice_Adiacenza_Media.txt";
        % A  = readmatrix(percorso);
        % G = diag(sum(A,2));
        % L = G - A;

            % Per mostrare informazioni
        % M = diag(sum(A,2));
        % disp([min(M+(M==0)*max(M,[],'all'),[],'all') ...                          % Minimo elemento [non nullo]
        %       max(M,[],'all') ...                                                 % Massimo elemento
        %       sum(M,'all')/(2*nN)])
        % disp([min(M/norm(M)+(M/norm(M)==0)*max(M/norm(M),[],'all'),[],'all') ...  % Minimo elemento [non nullo]
        %       max(M/norm(M),[],'all') ...                                         % Massimo elemento
        %       sum(M/norm(M),'all')/(2*nN)])

    elseif(forma == 2) % Costruita

            % Mappatura del grafo in un grafo avente come nodi solo le macroregioni
        [soglia,nL,nN] = Mappa_MacroRegioni(sPL);

            % Assemblaggio delle matrici di adiacenza, dei gradi e laplaciana %
        sReg.PuntiReg = strings(nN,1); % Vettori di stringhe che a ogn'indice del nodo associano la relativa macroregione
    
            % Inizializzazione della matrice d'adiacenza [sparsa]
        iRigAdia = zeros(2*nL,1); iColAdia = zeros(2*nL,1); valAdia = ones(2*nL,1);
            % Si considerano, senza valutare la soglia, non nulli tutti i lati (caso peggiore)
            % e quindi un numero di elementi nelle matrici sparse pari a 2*nL
    
        contL = 0; % Contatore dei lati permessi
    
            % Costruzione di una matrice uguale per struttura a «tabGrafo» ma riferita alla mappatura definita da «sML»
        campiN1 = string(fieldnames(sML));
        for i = 1:length(campiN1)
            campiN2 = string(fieldnames(sML.(campiN1(i))));
            for j = 1:length(campiN2)
    
                iN1  = sML.(campiN1(i)).(campiN2(j)).IndiceN1;
                iN2  = sML.(campiN1(i)).(campiN2(j)).IndiceN2;
                peso = sML.(campiN1(i)).(campiN2(j)).Peso;
    
                    % Costruzione dei vettori rappresentanti la matrice d'adiacenza
                if(sML.(campiN1(i)).(campiN2(j)).NumeroCT>=soglia)
                    if(iN1 == iN2)
                            contL = contL+1;
                        iRigAdia(contL) = iN1; iColAdia(contL) = iN2; valAdia(contL)  = peso;
                    else
                            contL = contL+1;
                        iRigAdia(contL) = iN1; iColAdia(contL) = iN2; valAdia(contL)  = peso;
                            contL = contL+1;
                        iRigAdia(contL) = iN2; iColAdia(contL) = iN1; valAdia(contL)  = peso;
                    end
                end 
    
                        % Costruzione della struttura per ricavare gl'indici dei nodi appartenenti a una regione
                    % Controllo della macroregione del primo nodo
                regN1 = sML.(campiN1(i)).(campiN2(j)).MacroRegN1; % Macroregione del primo nodo
                if(isfield(regN1,sReg)) % Se la macroregione già esiste si accoda il nodo a essa
                    if(~ismember(iN1,sReg.(regN1)(:)))
                        sReg.(regN1)(end+1) = iN1;
                    end
                else % Altrimenti si crea la macroregione
                    sReg.(regN1) = iN1;
                end
    
                    % Controllo della macroregione del secondo nodo
                regN2 = sML.(campiN1(i)).(campiN2(j)).MacroRegN2; % Macroregione del primo nodo
                if(isfield(regN2,sReg))
                    if(~ismember(iN2,sReg.(regN2)(:)))
                        sReg.(regN2)(end+1) = iN2;
                    end
                else
                    sReg.(regN2) = iN2;
                end
    
                    % Aggionrnamento vettore [indici dei nodi]<--->[macroregione relativa]
                if(sReg.PuntiReg(iN1) == "")
                    sReg.PuntiReg(iN1) = regN1;
                end
                if(sReg.PuntiReg(iN2) == "")
                    sReg.PuntiReg(iN2) = regN2;
                end
    
            end
        end
    
            % Definizione sparza della matice di adiacenza
        iRigAdia = iRigAdia(1:contL); iColAdia = iColAdia(1:contL); valAdia = valAdia(1:contL);
        % A = sparse(iRigAdia,iColAdia,valAdia,nN,nN);
            % Se L è sparsa non si può calcolare [perché inefficiente] la sua norma spettrale
            % norm(L,2); dunque è meglio evitare in quest'applicazione matrici sparse
    
            % Costruzione non sparsa della matrice
        A = zeros(nN,nN);
        for k = 1:contL
    
            i = iRigAdia(k);
            j = iColAdia(k);
            w = valAdia(k);
    
            A(i,j) = A(i,j) + w;
    
        end
    
            % Definizione della matrice dei gradi come matrice diagonale avente come
            % relativi elementi la somma delle righe di A (il 2 indica somma delle righe)
        G = diag(sum(A,2));

            % Matrice laplaciana
        L = G - A;
        
    else
        disp("Forma della matrice non considerata")
    end

end

function Posprocessamento_MatriceL(sPL)

    global L A G sLSel

    posProc = sPL.PosProc;

    switch sLSel.vPosProc(posProc)

        case "CDG - Costante di diffusione di Goriely"
            rho = sPL.CD;

        case "CDP - Costante di diffusione personalizzata"
            rho = sPL.CD;

        case "NSL - Normalizzazione spettrale [della matrice] L"
            rho = 1/norm(L);

        case "Nessuna normalizzazione"

    end

    A = A*rho;
    G = G*rho;
    L = L*rho;

        % In ogni caso i valori minimo, massimo e medio non corrispondono all'articolo
    % disp([min(G/norm(G)+(G/norm(G)==0)*max(G/norm(G),[],'all'),[],'all') ...  % Minimo elemento [non nullo]
    %       max(G/norm(G),[],'all') ...                                         % Massimo elemento
    %       sum(G/norm(G),'all')/(2*nN)])                                    % Media tra gli elementi [non nulli]
    % 
    % disp([min(A/norm(A)+(A/norm(A)==0)*max(A/norm(A),[],'all'),[],'all') ...  % Minimo elemento [non nullo]
    %       max(A/norm(A),[],'all') ...                                         % Massimo elemento
    %       sum(A/norm(A),'all')/(2*nN)])                                    % Media tra gli elementi [non nulli]

    % disp([min(A+(A==0)*max(A,[],'all'),[],'all') ...                          % Minimo elemento [non nullo]
    %       max(A,[],'all') ...                                                 % Minimo elemento [non nullo]
    %       sum(L,'all')/(2*nN)])                                            % Media tra gli elementi [non nulli]

end

function Dipendenza_Temporale(sPT,sPM)

    global L A G sLSel

    condLD = sPT.CondLD;
    nN = sPM.nN;

    if(condLD == 0) % Se la L non è dinamica

        L = @(t) L;
        A = @(t) A;
        G = @(t) G;

    else % Se altrimenti lo è si dà la relativa legge di decadimento fd

        tipoLD = sPT.TipoLD;

        switch sLSel.vLTemp(tipoLD)

            case "Iperbolica"
                a  = 20;
                fd = @(t) 1./(1+t./a);
                
                L = @(t) fd(t)*L;
                A = @(t) fd(t)*A;
                G = @(t) fd(t)*G;

            case "Esponenziale"
                a  = 20;
                fd = @(t) exp(-t./a);

                L = @(t) fd(t)*L;
                A = @(t) fd(t)*A;
                G = @(t) fd(t)*G;

            case "Guassiana"
                g  = @(t,N,m,s) N*exp(-((t-m).^2)/s);
                fd = @(t) g(t,1.5,5,60)+g(t,0.7,19,50)+g(t,0.1,40,600);

                L = @(t) fd(t)*L;
                A = @(t) fd(t)*A;
                G = @(t) fd(t)*G;

            case "Misto cml"
                c = 10;

                fdc = @(t) exp(-t./(20/c));
                fdm = @(t) 1./(1+t./(100/c));
                fdl = @(t) 1./(1+t./(400/c));

                [eC,eM,eL] = Maschere_Temporali(nN,A);
                A = @(t) A.*(eC*fdc(t)+eM*fdm(t)+eL*fdl(t)); % Ridefinizione della A
                G = @(t) diag(sum(A(t),2));
                L = @(t) G(t)-A(t);

                % Decadimento gaussiano scartato
                % g = @(t,N,m,s) N*exp(-((t-m).^2)/s);
                % fdm = @(t) g(t,1.5,5,60)+g(t,0.7,19,50)+g(t,0.1,40,600);

            case "Misto lmc"
                c = 10;

                fdc = @(t) 1./(1+t./(400/c));
                fdm = @(t) 1./(1+t./(100/c));
                fdl = @(t) exp(-t./(20/c));

                [eC,eM,eL] = Maschere_Temporali(nN,A);
                A = @(t) A.*(eC*fdc(t)+eM*fdm(t)+eL*fdl(t)); % Ridefinizione della A
                G = @(t) diag(sum(A(t),2));
                L = @(t) G(t)-A(t);

            case "Misto mcl"
                c = 10;

                fdc = @(t) 1./(1+t./(100/c));
                fdm = @(t) exp(-t./(20/c));
                fdl = @(t) 1./(1+t./(400/c));

                [eC,eM,eL] = Maschere_Temporali(nN,A);
                A = @(t) A.*(eC*fdc(t)+eM*fdm(t)+eL*fdl(t)); % Ridefinizione della A
                G = @(t) diag(sum(A(t),2));
                L = @(t) G(t)-A(t);

        end

        Mostra_Tempo_Diffusivo()

    end

    %{
        Guardando l'andamento delle concentrazioni di catene malate nei vari
        nodi rispetto a quelli infetti è chiaro che la distanza non sia la
        discriminante che pensavo: per es. in FK il «brainstem» s'infetta
        dopo i «superior parietal», nonostante quest'ultimi si trovino a una
        distanza molto maggiore del primo rispetto agli «entorhinal» (v'è da
        dire che il «brainstem» è un nodo di per sé poco collegato in
        generale). Dunque ha senso smorzare gli assoni in base alla distanza?
        Non credo perché l'esempio di primo mostra come il cervello consideri
        importante alcuni collegamenti a prescidere dalla loro distanza.
        
        Pertanto l'ipotesi che si può fare è che la configurazione iniziale
        L(0) sia già quella ottimale (ipotesi di ottimalità iniziale) e che
        nel tempo la laplaciana, che si ricorda rappresenta la diffusione
        nella rete delle proteine malate, venga smorzata in modo uniforme;
        questa è la ragione per cui nei tre casi precedenti si moltiplica
        semplicemente la L per fd(t). Il problema di tale approccio è che la
        dinamica è un po' noisosa: banalmente si ha un rallentamento o un
        accelerazione nel caso in cui fd(t) sia <1 o >1.
        
        Si potrebbe, secondo me, anche definire una laplaciana piú complessa
        che dia una dipendenza temporale diversa a seconda del tipo di
        componente, ma la vera domanda ora diventa che discriminante usare.
        Infatti la distanza non va bene, come già spiegato, ma allora a cosa
        si può far riferimento per dare una decadenza piuttosto che un'altra?
        Forse il modulo della componente, ma allora quel tipo di legame deve
        decadere piú o meno velocemente di altri? Non si può dire a priori
        perché non è chiaro come si comporti il cervello in tali situazioni,
        ossia come si comporta di fronte all'invecchiamento: cerca di
        disperatamente di mantenere la configurazione iniziale (ipotesi
        precedente) oppure priorizza a seconda di quale criterio?
        
        Vista quindi l'evidente arbitrarietà delle scelte si possono comunque
        riutilizzare gli andamenti visti in precedenza nel seguente modo: si
        considera un nodo, quindi si analizzano le distanze fra gli altri (se
        la L viene dall'articolo) o le lunghezza fibrale media (se la L viene
        costruita), poi si calcola il valore medio, infine i punti a metà fra
        gli estremi e il punto medio rappresentano le soglie cui applicare le
        decadenze; se il legame è nella prima fascia corta allora decade
        esponenzialmente, se nella seconda media gaussianamente, se nella
        terza lunga iperbolicamente. In tal modo s'ipotizza che la fascia
        media viene rafforzata prima di decadere mentre le altre decadano
        direttamente senza incrementi; perché il cevello si comporta cosí?
        Non lo so e non è importante in questo contesto: basta solo mostrare
        una particolare cinematica che dev'essere chiaramente stabilità
        dai dati sperimentali, a prescindere dalle cause (ossia la dinamica).
        
        Nella relazione conviene quindi illustrare tutti gli aspetti critici
        di questa complicazione spiegando anche perché la scelta della
        decadenza, ossia della cinematica, «deve» dipendere dai dati sperimentali,
        e che ai fini di questa relazione si sono proposte varie cinematiche
        senza però considerare le cause (dinamiche) sottostanti.
    %}

end

function [eC,eM,eL] = Maschere_Temporali(nN,A)

        % Inzializzazione delle matrici di classificazione
    % eC = zeros(nN,nN);
    % eM = zeros(nN,nN);
    % eL = zeros(nN,nN);

        % Valore medio, massimo e minimo di L
    vMed = (1/(nN^2))*sum(A,"all");
    vMin = min(A,[],"all");
    vMax = max(A,[],"all");

        % Soglia corta-media e media-lunga
    sCM = (vMin+vMed)/2; sML = (vMed+vMax)/2;

        % Maschere
    eC = double(A<=sCM);    % Elementi nella fascia corta
    eM = double(A<=sML)-eC; % Elementi nella fascia media
    eL = double(A>sML);     % Elementi nella fascia lunga

end

function Mostra_Tempo_Diffusivo()

    global L

    sF.x=0; sF.y=0; sF.l=1/2; sF.a=1/2;
    sF.p = [sF.x sF.y sF.l sF.a];
    f = figure('Name','Tempo diffusivo','Resize','off', ...
               'NumberTitle','off','Units', 'Normalized','Position',sF.p);
    movegui(f,'center'); % Muove la figura al centro    

    t = linspace(0,60,100);
    normL = @(t) 1/norm(L(t),2);
    y = arrayfun(normL,t);

    plot(t,y,'LineWidth',1.5,'Color','k')
    grid on
    ax = gca; ax.GridLineStyle = '--';
    xlabel('t','Interpreter','latex','FontSize',14);
    ylabel('$\tau_D$','Interpreter','latex','FontSize',14);

end

%%%%%%%%%%%%%%%%%%%%%%%
%%% Codice scartato %%%
%%%%%%%%%%%%%%%%%%%%%%%

%{
    [Vr,Dr] = eig(L);
    D = [sum(Dr,2), sum(Dg(1:83,1:83),2)];
    disp(append("Distanza tra i vettori Dr e Dg: ",string(norm(sum(Dr,2)-sum(Dg(1:83,1:83),2)))))
        Mediante questo piccolo codice ho provato a trovare il valore ottimale con cui "normalizzare" la L cosí da
        minimizzare le distanze tra le matrici degli autovalori originali e ridotta; il problema è che tale valore
        scatura una dinamica peggiore, ma non pessima, rispetto alla già trovata norma spettrale
    itv = 1:5;
    f = @(x) norm(sum(Dr(itv,itv),2)./x-sum(Dg(itv,itv),2));
    [min,fval] = fminunc(f,1);
    L = L/min;
    [Vrm,Drm] = eig(L);
    D = [sum(Dr,2), sum(Dg(1:83,1:83),2), sum(Drm,2)];
        Prove per vedere cosa comporta modificare diversi valori della L
    n = 35;
    v = 0;
    for i = 1:nNodi-n
        L(i,i+n) = v;
        L(i+n,i) = v;
    end
%}

    %{
        Vecchio codice in «Maschere_Temporali» che applica riga per riga la logica
        generale per classificare gli elementi di L come corti, medi e lunghi

        for i = 1:nN

                % Valore medio della i-esima riga
            vMed = (1/nN)*sum(M(i,:));
        
                % Valore massimo e minimo della riga i-esima
            vMin = min(M(i,:)); vMax = max(M(i,:));
        
                % Soglia corto-medio e medio-lungo
            sCM = (vMin+vMed)/2; sML = (vMed+vMax)/2;
        
                % Righe che classificano gli elementi
            eC(i,:) = double(M(i,:)<=sCM);         % Elementi nella fascia corta
            eM(i,:) = double(M(i,:)<=sML)-eC(i,:); % Elementi nella fascia media
            eL(i,:) = double(M(i,:)>sML);          % Elementi nella fascia lunga
        
        end % Per ogni riga i
    %}

    %{ 
        Vecchio codice in «Maschere_Temporali» troppo lento per il numero
        di chiamate di funzioni eccessivamente elevato (83^2=6889)
        
        for j = 1:nN
        
            if(L(i,j) <= sCM)     % Fascio corto
                fij = @(t) fdc(t)*L(i,j); % Decadenza iperbolica
            elseif(L(i,j) <= sML) % Fascio medio
                fij = @(t) fdm(t)*L(i,j); % Decadenza guassiana
            else                  % Fascio lungo
                fij = @(t) fdl(t)*L(i,j); % Decadenza esponenziale
            end
        
                % Costruzione della funzione associata alla i-esima riga
            if(j == 1)
                fi = @(t) fij(t); % Inzializzazione alla prima colonna
            else
                fi = @(t) [fi(t) fij(t)]; % Accodamento dell j-esima colonna
            end
        
        end % Per ogni riga j
        
            % Costruzione della Laplaciana parziale
        if(i == 1)
            Lp = @(t) fi(t); % Inzializzazione alla prima riga
        else
            Lp = @(t) [Lp(t); fi(t)]; % Accodamento della riga i-esima
        end
    %}

        %{
            Casi scartati nel posprocessamento perché privi di senso matematico
            o biologico; infatti ho poi scoperto che il riscalamento cambia
            semplicemente la scala temporale diffusiva, quindi sbizzarrirsi non serve

            case "N1L - Normalizzazione uno [della matrice] L"
                L = L/norm(L,1);

            case "NIL - Normalizzazione uniforme [della matrice] L"
                L = L/norm(L,inf);

            case "NGL - Normalizzazione gradale [della matrice] L"
                % for k = 1:nN
                %     for h = k:nN
                %         g = sqrt(Gr(k,k)*Gr(h,h)); % Radice del prodotto tra il grado del nodo k-esimo e il grado del nodo h-esimo
                %         if(g > 0)
                %             L(k,h) = L(k,h)/g;
                %             L(h,k) = L(h,k)/g;
                %         end
                %     end
                % end
                L = diag(sum(G,2).^(-1/2))*L*diag(sum(G,2).^(-1/2));

            case "NGL+NSL"
                for k = 1:nN
                    for h = k:nN
                        g = sqrt(G(k,k)*G(h,h)); % Radice del prodotto tra il grado del nodo k-esimo e il grado del nodo h-esimo
                        if(g > 0)
                            L(k,h) = L(k,h)/g;
                            L(h,k) = L(h,k)/g;
                        end
                    end
                end
                L = L/norm(L);

            case "NSGA - Normalizzazione spettrale [delle matrici] G e A"
                L = G/norm(G) - A/norm(A);

            case "NPRL - Normalizzazione per righe [della matrice] L"
                for k = 1:nN
                    L(k,:)=L(k,:)/(norm(L(k,:)));
                end
                % L = L/norm(L);

            case "NPCL - Normalizzazione per colonne [della matrice] L"
                for k = 1:nN
                    L(:,k)=L(:,k)/(norm(L(:,k)));
                end
                % L = L/norm(L);

            case "NPRL+NGL"
                for k = 1:nN
                    L(k,:)=L(k,:)/(norm(L(k,:)));
                end
                for k = 1:nN
                    for h = k:nN
                        g = sqrt(G(k,k)*G(h,h)); % Radice del prodotto tra il grado del nodo k-esimo e il grado del nodo h-esimo
                        if(g > 0)
                            L(k,h) = L(k,h)/g;
                            L(h,k) = L(h,k)/g;
                        end
                    end
                end

            case "NPCL+NGL"
                for k = 1:nN
                    L(:,k)=L(:,k)/(norm(L(:,k)));
                end
                for k = 1:nN
                    for h = k:nN
                        g = sqrt(G(k,k)*G(h,h)); % Radice del prodotto tra il grado del nodo k-esimo e il grado del nodo h-esimo
                        if(g > 0)
                            L(k,h) = L(k,h)/g;
                            L(h,k) = L(h,k)/g;
                        end
                    end
                end

            case "NDL" % «Normalizzazione Diagonale [della matrice] L»
                L = G - A;
                lambda = norm(L);
                d = floor(nN/2); % Numero di diagonali da rinormalizzare
            
                for k = 0:d-1
                    for h = 1:d-k
                        if(k == 0)
                            L(h,h) = L(h,h)/lambda;
                        else
                            L(h,h+k) = L(h,h+k)/lambda;
                            L(h+k,h) = L(h+k,h)/lambda;
                        end
                    end
                end
        %}