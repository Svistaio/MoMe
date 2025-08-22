function  [soglia,nLati,nNodiMacro] = Mappa_MacroRegioni(sPL)

    % In funzione si mappa il grafo originale [di dimensione elevata] in uno
    % di dimensione ridotta aggruppando tutti i nodi nella medesima macroregione
    % in un unico nodo; cosí facendo anche i lati sono da modificare in modo
    % tale che collassino, tra due regioni distinte in un unico lato

    global sML Lg tabGrafo Dg

    percorso = sPL.percorso; p = sPL.PCT; preProc = sPL.PreProc;

    if(sPL.TipoL == 2) % Se la laplaciana si costruisce si procedere

        if(preProc ~= 4) % Se il preprocessamento non considera le fibre e le lunghezze separatamente
    
                % Estrazione tabella readtable("../Dati/BCT3_418_ElecticalConnectivity_mean.csv")
            tabGrafo = readtable(percorso);              % Lettura tabella nella filza «csv»
        
            numCT  = table2array(tabGrafo(:,9)); % Numero di connettomi condividenti i lati
            nCT    = max(numCT);                 % Numero di connettomi considerati (https://it.wikipedia.org/wiki/Connettoma)
            soglia = p*nCT/100;                  % Soglia nel numero di connetomi minimo per considerare il lato all'interno del grafo
        
            pesi  = table2array(tabGrafo(:,10)); % Pesi di ogni lato
        
        
                    %%% Costruzione della matrice d'adiacenza, dei gradi e laplaciana del grafo originale %%%
        
                % Estrazione dati dei lati delle microregioni e della macroregioni
            latiMicro  = table2array(tabGrafo(:,[1 2]));
            nNodiMicro = max(latiMicro(:,1)); % Numero di microregioni (1015), ossia di nodi del grafo originale
            Ag = zeros(nNodiMicro,nNodiMicro);
        
            for l = 1:size(latiMicro,1)
                rN = latiMicro(l,1);
                cN = latiMicro(l,2);
                if(rN == cN)
                    Ag(rN,cN) = Ag(rN,cN) + pesi(l);
                else
                    Ag(rN,cN) = Ag(rN,cN) + pesi(l);
                    Ag(cN,rN) = Ag(cN,rN) + pesi(l);
                end
            end
            Gg = diag(sum(Ag,2));
            Lg = Gg - Ag;
            % Lg = diag(sum(Gg,2).^(-1/2))*Lg*diag(sum(Gg,2).^(-1/2));
            % Lg = eye(1015,1015) - Gg^(-1/2)*Ag*Gg^(-1/2);
            % imagesc(Lg); axis xy; colorbar;
            % Dg = sum(Dg,2);
        
            [Vg,Dg] = eig(Lg);
            Lg = Vg(:,1:83)'*Dg*Vg(:,1:83);
        
            % vRS = zeros(83,2); % Vettore degl'indici dei rappresentanti spettrali 
            % latiMacro  = table2array(tabGrafo(:,[5 6]));
            % 
            % for r = 1:size(latiMacro,1)
            %     for i = 1:2
            %         iMi = latiMicro(r,i);
            %         iMa = latiMacro(r,i);
            %         if(Dg(iMi)>vRS(iMa,2))
            %             vRS(iMa,1) = iMi;
            %             vRS(iMa,2) = Dg(iMi);
            %         end
            %     end
            % end
        
        
                    %%% Costruzione della matrice d'adiacenza, dei gradi e laplaciana del grafo ridotto secondo diverse regole %%%
        
                % Struttura per registrare la mappatura [o proiezione] dei lati rispetto alle sole macroregioni
            sML  = [];
            nLati = 0;
        
                % Estrazione dati dei lati delle microregioni e della macroregioni
            latiMacro  = table2array(tabGrafo(:,[5 6]));
            nNodiMacro = max(latiMacro(:,1)); % Numero di macroregioni (83), ossia di nodi del grafo ridotto
        
                % Estrazione e elaborazione dei nomi delle macroregioni cosicché siano dei nomi ammissibili per i campi 
            nomiR = string(table2array(tabGrafo(:,[7 8]))); % Nome di ogni macroregione
            nomiR = strrep(nomiR,'.','_'); % Rinominazione dei nomi dei campi al fine d'eliminare i caratteri non permessi come nomi di campi in una struttura
            nomiR = strrep(nomiR,'-','_'); % Questo è utile non in questa funzione ma in «AssemblaMatrici»
        
                % Vettori per i nomi dei campi aventi come struttura «N» + «Indice del nodo»
            campiN1 = strrep(string(num2str(latiMacro(:,1))),' ','');
            campiN1 = strcat('N',campiN1);
            campiN2 = strrep(string(num2str(latiMacro(:,2))),' ','');
            campiN2 = strcat('N',campiN2);
        
                % Costruzione della struttura caratterizzante i lati e i pesi tra regioni
            for l = 1:length(campiN1)
                if(campiN1(l)~=campiN2(l)) % Se i due nodi sono distinti
                    if(isfield(sML,campiN1(l)))  % Se il primo nodo è un campo
                        if(isfield(sML.(campiN1(l)),campiN2(l))) % Se il secondo nodo è un campo
                            switch preProc
                                case 1 % SL: aggiornamento del lato sommando i pesi linearmente
                                    sML.(campiN1(l)).(campiN2(l)).Peso = sML.(campiN1(l)).(campiN2(l)).Peso + pesi(l);
                                case 2 % Max: aggiornamento del lato massimizando il peso
                                    sML.(campiN1(l)).(campiN2(l)).Peso = max([sML.(campiN1(l)).(campiN2(l)).Peso,pesi(l)]);
                                case 3 % SP: aggiornamento del lato sommando i pesi e dividendo per il numero totale
                                    N = sML.(campiN1(l)).(campiN2(l)).LatiMap;
                                    sML.(campiN1(l)).(campiN2(l)).Peso = (N*sML.(campiN1(l)).(campiN2(l)).Peso + pesi(l))/(N+1);
                            end
                            sML.(campiN1(l)).(campiN2(l)).LatiMap = sML.(campiN1(l)).(campiN2(l)).LatiMap + 1;      % Aggiornamento lati collassati
                        else % Creazione lato aggiunto
                            sML.(campiN1(l)).(campiN2(l)).Peso       = pesi(l);      % Peso associato al lato
                            sML.(campiN1(l)).(campiN2(l)).IndiceN1   = latiMacro(l,1);    % Indice del primo nodo
                            sML.(campiN1(l)).(campiN2(l)).MacroRegN1 = nomiR(l,1);   % Macroregione del primo nodo
                            sML.(campiN1(l)).(campiN2(l)).IndiceN2   = latiMacro(l,2);    % Indice del secondo nodo
                            sML.(campiN1(l)).(campiN2(l)).MacroRegN2 = nomiR(l,2);   % Macroregione del secondo nodo
                            sML.(campiN1(l)).(campiN2(l)).NumeroCT   = numCT(l);     % Numero di connettomi condivisi dal lato
                            sML.(campiN1(l)).(campiN2(l)).LatiMap    = 1;            % Numero di lati tra microregioni collassati nel lato macroscopico
                            nLati = nLati + 1;
                        end
                    else     % Creazione lato dal nulla
                        sML.(campiN1(l)).(campiN2(l)).Peso       = pesi(l);      % Peso associato al lato
                        sML.(campiN1(l)).(campiN2(l)).IndiceN1   = latiMacro(l,1);    % Indice del primo nodo
                        sML.(campiN1(l)).(campiN2(l)).MacroRegN1 = nomiR(l,1);   % Macroregione del primo nodo
                        sML.(campiN1(l)).(campiN2(l)).IndiceN2   = latiMacro(l,2);    % Indice del secondo nodo
                        sML.(campiN1(l)).(campiN2(l)).MacroRegN2 = nomiR(l,2);   % Macroregione del secondo nodo
                        sML.(campiN1(l)).(campiN2(l)).NumeroCT   = numCT(l);     % Numero di connettomi condivisi dal lato
                        sML.(campiN1(l)).(campiN2(l)).LatiMap    = 1;            % Numero di lati tra microregioni collassati nel lato macroscopico
                        nLati = nLati + 1;
                    end
        
                        % Questa logica presuppone che la matrice in cui sono memorizzati i lati
                        % («lati = table2array(tabGrafo(:,[1 2])») sia 2xNlati ove ogni riga
                        % è una coppia univoca d'indici dei nodi costituenti un lato.
                end % Solo escludendo i autoarchi si ottengono esattamente 1130, altrimenti se ne hanno 1211
            end
    
        else % Altrimenti si considerano separatamente
    
                % Estrazione tabella readtable("../Dati/BCT3_418_ElecticalConnectivity_mean.csv")
            tabGrafoF = readtable(percorso(1)); % Lettura tabella delle fibre nella rispettiva filza «csv»
            tabGrafoL = readtable(percorso(2)); % Lettura tabella delle lunghezze nella rispettiva filza «csv»
        
            pesiF  = table2array(tabGrafoF(:,10)); % Pesi di ogni lato
            pesiL  = table2array(tabGrafoL(:,10)); % Pesi di ogni lato
    
            numCT  = table2array(tabGrafoF(:,9)); % Numero di connettomi condividenti i lati
            nCT    = max(numCT);                 % Numero di connettomi considerati (https://it.wikipedia.org/wiki/Connettoma)
            soglia = p*nCT/100;                  % Soglia nel numero di connetomi minimo per considerare il lato all'interno del grafo
        
        
                    %%% Costruzione della matrice d'adiacenza, dei gradi e laplaciana del grafo originale %%%
        
                % Estrazione dati dei lati delle microregioni e della macroregioni
            % latiMicro  = table2array(tabGrafoF(:,[1 2]));
            % nNodiMicro = max(latiMicro(:,1)); % Numero di microregioni (1015), ossia di nodi del grafo originale
            % Ag = zeros(nNodiMicro,nNodiMicro);
            % 
            % for l = 1:size(latiMicro,1)
            %     rN = latiMicro(l,1);
            %     cN = latiMicro(l,2);
            %     if(rN == cN)
            %         Ag(rN,cN) = Ag(rN,cN) + pesi(l);
            %     else
            %         Ag(rN,cN) = Ag(rN,cN) + pesi(l);
            %         Ag(cN,rN) = Ag(cN,rN) + pesi(l);
            %     end
            % end
            % Gg = diag(sum(Ag,2));
            % Lg = Gg - Ag;
            % Lg = diag(sum(Gg,2).^(-1/2))*Lg*diag(sum(Gg,2).^(-1/2));
            % Lg = eye(1015,1015) - Gg^(-1/2)*Ag*Gg^(-1/2);
            % imagesc(Lg); axis xy; colorbar;
            % Dg = sum(Dg,2);
        
            % [Vg,Dg] = eig(Lg);
            % Lg = Vg(:,1:83)'*Dg*Vg(:,1:83);
        
            % vRS = zeros(83,2); % Vettore degl'indici dei rappresentanti spettrali 
            % latiMacro  = table2array(tabGrafoF(:,[5 6]));
            % 
            % for r = 1:size(latiMacro,1)
            %     for i = 1:2
            %         iMi = latiMicro(r,i);
            %         iMa = latiMacro(r,i);
            %         if(Dg(iMi)>vRS(iMa,2))
            %             vRS(iMa,1) = iMi;
            %             vRS(iMa,2) = Dg(iMi);
            %         end
            %     end
            % end
        
        
                    %%% Costruzione della matrice d'adiacenza, dei gradi e laplaciana del grafo ridotto secondo diverse regole %%%
        
                % Struttura per registrare la mappatura [o proiezione] dei lati rispetto alle sole macroregioni
            sML  = [];
            nLati = 0;
        
                % Estrazione dati dei lati delle microregioni e della macroregioni
            latiMacro  = table2array(tabGrafoF(:,[5 6]));
            nNodiMacro = max(latiMacro(:,1)); % Numero di macroregioni (83), ossia di nodi del grafo ridotto
        
                % Estrazione e elaborazione dei nomi delle macroregioni cosicché siano dei nomi ammissibili per i campi 
            nomiR = string(table2array(tabGrafoF(:,[7 8]))); % Nome di ogni macroregione
            nomiR = strrep(nomiR,'.','_'); % Rinominazione dei nomi dei campi al fine d'eliminare i caratteri non permessi come nomi di campi in una struttura
            nomiR = strrep(nomiR,'-','_'); % Questo è utile non in questa funzione ma in «AssemblaMatrici»
        
                % Vettori per i nomi dei campi aventi come struttura «N» + «Indice del nodo»
            campiN1 = strrep(string(num2str(latiMacro(:,1))),' ','');
            campiN1 = strcat('N',campiN1);
            campiN2 = strrep(string(num2str(latiMacro(:,2))),' ','');
            campiN2 = strcat('N',campiN2);
        
                % Costruzione della struttura caratterizzante i lati e i pesi tra regioni
            for l = 1:length(campiN1)
                % if(campiN1(l)~=campiN2(l)) % Se i due nodi sono distinti
                    if(isfield(sML,campiN1(l)))  % Se il primo nodo è un campo
                        if(isfield(sML.(campiN1(l)),campiN2(l))) % Se il secondo nodo è un campo
                            sML.(campiN1(l)).(campiN2(l)).PesoL = sML.(campiN1(l)).(campiN2(l)).PesoL + pesiL(l);
                            sML.(campiN1(l)).(campiN2(l)).PesoF = sML.(campiN1(l)).(campiN2(l)).PesoF + pesiF(l);
                            sML.(campiN1(l)).(campiN2(l)).Peso = sML.(campiN1(l)).(campiN2(l)).PesoF/sML.(campiN1(l)).(campiN2(l)).PesoL;
                            sML.(campiN1(l)).(campiN2(l)).LatiMap = sML.(campiN1(l)).(campiN2(l)).LatiMap + 1;      % Aggiornamento lati collassati
                        else % Creazione lato aggiunto
                            sML.(campiN1(l)).(campiN2(l)).PesoL = pesiL(l);
                            sML.(campiN1(l)).(campiN2(l)).PesoF = pesiF(l);
                            sML.(campiN1(l)).(campiN2(l)).Peso = sML.(campiN1(l)).(campiN2(l)).PesoF/sML.(campiN1(l)).(campiN2(l)).PesoL;
                            sML.(campiN1(l)).(campiN2(l)).IndiceN1   = latiMacro(l,1);    % Indice del primo nodo
                            sML.(campiN1(l)).(campiN2(l)).MacroRegN1 = nomiR(l,1);   % Macroregione del primo nodo
                            sML.(campiN1(l)).(campiN2(l)).IndiceN2   = latiMacro(l,2);    % Indice del secondo nodo
                            sML.(campiN1(l)).(campiN2(l)).MacroRegN2 = nomiR(l,2);   % Macroregione del secondo nodo
                            sML.(campiN1(l)).(campiN2(l)).NumeroCT   = numCT(l);     % Numero di connettomi condivisi dal lato
                            sML.(campiN1(l)).(campiN2(l)).LatiMap    = 1;            % Numero di lati tra microregioni collassati nel lato macroscopico
                            nLati = nLati + 1;
                        end
                    else     % Creazione lato dal nulla
                        sML.(campiN1(l)).(campiN2(l)).PesoL = pesiL(l);
                        sML.(campiN1(l)).(campiN2(l)).PesoF = pesiF(l);
                        sML.(campiN1(l)).(campiN2(l)).Peso = sML.(campiN1(l)).(campiN2(l)).PesoF/sML.(campiN1(l)).(campiN2(l)).PesoL;
                        sML.(campiN1(l)).(campiN2(l)).IndiceN1   = latiMacro(l,1);    % Indice del primo nodo
                        sML.(campiN1(l)).(campiN2(l)).MacroRegN1 = nomiR(l,1);   % Macroregione del primo nodo
                        sML.(campiN1(l)).(campiN2(l)).IndiceN2   = latiMacro(l,2);    % Indice del secondo nodo
                        sML.(campiN1(l)).(campiN2(l)).MacroRegN2 = nomiR(l,2);   % Macroregione del secondo nodo
                        sML.(campiN1(l)).(campiN2(l)).NumeroCT   = numCT(l);     % Numero di connettomi condivisi dal lato
                        sML.(campiN1(l)).(campiN2(l)).LatiMap    = 1;            % Numero di lati tra microregioni collassati nel lato macroscopico
                        nLati = nLati + 1;
                    end
        
                        % Questa logica presuppone che la matrice in cui sono memorizzati i lati
                        % («lati = table2array(tabGrafoF(:,[1 2])») sia 2xNlati ove ogni riga
                        % è una coppia univoca d'indici dei nodi costituenti un lato.
                % end % Solo escludendo i autoarchi si ottengono esattamente 1130, altrimenti se ne hanno 1211
            end
    
        end

    else % Altrimenti la matrice è quella dell'articolo per cui si restituiscono valori vuoti salvo il numero di nodi
        soglia     = [];
        nLati      = [];
        nNodiMacro = 83;
    end

end


%%%%%%%%%%%%%%%%%
%%% Controlli %%%
%%%%%%%%%%%%%%%%%

    % Ciclo «for» per controllare che non vi siano lati ridondanti (ossia, p. e., dato (40,70) se esiste (70,40))
% for k = 1:length(latiMacro(:,1))
%     if(sum((latiMacro(:,1)==latiMacro(k,2)).*(latiMacro(:,2)==latiMacro(k,1)))>0 && latiMacro(k,1)~=latiMacro(k,2))
%         disp("ridondante")
%     end
% end
    % La risposta è negativa: non vi sono lati ridontanti e ogni riga della tabella contiene univocamente un lato del grafo


    % Ciclo «for» per controllare di aver collassato correttamente tutti i lati
% nL = 0;
% c1 = string(fieldnames(sML));
% for i = 1:length(c1)
%     c2 = string(fieldnames(sML.(c1(i))));
%     for j = 1:length(c2)
%         nL= nL + sML.(c1(i)).(c2(j)).LatiMap;
%     end
% end
    % La risposta è positiva perché si recuperano in tal modo il numero di lati originali tra le microregioni (37477)


    % Ciclo per verificare che la prima colonna contenga tutt'i nodi originali (1015)
% indiciN = table2array(tabGrafo(:,1));
% for i = 1:1015
%     c = sum(indiciN==i);
%     if(c == 0)
%         disp(i)
%     end
% end
    % La risposta è no: p. es il nodo 332 non è presente nella prima colonna ma solo nella seconda
