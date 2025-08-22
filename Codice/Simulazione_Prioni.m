function Simulazione_Prioni(sPT,sPM,sCI)

        % Definizione della funzione f del sistema dinamico dc/dt=f(c)
    switch sPM.modello
        case "FK"  % Modello di Fisher-Kolmogorov
            f = Funzione_FK(sPM,sPT,sCI);
        
        case "ED"  % Modello Eterodimero
            f = Funzione_ED(sPM,sPT,sCI);

        case "SMO" % Modello di Smoluchowky
            f = Funzione_SMO(sPM,sPT,sCI);

        otherwise
            disp("Il modello inserito non è stato contemplato.")
            return;
    end

        % Risoluzione
    switch sPT.discrT
        case "EE" % Schema di Eulero Esplicito
            Eulero_Esplicito(sPT,f);

        case "EI" % Schema di Eulero Implicito
            Eulero_Implicito(sPT,f);
    end

    Estrai_Concentrazioni_Prioni(sPM,sPT)

end

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Funzioni Ausiliari %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Funzioni f(x)
function f = Funzione_FK(sPM,sPT,sCI)

    global L c

        % Numero totale di nodi
    nN = sPM.nN;

        % Indici dei nodi infetti
    iNI = sCI.seme;

        % Inizializzazione della concentrazione
    c = zeros(nN,sPT.ns+1);

        % Condizione iniziale della concentrazione
    c(iNI,1) = sCI.c0;

        % Inizializzazione funzione
    f = @(c,t) (-L(t)*c+sPM.alfa*c.*(1-c));

end

function f = Funzione_ED(sPM,sPT,sCI)

    global L c

        % Numero totale di nodi
    nN = sPM.nN;

        % Indici dei nodi infetti
    iNI = sCI.seme;

        % Inizializzazione della concentrazione
    c = [sCI.cs0*ones(nN,sPT.ns+1)
         zeros(nN,sPT.ns+1)];

        % Condizione iniziale della concentrazione
    c(iNI,1) = sCI.cm0;
    % L'inizializzazione deve avvenire dopo N («c(iN+nNodi,1)») poiché le prime nNodi
    % concentrazioni fanno riferimento alle cellule sane e le restanti alle malate

        % Valore temporale dei tassi di depurazione
    condDeD = sPT.CondDeD;
    if(condDeD == 0) % Se i tassi di depurazioni non sono dinamici
        sPM.k1      = @(t) sPM.k1;
        sPM.k1tilde = @(t) sPM.k1tilde;
    else % Se altrimenti lo è si dà la relativa legge di decadimento fd
        tipoDeD = sPT.TipoDeD;
        switch tipoDeD
            case 1 % Iperbolica
                a  = 20;
                fd = @(t) 1./(1+t./a);
            case 2 % Esponenziale 
                a  = 20;
                fd = @(t) exp(-t./a);
            case 3 % Gaussiana
                g  = @(t,N,m,s) N*exp(-((t-m).^2)/s);
                fd = @(t) g(t,1.5,5,60)+g(t,0.7,19,50)+g(t,0.1,40,600);
        end
        sPM.k1      = @(t) sPM.k1*fd(t);
        sPM.k1tilde = @(t) sPM.k1tilde*fd(t);
    end

        % Inizializzazione funzioni
    fs = @(cs,cm,t) (-L(t)*cs + sPM.k0 - sPM.k1(t)*cs      - sPM.k12*cs.*cm); % Funzione delle concentrazioni sane
    fm = @(cs,cm,t) (-L(t)*cm          - sPM.k1tilde(t)*cm + sPM.k12*cs.*cm); % Funzione delle concentrazioni malate

    f = @(c,t) [fs(c(1:end/2),c((end/2+1):end),t)
                fm(c(1:end/2),c((end/2+1):end),t)]; % Funzione totale

end

function f = Funzione_SMO(sPM,sPT,sCI)

    global L c

        % Numero totale
    nN = sPM.nN; % Di nodi
    nC = sPM.nC; % Di catene

        % Inizializzazione 
    c = zeros(nN*nC,sPT.ns+1); % Del vettore
    c(1:nN,1) = sCI.c10;       % Della concentrazione sana

    % La struttura di c è la seguente: contiene a intervalli di nN i
    % valori delle catene in ordine crescente; quindi, per es., le
    % prime nN posizioni sono i monomeri [sani] negli nN nodi
    %
    % Cosí ragionando reshape(c(:,t),nN,nC) trasforma il vettore
    % in un istante, ossia la colonna i-esima corrispondente alle
    % concentrazioni all'istante t=i-1, in una matrice nNxnC; ciò è
    % agevole per definire tutte le funzioni necessarie al
    % modello di Smoluchoswki

        % Condizioni iniziali
    iNI = sCI.seme;    % Indici dei nodi infetti
    ka = zeros(nN,1);  % Tasso di nucleazione
    ka(iNI) = sCI.ka0; % Inizializzazione

        % Tassi
    aC = sPM.a;  % Di aggregrazione
    fC = sPM.f;  % Di frammentazione
    k0 = sPM.k0; % Di produzione sana 

        % Valore temporale dei tassi di depurazione
    condDeD = sPT.CondDeD;
    if(condDeD == 0) % Se i tassi di depurazioni non sono dinamici
        k1 = @(t) sPM.k1; % Di depurazione sana
        k2 = @(t) sPM.k2; % Di depurazione malata
        kn = @(t) sPM.kn; % Di depurazione dell'ultima catena
    else % Se altrimenti lo è si dà la relativa legge di decadimento fd
        tipoDeD = sPT.TipoDeD;
        switch tipoDeD
            case 1 % Iperbolica
                a  = 20;
                fd = @(t) 1./(1+t./a);
            case 2 % Esponenziale 
                a  = 20;
                fd = @(t) exp(-t./a);
            case 3 % Gaussiana
                g  = @(t,N,m,s) N*exp(-((t-m).^2)/s);
                fd = @(t) g(t,1.5,5,60)+g(t,0.7,19,50)+g(t,0.1,40,600);
        end
        k1 = @(t) sPM.k1*fd(t); % Di depurazione sana
        k2 = @(t) sPM.k2*fd(t); % Di depurazione malata
        kn = @(t) sPM.kn*fd(t); % Di depurazione dell'ultima catena
    end
    
        % Dinamicità della laplaciana
    d = sPM.dim;
    eta = 0.5*d;
        % Se si considera la dimensione η=0.5 altrimenti è nulla

        % Inizializzazione della celle per i manici delle funzioni
    fc = cell(nC,1);

        % Definizione del sistema dinamico di Smoluchowski
    fc{1} = @(c,t) ( ...
                   - L(t)*c(:,1)  ...
                   + k0  ...
                   - k1(t).*c(:,1) ...
                   - 2*ka.*(c(:,1).^2) ...
                   - aC*c(:,1).*sum(c(:,2:nC-1),2) ...
                   );

    fc{2} = @(c,t) ( ...
                   - 2^(-eta)*L(t)*c(:,2) ...
                   - k2(t).*c(:,2)/(2^d) ...
                   + ka.*(c(:,1).^2) ...
                   - aC*c(:,1).*c(:,2) ...
                   + fC*sum(c(:,4:nC-1),2) ...
                   );

    for i = 3:nC-1 % Per tutte le catene malate

        if(i+2 <= nC-1)
            % Si definisce la relativa funzione dinamica notando
            % che se i+2>nC-1 non esistono catene che possono
            % contribuire a ci frammentandosi
            fc{i} = @(c,t) ( ...
                           - i^(-eta)*L(t)*c(:,i) ...
                           - k2(t).*c(:,i)/(i^d) ...
                           + aC*c(:,1).*c(:,i-1) ...
                           - aC*c(:,1).*c(:,i) ...
                           + fC*sum(c(:,i+2:nC-1),2) ...
                           - fC*c(:,i)*(i-3)/2 ...
                           );
        else
            % Si definisce la relativa funzione dinamica notando
            % che se i+2>nC-1 non esistono catene che possono
            % contribuire a ci frammentandosi
            fc{i} = @(c,t) ( ...
                           - i^(-eta)*L(t)*c(:,i) ...
                           - k2(t).*c(:,i)/(i^d) ...
                           + aC*c(:,1).*c(:,i-1) ...
                           - aC*c(:,1).*c(:,i) ...
                           - fC*c(:,i)*(i-3)/2 ...
                           );
        end
    end

    fc{nC} = @(c,t) ( ...
                    - nC^(-eta)*L(t)*c(:,nC) ...
                    - kn(t).*c(:,nC)/(nC^d) ...
                    + aC*c(:,1).*c(:,nC-1) ...
                    );

    function c = Concatena_Risultati(c,t)
        cR = reshape(c,nN,nC);
        cC = cellfun(@(fa)fa(cR,t),fc,'UniformOutput',false);
        c = vertcat(cC{:});
    end

    f = @Concatena_Risultati;
    

    % Vecchio codice che in essenza definiva lo stesso sistema di prima ma
    % ricorsivamente mediante la concatenazione di manici di funzioni in un
    % vettore; questo processo è meno ottimizzato rispetto all'uso di una
    % cella precedente e porta ad avere tempi di simulazione maggiori special-
    % mente qualora il numero delle catene fosse elevato (200 anziché 50)
    %
    %     % Inizializzazione funzioni
    % fc1 = @(c,t) - L(t)*c(:,1)  ...
    %              + k0  ...
    %              - k1.*c(:,1) ...
    %              - 2*ka.*(c(:,1).^2) ...
    %              - aC*c(:,1).*sum(c(:,2:nC-1),2);
    % f = @(c,t) fc1(c,t); % reshape(c,nN,nC)
    % 
    % fc2 = @(c,t) - 2^(-eta)*L(t)*c(:,2) ...
    %              - k2.*c(:,2)/(2^d) ...
    %              + ka.*(c(:,1).^2) ...
    %              - aC*c(:,1).*c(:,2) ...
    %              + fC*sum(c(:,4:nC-1),2);
    % f = @(c,t) [f(c,t)     % reshape(c,nN,nC)
    %             fc2(c,t)]; % reshape(c,nN,nC)
    % 
    % for i = 3:nC-1 % Per tutte le catene malate
    % 
    %     if(i+2 <= nC-1)
    %         % Si definisce la relativa funzione dinamica notando
    %         % che se i+2>nC-1 non esistono catene che possono
    %         % contribuire a ci frammentandosi
    %         fci = @(c,t) - i^(-eta)*L(t)*c(:,i) ...
    %                      - k2.*c(:,i)/(i^d) ...
    %                      + aC*c(:,1).*c(:,i-1) ...
    %                      - aC*c(:,1).*c(:,i) ...
    %                      + fC*sum(c(:,i+2:nC-1),2) ...
    %                      - fC*c(:,i)*(i-3)/2;
    % 
    %             % La si accoda alla funzione complessiva
    %         f = @(c,t) [f(c,t)     % reshape(c,nN,nC)
    %                     fci(c,t)]; % reshape(c,nN,nC)
    %     else
    %         % Si definisce la relativa funzione dinamica notando
    %         % che se i+2>nC-1 non esistono catene che possono
    %         % contribuire a ci frammentandosi
    %         fci = @(c,t) - i^(-eta)*L(t)*c(:,i) ...
    %                      - k2.*c(:,i)/(i^d) ...
    %                      + aC*c(:,1).*c(:,i-1) ...
    %                      - aC*c(:,1).*c(:,i) ...
    %                      - fC*c(:,i)*(i-3)/2;
    % 
    %             % La si accoda alla funzione complessiva
    %         f = @(c,t) [f(c,t)     % reshape(c,nN,nC)
    %                     fci(c,t)]; % reshape(c,nN,nC)
    %     end
    % end
    % 
    % fcn = @(c,t) - nC^(-eta)*L(t)*c(:,nC) ...
    %              - kn.*c(:,nC)/(nC^d) ...
    %              + aC*c(:,1).*c(:,nC-1);
    % f = @(c,t) [f(reshape(c,nN,nC),t)
    %             fcn(reshape(c,nN,nC),t)];

end

    % Metodi di avanzamento in tempo
function Eulero_Esplicito(sPT,f)

    % implementazione Eulero esplicito per una EDO y'=f(t,y) e CI y(t_0)=y0;
    % lo schema (y(t+dt)-y(t))/dt=f(t,y(t)) che porta alla formula
    % y^(k+1)-y^k-dt*f(t^k,y^(k+1))=0 ponendo y^k~y(t_k) e CI y(t0)=y0

    global c

    dt = sPT.dt;   % Passo temporale
    nt = sPT.nt;   % Numero totale di dt
    ns = sPT.ns;   % Numero d'istanti salvati

    it = sPT.it;   % Vettore dei passi temporali
    is = sPT.is;   % Vettore dei passi salvati
    eps = sPT.eps; % Fattore di riscalamento temporlae

        % implementazione
    tic
    if(sPT.contrTemp == 1)

        for s = 1:ns
            disp(append("Metodo esplicito [",string(round(s/ns,4)*100),"%] - iterazione ",string(s)," su ",string(ns)))
            c(:,s+1) = c(:,s) + dt*f(c(:,s),it(is(s)))./eps;
            clc
        end % In c(:,s+1) si somma uno al tempo s perché la prima colonna coincide colla condizione iniziale

    else % Se non si contrae temporalmente

        if(nt == ns) % Se si salvano tutti gl'istanti
            for n = 1:nt
                disp(append("Metodo esplicito [",string(round(n/nt,4)*100),"%] - iterazione ",string(n)," su ",string(nt)))
                c(:,n+1) = c(:,n) + dt*f(c(:,n),it(n))./eps;
                clc
            end % Si somma uno al tempo perché la prima colonna coincide colla condizione iniziale
        else % Altrimenti si capionano solo una parte        
            cp = c(:,1);
            is = sPT.is; % Vettore dei passi salvati
            ci = 1;      % Contatore degl'istanti salvati
    
            for n = 1:nt
                disp(append("Metodo esplicito [",string(round(n/nt,4)*100),"%] - iterazione ",string(n)," su ",string(nt)))
                cs = cp + dt*f(cp,it(n))./eps;
    
                if(ismember(n+1,is))
                    ci = ci+1;
                    c(:,ci) = cs;
                end
    
                cp = cs;
                clc
            end
        end % nt == ns

    end % sPT.contrTemp
    toc

    % Senza contrazione temporale l'integrazione del sistema dinamico si
    % attuava simulando tutti i passi temporali, salvandone eventualmente
    % un numero minore a cui si era interessati [per questioni di memoria].
    % Con riscalamento temporale, invece, si simulano solo quelli a cui si
    % è interessati richiedendo cioè molto meno tempo.
    %
    % Per es. per riprodurre i risultati di «Goriely 2019 Networks II
    % {19-12-2024}.pdf» erano necessari 3 milioni di passi per un
    % totale di quasi 6 ore di simulazione; ora ne sono necessari sono
    % 5000 per un totale di un minuto di simulazione, ottenendo però
    % gli stessi risultati qualitativamente/graficamente
    %
    % Ovviamente la risoluzione non è la stessa perché si salvano solo
    % 5000 passi anziché 3 milioni ma in questo tipo di simulazione non
    % è ciò che importa: come già detto si vuole solo sapere il
    % comportamento asintotico e qualitativamente quello transitorio
    %
    % Inoltre v'è il problema che se i passi riscalati ns sono troppo pochi
    % allora l'integrazione risulta instabile e non converge. Ad es.
    % «Goriely 2019 Networks II {19-12-2024}.pdf» non funziona se si
    % considerano ns=1000 passi riscalati a prescindere dalla dimensione
    % del passo temporale dt considerato: sono troppi pochi passi.
    % 
    % Per fortuna però questo sembra essere un problema limitato e già con
    % ns=5000 il riscalamento funziona anche se temo che aumentando il
    % periodo di simulazione anche quei passi sarebbero troppo pochi.
    % Pertanto, nonostante dubiti mi serva un periodo maggiore di 120000,
    % ho deciso di reintrodurre il vecchio codice come opzione possibile
    % seppure piú lenta, che però funziona sempre indipendentemente dalla
    % lunghezza del periodo.

end

function Eulero_Implicito(sPT,f)

    % Implementazione Eulero implicito per una EDO y'=f(t,y) e CI y(t_0)=y0;
    % lo schema (y(t+dt)-y(t))/dt=f(t,y(t+dt)) che porta alla formula
    % y^(k+1)-y^k-dt*f(t^k+1,y^(k+1))=0 ponendo y^k~y(t_k) e CI y(t_0)=y0

    global c

    dt = sPT.dt; % Passo temporale
    nt = sPT.nt; % Numero totale di dt
    ns = sPT.ns; % Numero d'istanti salvati

    it = sPT.it; % Vettore dei passi
    is = sPT.is; % Vettore dei passi salvati
    eps = sPT.eps; % Fattore di riscalamento temporlae

        % implementazione
    tic
    if(sPT.contrTemp == 1)

        for s = 1:ns
            disp(append("Metodo implicito [",string(round(s/ns,4)*100),"%] - iterazione ",string(s)," su ",string(ns)))
    
            fImp = @(cc) cc-c(:,s)-dt*f(cc,it(is(s)))./eps;
            % opzioni = optimoptions('fsolve','Diagnostics','on','PlotFcn',@optimplotfirstorderopt);
            c(:,s+1) = fsolve(fImp,c(:,s));
    
            clc
        end % In c(:,s+1) si somma uno al tempo s perché la prima colonna coincide colla condizione iniziale

    else % Se non si riscala temporalmente

        if(nt == ns) % Se si salvano tutti gl'istanti
            for n = 1:nt
                disp(append("Metodo implicito [",string(round(n/nt,4)*100),"%] - iterazione ",string(n)," su ",string(nt)))
    
                fImp = @(cc) cc-c(:,n)-dt*f(cc,it(n))./eps;
                % opzioni = optimoptions('fsolve','Diagnostics','on','PlotFcn',@optimplotfirstorderopt);
                c(:,n+1) = fsolve(fImp,c(:,n));
    
                clc
            end % Si somma uno al tempo perché la prima colonna coincide colla condizione iniziale
        else % Altrimenti si capionano solo una parte
            cp = c(:,1);
            is = sPT.is; % Vettore dei passi salvati
            ci = 1;      % Contatore degl'istanti salvati
    
            for n = 1:nt
                disp(append("Metodo implicito [",string(round(n/nt,4)*100),"%] - iterazione ",string(n)," su ",string(nt)))
    
                fImp = @(cc) cc-cp-dt*f(cc,it(n))./eps;
                % opzioni = optimoptions('fsolve','Diagnostics','on','PlotFcn',@optimplotfirstorderopt);
                cs = fsolve(fImp,cp);
    
                if(ismember(n+1,is))
                    ci = ci+1;
                    c(:,ci) = cs;
                end
    
                cp = cs;
                clc
            end
        end % nt == ns
        
    end % sPT.contrTemp
    toc

    % Senza riscalamento temporale l'integrazione del sistema dinamico si
    % attuava simulando tutti i passi temporali, salvandone eventualmente
    % un numero minore a cui si era interessati [per questioni di memoria].
    % Con riscalamento temporale, invece, si simulano solo quelli a cui si
    % è interessati richiedendo cioè molto meno tempo.
    %
    % Per es. per riprodurre i risultati di «Goriely 2019 Networks II
    % {19-12-2024}.pdf» erano necessari 3 milioni di passi per un
    % totale di quasi 6 ore di simulazione; ora ne sono necessari sono
    % 5000 per un totale di un minuto di simulazione, ottenendo però
    % gli stessi risultati qualitativamente/graficamente
    %
    % Ovviamente la risoluzione non è la stessa perché si salvano solo
    % 5000 passi anziché 3 milioni ma in questo tipo di simulazione non
    % è ciò che importa: come già detto si vuole solo sapere il
    % comportamento asintotico e qualitativamente quello transitorio
    %
    % Inoltre v'è il problema che se i passi riscalati ns sono troppo pochi
    % allora l'integrazione risulta instabile e non converge. Ad es.
    % «Goriely 2019 Networks II {19-12-2024}.pdf» non funziona se si
    % considerano ns=1000 passi riscalati a prescindere dalla dimensione
    % del passo temporale dt considerato: sono troppi pochi passi.
    % 
    % Per fortuna però questo sembra essere un problema limitato e già con
    % ns=5000 il riscalamento funziona anche se temo che aumentando il
    % periodo di simulazione anche quei passi sarebbero troppo pochi.
    % Pertanto, nonostante dubiti mi serva un periodo maggiore di 120000,
    % ho deciso di reintrodurre il vecchio codice come opzione possibile
    % seppure piú lenta, che però funziona sempre indipendentemente dalla
    % lunghezza del periodo.

end

    % Concentrazioni prioni
function Estrai_Concentrazioni_Prioni(sPM,sPT)

    global c cP

    nN = sPM.nN; % Numero totale di nodi
    ns = sPT.ns; % Numero totale di passi temporali dt salvati
    nC = sPM.nC; % Numero totale di catene 

    % La c è la concetrazione di tutte le proteine, sane e no,
    % mentre la cP è la concentrazione di quelle solo malate

    switch sPM.modello
        
        case "FK"  % FK
            cP = c;

        case "ED"  % ED
            cP = reshape(c,nN,2,ns+1);

        case "SMO" % SMO
            cP = reshape(c,nN,nC,ns+1);

    end

end


%%%%%%%%%%%%%%%%%%%%%%%
%%% Codice scartato %%%
%%%%%%%%%%%%%%%%%%%%%%%

    % Qui di séguito è illustrato un codice per costruire la funzione f
    % del sistema di Smoluchowski mediante matrici anziché funzioni
    % ricorsive come nel codice principale scritto in principio.
    % 
    % Tuttavia quello che ho notato, contrariamente alle mie aspettative, è
    % che MATLAB impiega piú tempo proprio colle matrici che ricorsivamente
    % (con 50 catene impiega 2 secondi col primo e 4 minuti col secondo).
    % 
    % In aggiunta la dinamica che ne esce è anche diversa: col sistema
    % ricorsivo in una situazione s'infettano solo due nodi e col sistema
    % matriciale tutto il cervello viene infettato; è probabile che sia
    % dovuto a una mal definizione di qualche matrice seppure non saprei
    % dire esattamente quale, ma vale comunque la pena di ricontrollare il
    % sistema ricorsivo giusto per essere certi che tutto torni.

% % Pezzo inserito nella funzione «Funzione_SMO»
%     Crea_Maschere_Smoluchowski(sPM,sCI)
% 
%     global Di P De N Ag Ap Fg Fp
% 
%     fdi = @(c,t) -Di(t)*c;
%     fde = @(c) -De*c;
%     fn  = @(c) N*(c.^2);
%     fag = @(c) Ag(c(1:nN))*c;
%     fap = @(c) -Ap(c(1:nN))*c;
%     ffg = @(c) Fg*c;
%     ffp = @(c) -Fp*c;
%     f = @(c,t) fdi(c,t)+P+fde(c)+fn(c)+fag(c)+fap(c)+ffg(c)+ffp(c);
%     % f = @(c,t) -Di(t)*c+P-De*c+N*(c.^2)+Ag(c(1:nN))*c-Ap(c(1:nN))*c+Fg*c-Fp*c;

% function Crea_Maschere_Smoluchowski(sPM,sCI)
%         % Maschere del sistema dinamico di Smoluchowski
%
%         % Matrice da usare
%     global L
% 
%         % Matrici da creare
%     global Di P De N Ag Ap Fg Fp
% 
%     nN  = sPM.nN;      % Numero totale di nodi
%     nC  = sPM.nC;      % Numero di catene totali
% 
%         % Matrice di diffusione
%     eta = 0.5*sPM.dim; % Se si considera la dimensione η=0.5 altrimenti è nulla
%     if(sPM.dim == 0) % Se la L è statica
%         ML = Concatena_Matrici_Diagonale(L(0),nC,eta);
%         Di = @(t) sparse(ML);
%     else % Altrimenti se è dinamica
%         Di = @(t) sparse(Concatena_Matrici_Diagonale(L(t),nC,eta));
%     end
% 
% 
%         % Matrice di produzione
%     k0 = sPM.k0; % Tasso di produzione sana
%     P = [k0*ones(1,nN) zeros(1,(nC-1)*nN)]';
% 
% 
%         % Matrice di depurazione
%     k1 = sPM.k1; % Tasso di depurazione sana
%     k2 = sPM.k2; % Tasso di depurazione malato
%     kn = sPM.kn; % Tasso di depurazione dell'ultima catena
%     De = sparse(diag([k1*ones(1,nN) k2*ones(1,(nC-2)*nN) kn*zeros(1,nN)]));
% 
% 
%         % Matrice di nucleazione
%     N = zeros(nC*nN,nC*nN);
% 
%     iNI = sCI.seme; % Indici dei nodi infetti
%     ka  = sCI.ka0;  % Tasso di nucleazione
% 
%     kC1 = zeros(1,nN); % Nucleazione della prima catena
%     kC1(iNI) = -2*ka;  % Perdita per nucleazione
%     N(1:nN,1:nN) = diag(kC1);
% 
%     kC2 = zeros(1,nN); % Nucleazione della seconda catena
%     kC2(iNI) = ka;     % Guadagno per nucleazione
%     N((1:nN)+nN,1:nN) = diag(kC2);
%     N = sparse(N);
% 
% 
% 
%         % Matrice di guadagno e di perdita per aggregazione
%     aC = sPM.a; % Tasso di aggregrazionee frammentazione
%     Ag = @(c) sparse(aC*Concatena_Vettori_Aggregazione_Guadagno(c,nN,nC));
%     Ap = @(c) sparse(aC*Concatena_Vettori_Aggregazione_Perdita(c,nN,nC));
% 
% 
%         % Matrice di guadagno e di perdita per frammentazione
%     fC = sPM.f;
% 
%     Fg = zeros(nN*nC,nN*nC);
%     for i=2:nC-3
%         Fg((1:nN)+nN*(i-1),3*nN+1+nN*(i-2):nN*(nC-1)) = repmat(eye(nN,nN),1,nC-i-2);
%     end % Catene che ricevono contributi dalla frammentazione
%     Fg = sparse(2*fC*Fg);
% 
%     Fp = zeros(nN*nC,nN*nC);
%     for i=4:nC-1
%         Fp((1:nN)+nN*(i-1),(1:nN)+nN*(i-1)) = eye(nN,nN)*(i-3);
%     end % Catene che perdono contributi dalla frammentazione
%     Fp = sparse((fC/2)*Fp);
% 
% end

% function T = Concatena_Matrici_Diagonale(M,nC,eta)
% 
%         % Cella con nC copie di M
%     T = repmat({M},1,nC);
% 
%     if(eta ~= 0)
%         for i=2:nC
%             T{i} = i^(-eta)*T{i};
%         end % Ridefinizione delle matrici in T
%     end
% 
%         % Concatenazione degli elementi di T in una matrice a blocchi diagonale
%     T = blkdiag(T{:});
% 
%     % blkdiag(T{:}) è equivalente a scrivere blkdiag(T{1},T{2},...,T{nC})
%     % ma dinamicamente, evitando cioè di definire da una parte un estremo
%     % mediante un ciclo «for» e di usare dall'altra la ricorsività che
%     % risulta molto pesante da gestire; il tutto in una riga di codice
% 
% end

% function Ag = Concatena_Vettori_Aggregazione_Guadagno(c,nN,nC)
% 
%         % Cella con nC-2 copie di diag(c)
%     Tg = repmat({diag(c)},1,nC-2);
% 
%         % Matrice di guadagno per aggregazione
%     Ag = zeros(nN*nC,nN*nC);
%     Ag(2*nN+1:end,nN+1:(nC-1)*nN) = blkdiag(Tg{:});
% 
%     % blkdiag(T{:}) è equivalente a scrivere blkdiag(T{1},T{2},...,T{nC})
%     % ma dinamicamente, evitando cioè di definire da una parte un estremo
%     % mediante un ciclo «for» e di usare dall'altra la ricorsività che
%     % risulta molto pesante da gestire; il tutto in una riga di codice
% 
% end

% function Ap = Concatena_Vettori_Aggregazione_Perdita(c,nN,nC)
% 
%         % Cella con nC-1 copie di diag(c)
%     Tp = repmat({diag(c)},1,nC-2);
% 
%         % Matrice di perdita per aggregazione
%     Ap = zeros(nN*nC,nN*nC);
%     Ap(1:nN,nN+1:end) = repmat(diag(c),1,nC-1);
%     Ap(nN+1:(nC-1)*nN,nN+1:(nC-1)*nN) = blkdiag(Tp{:});
% 
%     % blkdiag(T{:}) è equivalente a scrivere blkdiag(T{1},T{2},...,T{nC})
%     % ma dinamicamente, evitando cioè di definire da una parte un estremo
%     % mediante un ciclo «for» e di usare dall'altra la ricorsività che
%     % risulta molto pesante da gestire; il tutto in una riga di codice
% 
% end


    % Funzione «Eulero_Esplicito» per salvare i dati all'interno di una filza H5F
    % 
    % È stata scartata perché mentre cercavo un modo di diminuire la sua
    % dimensione, mi sono reso conto che potevo sottocampionare gl'istanti
    % di tempo anziché memorizzarli tutti.
    % 
    % Dunque si può ragionare come si è sempre fatto, senza creare nulla di
    % nuovo, ma con un numero minore d'istante scelto nell'interfaccia grafica

% dt = sPT.dt; % Passo temporale
% nt = sPT.nt; % Numero totale di dt
% 
% nN = sPM.nN; % Di nodi
% nC = sPM.nC; % Di catene
% 
%     % Nome della filza
% filza = 'D:/Valerio/Momentaneo/Dati_Simulazione.h5';
% 
%     % Eliminazione nel caso esistesse
% if(exist(filza,'file') == 2)
%     delete(filza);
% end
% 
%     % Istanti salvati per visualizzare i risultati
% nI = 1000; % Numero d'istanti salvati
% nS = round(linspace(1,nt+1,nI));
% 
%     % Creazione della filza H5F per il salvataggio di dati
% h5create(filza,'/Tempi',[nI,1],'Datatype','single', ...
%          'ChunkSize',[1,1],'Deflate',0,'Shuffle',1);
% h5create(filza,'/Concentrazioni',[nI nC*nN],'Datatype','single', ...
%          'ChunkSize',[1 nC*nN],'Deflate',9,'Shuffle',1);
% 
% h5write(filza,'/Tempi',(nS-1)'*dt);
% h5write(filza,'/Concentrazioni',c(:,1)',[1 1],[1 nC*nN]);
% 
% for n = 1:nt
%     disp(append("Metodo esplicito [",string(round(n/nt,4)*100),"%] - iterazione ",string(n)," su ",string(nt)))
%     c(:,2) = c(:,1) + dt*f(c(:,1),(n-1)*dt);
% 
%     if(ismember(n+1,nS))
%         h5write(filza,'/Concentrazioni',c(:,2)',[find(n+1==nS) 1],[1 nC*nN]);
%     end % Si salvano solo nS istanti equispaziati
% 
%     c(:,1) = c(:,2);
%     clc
% end % Si somma uno al tempo perché la prima colonna coincide colla condizione iniziale