function Grafici_Prioni(sPM,sPT)

    Mostra_Curve_Reg(sPM,sPT)
    if(strcmp(sPM.modello,"SMO"))
        Mostra_Dim_SMO(sPM,sPT)
    end
    Mostra_Curve_Nodi(sPM,sPT)

end

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Funzioni Ausiliari %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%


    % FK, ED e SMO
function Mostra_Curve_Reg(sPM,sPT)

    global cP sGCR

    nN  = sPM.nN;         % Numero totale di nodi del grafo
    nC  = sPM.nC;         % Numero totale di catene malate
    dX  = sPT.it(sPT.is); % Vettore dei tempi di simulazione
    ns  = sPT.ns;         % Numero totale di passi temporali dt salvati
    T   = sPT.T;          % Periodo di simulazione
    mod = sPM.modello;    % Tipo di modello


        % Inzializzazione della figura
    sF = [];
    switch mod
        case "SMO"
            sF.x=0; sF.y=0; sF.l=3/4; sF.a=3/4;
            sF.p = [sF.x sF.y sF.l sF.a];
        otherwise
            sF.x=0; sF.y=0; sF.l=0.95; sF.a=3/4;
            sF.p = [sF.x sF.y sF.l sF.a];
    end
    f = figure('Name',append("Modello ",mod),'Resize','off', ...
               'NumberTitle','off','Units', 'Normalized','Position',sF.p);
    movegui(f,'center'); % Muove la figura al centro    


        % Struttura per i diagrammi
    sI = [];
    sI.dimF = 20;

        % Struttura dei grafici delle concentrazioni nelle regioni
    sGCR = [];

    switch mod

        case "SMO" % Modello di Smoluchowski (SMO)
                % Grafico per le curve della masse aggregate
            sF.l = .85; sF.a = .75; sF.sep = 0.02;
            sF.sl = (1-sF.l)/2; sF.sa = (1-sF.a)/2;
            axes('Position',[sF.sl+sF.sep sF.sa+sF.sep sF.l sF.a]);
            hold on

                % Costante di normalizzazione della massa aggregata malata [massima] M2
            sGCR.cN = sPM.MInfR;

                % Plottamento delle masse aggregate
            sI.Linea  = "-"; sI.SpessL = 1; sI.SpessM = 10;

            colori  = colormap("jet");                 % Mappa di colori
            iColori = linspace(1,size(colori,1),nC-1); % Indici equidistanti
            colori = colori(round(iColori),:);         % Estrazione dei colori

            nCE = round(linspace(0,nC,6));
            nCE(1) = 2; % Numero di curve evidenziate uguale a 6
            for i=nC:-1:2
                    % Calcolo della massa aggregata della i-esima catena
                Mi = sum(cP(:,i,:),1);   % Somma [lungo le colonne] delle concentrazioni della i-esima catena fra tutti i nodi
                Mi = reshape(Mi,1,ns+1); % Riformulazione del tensore «Mi» cosí d'avere una vettore riga «1⨯istanti»
                Mi = i*Mi;               % Premoltiplicazione della lunghezza della catena i-esima cosí da pesare la sua massa
                
                if(i ~= nC)
                    campo = append("M",string(i+1));
                    Mi = Mi+sGCR.(campo).YData;
                end % Somma delle masse aggregate precedenti

                p = plot(dX,Mi, sI.Linea,'LineWidth',sI.SpessL,'MarkerSize',sI.SpessM,'Color',colori(end-i+2,:));
        
                if(ismember(i,nCE))
                    p.DisplayName = append("M",string(i));
                    p.LineWidth   = 3; % Ispessisce la curva ogni dieci catene
                else
                    p.HandleVisibility = 'off';
                end % Mostra la legenda sse l'aggregato «Mi» ha lunghezza i+1 che è un multiplo di 10 oppure è uguale a 2

                campo = append("M",string(i));
                sGCR.(campo) = p;
            end % Non si è interessati [per il momento] a specifiche regioni ma alla concetrazione totale delle catene su tutta la «rete»

            sGCR.VInf = plot(linspace(0,T,ns+1),sGCR.cN*ones(1,ns+1),'--','Color',colori(end,:), ...
                             'LineWidth',2,'Visible','off','HandleVisibility','off');


        otherwise % Modello di Fisher-Kolmogorov o Eterodimero
                % Grafo celebrale
            sF.l = .325; sF.a = .75;
            sF.sl = 0.03; sF.sa = (1-sF.a)/2;
            axes('Position',[sF.sl 1-sF.sa-sF.a sF.l sF.a]);

            [sPNG,sLNG] = Cervello3D([]);
            view(90,0)

            sB = []; sB.dimT = 12;
            sB.P = [0 0 .1 .1];
            t = uicontrol('Style','text','FontSize',sB.dimT,'String','Mostra rete','Visible','off','Units', 'Normalized');
            attivaLati = uicontrol('Style','checkbox','Value',0,'FontSize',sB.dimT,'String',' Mostra rete', ...
                                   'Units', 'Normalized','Position',sB.P,'CallBack',{@FRMostraLati,sLNG});
            est = get(t,'extent'); est(3) = est(3)+0.0175; attivaLati.Position = [0.21-est(3)/2-0.0175 .05 est(3) est(4)];
            FRMostraLati(attivaLati,[],sLNG)


                % Grafico per le curve delle regioni
            sF.l = 0.55; sF.a = .75;
            sF.sl = 0.03; sF.sa = (1-sF.a)/2;
            axes('Position',[1-sF.sl-sF.l 1-sF.sa-sF.a sF.l sF.a]);
            hold on

                % Plottamento delle curve
            sI.Linea  = "--k"; sI.SpessL = 2;
            sI.SpessM = 10; sI.NomeL  = "Network"; % Rete

                % Ricerca degl'indici dei nodi delle regioni d'interesse
            nomiR = ["T"  "Temporal"  "Temporale"
                     "F"  "Frontal"   "Frontale"
                     "P"  "Parietal"  "Parietale"
                     "O"  "Occipital" "Occipitale"
                     "L"  "Limbic" "Limbico"
                     "BG" "Basal ganglia" "Ganglia basale"
                     "BS" "Brainstem" "Tronco encefalico"];
            iNR = Trova_Indici(nomiR);

            reg = string(fieldnames(iNR));

            colori = [];
            colori.(nomiR(1,1)) = "#00be00";
            colori.(nomiR(2,1)) = "#cc0000";
            colori.(nomiR(3,1)) = "#ff8b00";
            colori.(nomiR(4,1)) = "#0000cc";
            colori.(nomiR(5,1)) = "#81007f";
            colori.(nomiR(6,1)) = "#808080";
            colori.(nomiR(7,1)) = "#000000";

            hold on

            switch mod

                case 'FK' % Modello di Fisher-Kolmogorov
                    sGCR.cN = 1; % Costante di normalizzazione

                        % Plottamento dell'andamento retale complessivo
                    dY = sum(cP,1)/nN; % Somma delle concentrazioni fra tutti i nodi (lungo le colonne)
                    plot(dX,dY,sI.Linea,'LineWidth',sI.SpessL,'MarkerSize',sI.SpessM,'DisplayName',sI.NomeL)

                        % Plottamento delle specifiche regioni
                    sI.Linea  = "-"; sI.SpessL = 2;
                    for r = 1:length(reg)-2                
                        iR = iNR.(reg(r+2));   % Indici dei nodi nella regione
                        nR = length(iR);       % Numero dei nodi nella regione
                
                        sI.NomeL = iNR.legenda(r);
                        dY = sum(cP(iR,:),1)/nR; % Somma delle concentrazioni lungo le colonne
                
                        plot(dX,dY, sI.Linea,'LineWidth',sI.SpessL,...
                             'Color',colori.(reg(r+2)),'DisplayName',sI.NomeL);
                
                        for i = 1:nR
                            campo = append("N",string(iR(i)));
                            sPNG.(campo).FaceColor = colori.(reg(r+2));
                        end
                    end % Il -2 esclude i campi «iTotali» e «Traduzioni» della struttura «reg»


                case 'ED' % Modello EteroDimero
                    sGCR.cN = sPM.cmInf; % Costante di normalizzazione della massa malata

                        % Plottamento dell'andamento retale complessivo %
                    dY = reshape(cP(:,2,:),nN,ns+1);
                    dY = sum(dY,1)/nN; % Somma delle concentrazioni fra tutti i nodi (lungo le colonne)
                    sGCR.rT = plot(dX,dY,sI.Linea,'LineWidth',sI.SpessL,'MarkerSize',sI.SpessM,'DisplayName',sI.NomeL);

                        % Plottamento delle specifiche regioni
                    sI.Linea  = "-"; sI.SpessL = 2;
                    for r = 1:length(reg)-2                
                        iR = iNR.(reg(r+2));   % Indici dei nodi nella regione
                        nR = length(iR);       % Numero dei nodi nella regione
                
                        sI.NomeL = iNR.legenda(r);
                        dY = reshape(cP(iR,2,:),nR,ns+1);
                        dY = sum(dY,1)/nR; % Somma delle concentrazioni lungo le colonne
                
                        sGCR.(reg(r+2)) = plot(dX,dY, sI.Linea,'LineWidth',sI.SpessL,...
                                 'Color',colori.(reg(r+2)),'DisplayName',sI.NomeL);
                
                        for i = 1:nR
                            campo = append("N",string(iR(i)));
                            sPNG.(campo).FaceColor = colori.(reg(r+2));
                        end
                    end % Il -2 esclude i campi «iTotali» e «Traduzioni» della struttura «reg»

                    sGCR.VInf = plot(linspace(0,T,ns+1),sGCR.cN*ones(1,ns+1),'--k', ...
                                     'LineWidth',2,'Visible','off','HandleVisibility','off');
            end
            
    end

        % Normalizzazione [eventuale]
    if(sGCR.cN ~= 1)
        sO.x = 0.01; sO.y = 0.01; sO.l = 0.15; sO.a = 0.03; sO.P = [sO.x sO.y sO.l sO.a];
        h = uicontrol('Style','checkbox','FontSize',12,'Visible','on','Enable','on','String','Normalizza curve',...
                  'Units','Normalized','Position',sO.P,'Value',1,'Callback',@FRNormalizzaReg);
        FRNormalizzaReg(h,[])

        sO.P(2) = sO.P(2)+sO.a*.9;
        uicontrol('Style','checkbox','FontSize',12,'Visible','on','Enable','on','String','Valore asintotico',...
                  'Units','Normalized','Position',sO.P,'Value',0,'Callback',{@FRDisAttivaCurva,sGCR.VInf});
    end % Si normalizza sse la costante di normalizzazione è diversa da uno, lo stesso vale per il valore asintotico

    legend('Location','best','FontSize',sI.dimF,'interpreter','latex');

    grid on % Attiva la griglia
    ax = gca; ax.GridLineStyle = '--'; ax.FontSize = sI.dimF-5;
        
    title(append("Modello ",mod),'FontSize',sI.dimF,'interpreter','latex');
    xlabel('Tempo','FontSize',sI.dimF,'Interpreter','latex')

    switch mod
        case "SMO"
            ylabel('Masse aggregate','FontSize',sI.dimF,'interpreter','latex');
        otherwise
            ylabel('Concentrazione','FontSize',sI.dimF,'interpreter','latex');
    end

end

function Mostra_Curve_Nodi(sPM,sPT)

    global cP sPNG sGCN oggIG sLSel

    nN      = sPM.nN;         % Numero totale di nodi del grafo
    nC      = sPM.nC;         % Numero totale di catene malate
    tempi   = sPT.it(sPT.is); % Vettore dei tempi di simulazione
    ns      = sPT.ns;         % Numero totale di passi temporali dt salvati
    T       = sPT.T;          % Periodo di simulazione
    modello = sPM.modello; % Tipo di modello

    
        % Inzializzazione della figura
    sF = [];
    sF.x=0; sF.y=0; sF.l=.95; sF.a=.75;
    sF.p = [sF.x sF.y sF.l sF.a];

    f = figure('Name',append("Grafici Nodi - Modello ",modello),'Resize','off', ...
               'NumberTitle','off','Units', 'Normalized','Position',sF.p);
    movegui(f,'center'); % Muove la figura al centro    

        % Piastrelle per i due grafici
    sF.l = 0.45; sF.a = 0.9;                % Lunghezza e altezza delle due figure
    sF.sl = 0.03; sF.sa = (1-sF.a)/2+0.025; % Stacco dal bordo iNRistro e superiore
    t = tiledlayout(2,1,"TileSpacing","tight","Padding","tight", ...
                    "Units","normalized","Position",[1-sF.sl-sF.l,sF.sa,sF.l,sF.a]);

    sF.dimT = 15;   % Dimensione dell'etichette
    xlabel(t,'Tempo','Interpreter','latex','FontSize',sF.dimT)


        % Grafici
    sGCN = []; % sGCN è la struttura dei grafici delle concentrazioni

    colori  = colormap("jet");               % Mappa dei colori
    iColori = linspace(1,size(colori,1),nN); % Indici equidistanti
    colori  = colori(round(iColori),:);      % Estrazione dei colori

    sGCN.mod    = modello; % Tipo di modello
    sGCN.dX     = tempi;   % Dati lungo l'ascissa
    sGCN.nN     = nN;      % Numero di nodi
    sGCN.colori = colori;  % Vettore dei colori
    

        % Grafico dei singoli nodi
    sGCN.tN.ax = nexttile;
    hold on
    switch modello
        case "FK" % Modello di Fisher-Kolmogorov
                % Plottamento dell'andamento retale complessivo
            dY = sum(cP,1)/nN; % Somma delle concentrazioni fra tutti i nodi (lungo le colonne)
            sGCN.tN.pT = plot(sGCN.dX,dY,"--k",'LineWidth',2);
        
            for n = 1:nN
                campo = append("p",string(n));
                dY = cP(n,:);
                sGCN.tN.(campo) = plot(tempi,dY,'Color',colori(n,:),'LineWidth',2,'Visible','off');
            end
        
            ylabel(sGCN.tN.ax,'Concentrazione','Interpreter','latex','FontSize',sF.dimT)


        case "ED" % Modelo Eterodimero
                % Costante di normalizzazione della massa aggregata malata [massima] M2
            sGCN.cNs = sPM.csInf;
            sGCN.cNm = sPM.cmInf;

                % Plottamento dell'andamento retale complessivo sano
            dY = reshape(cP(:,1,:),nN,ns+1);
            dY = sum(dY,1)/nN; % Somma delle concentrazioni sane fra tutti i nodi (lungo le colonne)
            sGCN.tN.sT = plot(sGCN.dX,dY,"--k",'LineWidth',2,'Visible','off');
        
                % Plottamento dell'andamento retale complessivo malato
            dY = reshape(cP(:,2,:),nN,ns+1);
            dY = sum(dY,1)/nN; % Somma delle concentrazioni malate fra tutti i nodi (lungo le colonne)
            sGCN.tN.mT = plot(sGCN.dX,dY,"--k",'LineWidth',2,'Visible','on');

                % Valori asintotici nodali
            sGCN.tN.sInf = plot(linspace(0,T,ns+1),sGCN.cNs*ones(1,ns+1),"--xb",'LineWidth',2,'Visible','off','MarkerIndices', ...
                                1:round(length(dY)/20):length(dY),'MarkerSize',6.5,'MarkerEdgeColor','k');
            sGCN.tN.mInf = plot(linspace(0,T,ns+1),sGCN.cNm*ones(1,ns+1),"--+r",'LineWidth',2,'Visible','off','MarkerIndices', ...
                                1:round(length(dY)/20):length(dY),'MarkerSize',6.5,'MarkerEdgeColor','k');


                % Plottamento dell'andamento nodale sano e malato
            for n = 1:nN
                nodo = append("N",string(n));
                dY = reshape(cP(n,1,:),1,ns+1);
                sGCN.tN.(nodo).s = plot(tempi,dY,'Color',colori(n,:),'LineWidth',2,'Visible','off','MarkerIndices', ...
                                        1:round(length(dY)/20):length(dY),'MarkerSize',6.5,'MarkerEdgeColor','k');
                dY = reshape(cP(n,2,:),1,ns+1);
                sGCN.tN.(nodo).m = plot(tempi,dY,'Color',colori(n,:),'LineWidth',2,'Visible','off','MarkerIndices', ...
                                        1:round(length(dY)/20):length(dY),'MarkerSize',6.5,'MarkerEdgeColor','k');
            end
        
            ylabel(sGCN.tN.ax,'Concentrazione','Interpreter','latex','FontSize',sF.dimT)


        case "SMO" % Modelo di Smoluchowski
            iMA = 2;
            sGCN.nC = nC;
            sGCN.cNN    = sPM.MTotN; % Costante di normalizzazione dei nodi
            sGCN.cNR    = sPM.MTotR; % Costante di normalizzazione della rete

                % Plottamento dell'andamento retale complessivo
            dY = sum(cP(:,iMA:nC,:),1);     % Somma [lungo le colonne] delle concentrazioni delle catene fra tutti i nodi
            dY = reshape(dY,nC-iMA+1,ns+1); % Riformulazione del tensore «Mi» cosí d'avere una matrice «nC⨯istanti»
            dY = (iMA:nC)*dY;               % Premoltiplicazione del vettore «i:nC» cosí da pesare ogni catena per la sua dimensione in ogni istante
            % dY = dY/sGCN.cN;                 % Normalizzazione
            sGCN.tN.pT = plot(sGCN.dX,dY,"--k",'LineWidth',2,'AffectAutoLimits','off','Visible','off');

                % Valori asintotici nodali
            sGCN.tN.pInf = plot(linspace(0,T,ns+1),sPM.MInfN*ones(1,ns+1),'--+r','MarkerIndices', ...
                                1:round(length(dY)/20):length(dY),'MarkerSize',6.5, ...
                               'MarkerEdgeColor','k','LineWidth',2,'Visible','off');
            sGCN.tN.mInf = plot(linspace(0,T,ns+1),sPM.mInfN*ones(1,ns+1),'--xb','MarkerIndices', ...
                                1:round(length(dY)/20):length(dY),'MarkerSize',6.5, ...
                                'MarkerEdgeColor','k','LineWidth',2,'Visible','off');

            for n = 1:nN
                    % Campo associato al nodo n-esimo
                nodo  = append("N",string(n));

                    % Sottocampo per il Plottamento della curva malata
                Mnm = cP(n,iMA:nC,:);             % Concentrazioni delle catene iMA-nC nel nodo n-esimo
                Mnm = reshape(Mnm,nC-iMA+1,ns+1); % Riformulazione del tensore «Mnm» cosí d'avere una matrice «(nC-iMA+1)⨯istanti», ove (nC-iMA+1) è il numero di catene considerate
                dY  = (iMA:nC)*Mnm;               % Premoltiplicazione con «m:nC» cosí da pesare ogni catena per la sua dimensione
                sGCN.tN.(nodo).p = plot(sGCN.dX,dY,'-+','MarkerIndices',1:round(length(dY)/30):length(dY),'MarkerSize',6.5, ...
                                       'MarkerEdgeColor','k','Color',colori(n,:),'LineWidth',2,'Visible','off');

                    % Sottocampo per il Plottamento della curva sana
                dY    = reshape(cP(n,1,:),1,ns+1); % Concentrazioni dei monomeri nel nodo n-esimo
                sGCN.tN.(nodo).m = plot(sGCN.dX,dY,'-x','MarkerIndices',1:round(length(dY)/30):length(dY),'MarkerSize',6.5, ...
                                       'MarkerEdgeColor','k','Color',colori(n,:),'LineWidth',2,'Visible','off');

                    % Sottocampo per l'indice della massa aggregata
                sGCN.tN.(nodo).i = iMA;
                    % Sottocampo per la spunta dell'ultima catena
                sGCN.tN.(nodo).uc = 1;
                    % Sottocampo per la spunta della normalizzazione
                sGCN.tN.(nodo).cn = 0;
            end
            sGCN.iMA = iMA;

            ylabel(sGCN.tN.ax,'Massa aggregata','Interpreter','latex','FontSize',sF.dimT)

    end
    axis auto
    grid on % Attiva la griglia
    ax = gca; ax.GridLineStyle = '--';


        % Grafico aggregato medio
    sGCN.tA.ax = nexttile;
    hold on
    switch modello
        case "FK"  % Modello di Fisher-Kolmogorov
                % Plottamento dell'andamento retale complessivo
            sGCN.tA.pT = plot(sGCN.dX,sGCN.tN.pT.YData,"--k",'LineWidth',2);

                % Plottamento aggregato per i nodi selezionati
            sGCN.tA.p  = plot(sGCN.dX,dY,"-r",'LineWidth',2,'Visible','off'); % Uguale a quello di prima ma invisibile e da manipolare a nodi selezionati
            
            ylabel(sGCN.tA.ax,'Concentrazione media','Interpreter','latex','FontSize',sF.dimT)


        case "ED"  % Modelo Eterodimero
                % Plottamento dell'andamento sano/malato retale complessivo
            sGCN.tA.sT = plot(sGCN.dX,sGCN.tN.sT.YData,"--k",'LineWidth',2,'Visible','off');
            sGCN.tA.mT = plot(sGCN.dX,sGCN.tN.mT.YData,"--k",'LineWidth',2,'Visible','on');

                % Plottamento aggregato per i nodi selezionati
            sGCN.tA.s  = plot(sGCN.dX,dY,"-b",'LineWidth',2,'Visible','off','MarkerIndices', ...
                              1:round(length(dY)/20):length(dY),'MarkerSize',6.5,'MarkerEdgeColor','k'); % Uguale a quello di prima ma invisibile e da manipolare a nodi selezionati
            sGCN.tA.m  = plot(sGCN.dX,dY,"-r",'LineWidth',2,'Visible','off','MarkerIndices', ...
                              1:round(length(dY)/20):length(dY),'MarkerSize',6.5,'MarkerEdgeColor','k'); % Uguale a quello di prima ma invisibile e da manipolare a nodi selezionati
            
                % Valore asintotico per i nodi selezionati
            sGCN.tA.sInf  = plot(linspace(0,T,ns+1),sGCN.cNs*ones(1,ns+1),"--xb",'LineWidth',2,'Visible','off','MarkerIndices', ...
                                1:round(length(dY)/20):length(dY),'MarkerSize',6.5,'MarkerEdgeColor','k'); % Uguale a quello di prima ma invisibile e da manipolare a nodi selezionati
            sGCN.tA.mInf  = plot(linspace(0,T,ns+1),sGCN.cNm*ones(1,ns+1),"--+r",'LineWidth',2,'Visible','off','MarkerIndices', ...
                                1:round(length(dY)/20):length(dY),'MarkerSize',6.5,'MarkerEdgeColor','k'); % Uguale a quello di prima ma invisibile e da manipolare a nodi selezionati
            
            ylabel(sGCN.tA.ax,'Concentrazione media','Interpreter','latex','FontSize',sF.dimT)


        case "SMO" % Modelo di Smoluchowski
                % Plottamento dell'andamento retale complessivo
            sGCN.tA.pT = plot(sGCN.dX,sGCN.tN.pT.YData,"--k",'LineWidth',2);

                % Plottamento aggregato per i nodi selezionati
            sGCN.tA.p = plot(sGCN.dX,dY,"-+r",'LineWidth',2,'Visible','off','MarkerIndices',1:round(length(dY)/30):length(dY), ...
                            'MarkerSize',6.5,'MarkerEdgeColor','k'); % Uguale a quello di prima ma invisibile e da manipolare a nodi selezionati
            sGCN.tA.m = plot(sGCN.dX,dY,"-xb",'LineWidth',2,'Visible','off','MarkerIndices',1:round(length(dY)/30):length(dY), ...
                            'MarkerSize',6.5,'MarkerEdgeColor','k'); % Uguale a quello di prima ma invisibile e da manipolare a nodi selezionati
            sGCN.tA.M1= plot(sGCN.dX,dY,"-og",'LineWidth',2,'Visible','off','MarkerIndices',1:round(length(dY)/30):length(dY), ...
                            'MarkerSize',6.5,'MarkerEdgeColor','k'); % Uguale a quello di prima ma invisibile e da manipolare a nodi selezionati

                % Valore asintotico retale
            sGCN.tA.pInf = plot(linspace(0,T,ns+1),sPM.MInfR*ones(1,ns+1),"--+r",'LineWidth',2,'Visible','off','MarkerIndices',1:round(length(dY)/20):length(dY), ...
                              'MarkerSize',6.5,'MarkerEdgeColor','k'); % Uguale a quello di prima ma invisibile e da manipolare a nodi selezionati
            sGCN.tA.mInf = plot(linspace(0,T,ns+1),sPM.mInfR*ones(1,ns+1),"--xb",'LineWidth',2,'Visible','off','MarkerIndices',1:round(length(dY)/20):length(dY), ...
                              'MarkerSize',6.5,'MarkerEdgeColor','k'); % Uguale a quello di prima ma invisibile e da manipolare a nodi selezionati

            sGCN.tA.i = iMA; % Sottocampo per l'indice della massa aggregata
            sGCN.tA.uc = 1;  % Sottocampo per la spunta dell'ultima catena
            sGCN.tA.ns = 0;  % Sottocampo per il numero di nodi selezionati
            sGCN.tA.cn = 0;  % Sottocampo per la spunta della normalizzazione

            ylabel(sGCN.tA.ax,'Massa aggregata media','Interpreter','latex','FontSize',sF.dimT)

    end
    axis auto
    grid on % Attiva la griglia
    ax = gca; ax.GridLineStyle = '--';


        % Grafo celebrale
    sF.l = .325; sF.a = .75;
    sF.sl = 0.03; sF.sa = (1-sF.a)/2;
    axes('Position',[sF.sl 1-sF.sa-sF.a sF.l sF.a]);

    f = @(src,event,indice) FRCliccoNodi(src,event,indice);
    [sPNG,sLNG] = Cervello3D(f);
    view(90,0)

    sB = []; sB.dimT = 12;
    sB.P = [0 0 .1 .1];
    t = uicontrol('Style','text','FontSize',sB.dimT,'String','Mostra rete','Visible','off','Units', 'Normalized');
    attivaLati = uicontrol('Style','checkbox','Value',0,'FontSize',sB.dimT,'String',' Mostra rete', ...
                           'Units', 'Normalized','Position',sB.P,'CallBack',{@FRMostraLati,sLNG});
    est = get(t,'extent'); est(3) = est(3)+0.0175; attivaLati.Position = [0.21-est(3)/2-0.0175 .05 est(3) est(4)];
    FRMostraLati(attivaLati,[],sLNG)


        % Oggetti grafici interattivi
    sO.ab = .05;
    sO.dimT = 10;

    switch modello
        case "FK"
            sO.l = .1; sO.al = .4;
            sO.x = (0.5+sF.sl+sF.l)/2;
            sO.y = 1-(1-sO.al-3*sO.ab)/2-sO.ab;
        case "ED"
            sO.l = .1; sO.al = .4;
            sO.x = (0.5+sF.sl+sF.l)/2;
            sO.y = 1-(1-(1+1/6)*sO.al-3*sO.ab)/2-sO.ab;

            sO.l = .078;
            sO.P = [sO.x-sO.l/2 sO.y+sO.ab*1.2 sO.l .02];
            dNorm = uicontrol('Style','checkbox','FontSize',12,'Visible','on','Enable','on','String','Normalizza curve',...
                              'Units','Normalized','Position',sO.P,'Value',0,'Callback',@FRNormalizzaNodi);
            sO.xSpunte = sO.P(1); sO.l = .1;
            oggIG.Norm = dNorm;
        case "SMO"
            sO.al = .3; sO.x = (0.5+sF.sl+sF.l)/2;
            sO.y = 1-(1-2*sO.al-3*sO.ab)/2-sO.ab;

            sO.l = .078;
            sO.P = [sO.x-sO.l/2 sO.y+sO.ab*1.2 sO.l .02];
            dNorm = uicontrol('Style','checkbox','FontSize',12,'Visible','on','Enable','on','String','Normalizza curve',...
                              'Units','Normalized','Position',sO.P,'Value',0,'Callback',@FRNormalizzaNodi);
            sO.xSpunte = sO.P(1); sO.l = .1;
            oggIG.Norm = dNorm;
    end

    sO.P = [sO.x-sO.l/2 sO.y sO.l sO.ab];
    uicontrol('Style','pushbutton','string','Seleziona tutti','Visible','on','Enable','on', ...
              'Units','Normalized','Position',sO.P,'Callback',@FRSelezionaTuttiN);
    sO.y = sO.y-sO.al;
    sO.P = [sO.x-sO.l/2 sO.y sO.l sO.al];
    dListaN = uicontrol('Style','listbox','FontSize',sO.dimT,'Visible','on','Enable','on','String',sLSel.vNR,...
                        'Max',sLSel.vNR.length,'Min',0,'Units','Normalized','Position',sO.P,...
                        'Value',[],'Callback',@FRListaNodiSelezione);
    oggIG.ListaN = dListaN;

    sO.y = sO.y-sO.ab;
    sO.P = [sO.x-sO.l/2 sO.y sO.l sO.ab];
    dRicerca = uicontrol('Style','edit','Visible','on','Enable','on',...
                         'FontSize',sO.dimT,'Units','Normalized','Position',sO.P);    
    oggIG.Ricerca = dRicerca;

    sO.l = sO.l/2; sO.y = sO.y-sO.ab;
    sO.P = [sO.x-sO.l sO.y sO.l sO.ab];
    uicontrol('Style','pushbutton','string','Trova','Visible','on','Enable','on', ...
              'Units','Normalized','Position',sO.P,'Callback',@FRTrovaN);
    sO.P = [sO.x sO.y sO.l sO.ab];
    uicontrol('Style','pushbutton','string','Resetta','Visible','on','Enable','on', ...
              'Units','Normalized','Position',sO.P,'Callback',@FRResettaN);

    switch modello
        case "FK"
            sO.x = sO.x-sO.l/2; sO.l = 0.075; sO.y = 0.95; sO.a = 0.03;
            sO.P = [sO.x sO.y sO.l sO.a];

            uicontrol('Style','checkbox','FontSize',12,'Visible','on','Enable','on','String','Curva retale',...
                      'Units','Normalized','Position',sO.P,'Value',1,'Callback',{@FRDisAttivaCurva,sGCN.tN.pT});
            sO.P(2) = 0.01;
            uicontrol('Style','checkbox','FontSize',12,'Visible','on','Enable','on','String','Curva retale',...
                      'Units','Normalized','Position',sO.P,'Value',1,'Callback',{@FRDisAttivaCurva,sGCN.tA.pT});

        case 'ED' % Modello Eterodimero
            sO.l = sO.l*2; sO.al = sO.al/6; sO.y = sO.y-sO.al;
            sO.P = [sO.x-sO.l/2 sO.y sO.l sO.al];
            sGCN.iMS = 2; % Indice di massa selezionata
    
            vMA = ['cs' 'cm' "cs+cm"];
            dListaM = uicontrol('Style','listbox','FontSize',sO.dimT,'Visible','on','Enable','on','String',vMA,...
                                'Units','Normalized','Position',sO.P,'Value',sGCN.iMS,'Callback',{@FRListaMassaSelezione,[]});
            oggIG.ListaM = dListaM;

            sO.l = 0.1; sO.y = 0.95; sO.a = 0.03;
            sO.P = [sO.xSpunte sO.y sO.l sO.a]; sO.sep = 0.025;
            dCurvaSN = uicontrol('Style','checkbox','FontSize',12,'Visible','on','Enable','off','String','Curva retale sana',...
                                 'Units','Normalized','Position',sO.P,'Value',0,'Callback',{@FRDisAttivaCurva,sGCN.tN.sT});
            sO.P(2) = sO.P(2)-sO.sep;
            dCurvaMN = uicontrol('Style','checkbox','FontSize',12,'Visible','on','Enable','on','String','Curva retale malata',...
                                 'Units','Normalized','Position',sO.P,'Value',1,'Callback',{@FRDisAttivaCurva,sGCN.tN.mT});
            sO.P(2) = sO.P(2)-sO.sep;
            dCurvaAsN = uicontrol('Style','checkbox','FontSize',12,'Visible','on','Enable','on','String','Valore asintotico',...
                                  'Units','Normalized','Position',sO.P,'Value',0,'Callback',{@FRDisAttivaValoriAs,sGCN.tN});

            sO.P(2) = 1-sO.P(2)-0.025;
            dCurvaAsA =  uicontrol('Style','checkbox','FontSize',12,'Visible','on','Enable','on','String','Valore asintotico',...
                                   'Units','Normalized','Position',sO.P,'Value',0,'Callback',{@FRDisAttivaValoriAs,sGCN.tA});
            sO.P(2) = sO.P(2)-sO.sep;
            dCurvaMA = uicontrol('Style','checkbox','FontSize',12,'Visible','on','Enable','on','String','Curva retale malata',...
                                 'Units','Normalized','Position',sO.P,'Value',1,'Callback',{@FRDisAttivaCurva,sGCN.tA.mT});
            sO.P(2) = sO.P(2)-sO.sep;
            dCurvaSA = uicontrol('Style','checkbox','FontSize',12,'Visible','on','Enable','off','String','Curva retale sana',...
                                 'Units','Normalized','Position',sO.P,'Value',0,'Callback',{@FRDisAttivaCurva,sGCN.tA.sT});
            oggIG.CurvaAs = [dCurvaAsN dCurvaAsA];
            oggIG.CurvaS  = [dCurvaSN dCurvaSA];
            oggIG.CurvaM  = [dCurvaMN dCurvaMA];

            FRListaMassaSelezione(oggIG.ListaM,ns)

        case "SMO" % Modello di Smoluchowski
            sO.l = sO.l*2; sO.al = .3; sO.y = sO.y-sO.al;
            sO.P = [sO.x-sO.l/2 sO.y sO.l sO.al];
    
            vMA = strings(nC,0);
            vMA(1) = "m+M";
            vMA(2:nC) = append("M",string(2:nC));
    
            dListaM = uicontrol('Style','listbox','FontSize',sO.dimT,'Visible','on','Enable','on','String',vMA,...
                                'Units','Normalized','Position',sO.P,'Value',iMA,'Callback',{@FRListaMassaSelezione,ns});
            oggIG.ListaM = dListaM;
    
            sO.al = .02; sO.y = sO.y-.03; sO.l = 0.065;
            sO.P = [sO.xSpunte sO.y sO.l sO.al];
            dUltimaCat = uicontrol('Style','checkbox','FontSize',12,'Visible','on','Enable','on','String',"Ultima catena",...
                                   'Units','Normalized','Position',sO.P,'Value',1,'Callback',{@FRConsideraUltimaCatena,nC});
            oggIG.UltimaCat = dUltimaCat;

            sO.x = sO.xSpunte; sO.l = 0.075; sO.y = 0.95; sO.a = 0.03;
            sO.P = [sO.x sO.y sO.l sO.a];
            uicontrol('Style','checkbox','FontSize',12,'Visible','on','Enable','on','String','Curva retale',...
                      'Units','Normalized','Position',sO.P,'Value',0,'Callback',{@FRDisAttivaCurva,sGCN.tN.pT});
            sO.P(2) = 0.02;
            uicontrol('Style','checkbox','FontSize',12,'Visible','on','Enable','on','String','Curva retale',...
                      'Units','Normalized','Position',sO.P,'Value',1,'Callback',{@FRDisAttivaCurva,sGCN.tA.pT});

            sO.P(2) = sO.P(2)+sO.P(4);
            dCurvaAsA = uicontrol('Style','checkbox','FontSize',12,'Visible','on','Enable','on','String','Valore asintotico',...
                                  'Units','Normalized','Position',sO.P,'Value',0,'Callback',{@FRDisAttivaValoriAs,sGCN.tA});
            sO.P(2) = 0.95; sO.P(2) = sO.P(2)-sO.P(4);
            dCurvaAsN =  uicontrol('Style','checkbox','FontSize',12,'Visible','on','Enable','on','String','Valore asintotico',...
                                   'Units','Normalized','Position',sO.P,'Value',0,'Callback',{@FRDisAttivaValoriAs,sGCN.tN});
            oggIG.CurvaAs = [dCurvaAsN dCurvaAsA];

    end

end

    % SMO
function Mostra_Dim_SMO(sPM,sPT)

    global cP sGD

    nC      = sPM.nC;    % Numero totale di catene malate
    nt      = sPT.nt;    % Numero totale di dt
    it      = sPT.it;    % Vettore dei passi temporali
    ns      = sPT.ns;    % Numero totale di passi temporali salvati
    is      = sPT.is;    % Vettore dei passi temporali salvati
    modello = sPM.modello; % Tipo di modello

        % Inzializzazione della figura
    sF = [];
    sF.x=0; sF.y=0; sF.l=3/4; sF.a=3/4;
    sF.p = [sF.x sF.y sF.l sF.a];

    f = figure('Name',append("Modello ",modello," - Distribuzione dimensione aggregata"),'Resize','off', ...
               'NumberTitle','off','Units', 'Normalized','Position',sF.p);
    movegui(f,'center'); % Muove la figura al centro
    hold on

        % Plottamento della distribuzione della dimensione delle catene
    sI = []; % Struttura per i dati dell'immagine
    sI.DatiX  = 2:nC; sI.dimF = 20; sI.Linea  = "-";

    colori  = colormap("jet");                 % Mappa di colori
    iColori = linspace(1,size(colori,1),nt+1); % Indici equidistanti
    colori = colori(round(iColori),:);         % Estrazione dei colori

        % Distribuzione della dimensione delle catene
    dA = sum(cP,1);             % Somma [lungo le colonne] delle concentrazioni delle catene fra tutti i nodi
    dA = dA(:,2:nC,:);          % Si considerano solo le catene malate, ossia quelle da 2 fino a nC
    dA = reshape(dA,nC-1,ns+1); % Riformulazione del tensore «dA» cosí d'avere una matrice «nC⨯nt+1»

        % Numero di distribuzioni mostrate ed evidenziate rispettivamente
    nDM = 30+1; nDE = 6+1; % Il +1 serve per escludere il punto iniziale nel comando «linspace»
    iDM = round(linspace(0,ns,nDM))+1;  % Istanti delle distribuzionin evidenziate
    iDE = round(linspace(0,nDM-1,nDE)); % Istanti delle distribuzioni mostrate
    iDM = iDM(2:end); iDE = iDE(2:end); % Si esclude il primo istante perché la condizione iniziale non è interessante
        % Il +1 in iDM esclude l'origine dato che la colonna 1 è associata al tempo 0 che però si vuole escludere: in tal modo si
        % considerano nDM-1 distribuzioni equispaziate al di fuori dell'origine di cui nDE-1 [sempre equispaziate] sono evidenziate
 
    % figure('Name',append("Modello ",modello," - Distribuzione dimensione aggregata"),'Resize','off', ...
    %            'NumberTitle','off','Units', 'Normalized','Position',sF.p);
    % dP=sum(cP,1);
    % dP=reshape(dP,nC,ns+1);
    % dP=sum(dP,1);
    % dP=dP/83;
    % plot([it(1),it(end)],sPM.k0/sPM.k1*ones(1,2),'--k','LineWidth',1.5)
    % hold on
    % plot(it(is),dP,'-','Color','#FF8800','LineWidth',1.5)
    % hold off

    sGD = []; % Inizializzazione della struttura dei grafici delle distribuzione
    sGD.numI = nDM-1;
    sGD.PInfR = sPM.PInfR;

    for s=2:ns+1
    
        % mantissa = it(n)-floor(it(n)); % Se la mantissa è nulla allora il numero è intero
        if(ismember(s,iDM)) % Se s fa parte delle distribuzioni da mostrare

            istante = append("i",string(s));

                % Traduzione dell'indice s in termini di n
            n = is(s);

                % Distribuzione delle dimensioni delle catene nell'istante di tempo t
            sI.DatiY = dA(:,s);

                % Plottamento della distribuzione
            sGD.distribuzione.(istante) = plot(sI.DatiX,sI.DatiY, sI.Linea,'Color',colori(n,:));
            sGD.distribuzione.(istante).DisplayName = append("t=",string(it(n))," anni");

            if(ismember(s,iDM(iDE))) % Se s fa parte delle distribuzioni da evidenziare
                sGD.distribuzione.(istante).LineWidth = 3;
                sGD.distribuzione.(istante).HandleVisibility = 'on';
            else
                sGD.distribuzione.(istante).LineWidth = 1;
                sGD.distribuzione.(istante).HandleVisibility = 'off';
            end

                % Valore medio delle catene all'istante di tempo t
            somma = sum(sI.DatiY);
            if(somma ~= 0)
                media = ((2:nC)*sI.DatiY)/somma;
    
                a = floor(media); b  = a+1;
                fa = sI.DatiY(a-1); fb = sI.DatiY(b-1);
                % Il -1 è dovuto al fatto che sI.DatiY contiene nC-1 elementi ognuno associato alla catena
                % di lunghezza successiva: per es. la catena di lunghezza 2 è in prima posizione e cosí via
                interp = @(t) fa*(b-t)/(b-a) + fb*(t-a)/(b-a);
    
                sGD.media.(istante) = plot([media media],[0 interp(media)], ...
                                            "-",'Color',colori(n-1,:), ...
                                            'LineWidth',1.5,'HandleVisibility','off');
            end
            
            % Se la somma è diversa da zero allora si calcola la media
            % altrimenti non la si considera perché non significativa
            % (banalmente sarebbe un punto sull'origine)

        end

    end % Non si è interessati [per il momento] a specifiche regioni ma alla concetrazione totale delle catene su tutta la «rete»


        % Plottamento della distribuzione omogenea delle catene
    sGD.stimaAsintotica = gobjects(3,1);

    dX = 2:nC; dY = sPM.cInf(2:nC); somma = sum(dY);
    sGD.stimaAsintotica(1) = plot(dX,dY,"--k",'LineWidth',3,'DisplayName','Stima asintotica');

    media = ((2:nC)*dY')/somma;
    a = floor(media); b  = a+1;
    fa = dY(a-1); fb = dY(b-1);
    % Il -1 è dovuto al fatto che sI.DatiY contiene nC-1 elementi ognuno associato alla catena
    % di lunghezza successiva: per es. la catena di lunghezza 2 è in prima posizione e cosí via
    interp = @(t) fa*(b-t)/(b-a) + fb*(t-a)/(b-a);

    sGD.stimaAsintotica(2) = plot([media media],[0 interp(media)],"-k",'LineWidth',1.5,'HandleVisibility','off');
    sGD.stimaAsintotica(3) = plot([sPM.nMax sPM.nMax],[0 sPM.cInf(sPM.nMax)],"-.k",'LineWidth',1.5,'HandleVisibility','off');

    sO.x = 0.01; sO.y = 0.01; sO.l = 0.15; sO.a = 0.03;
    sO.P = [sO.x sO.y sO.l sO.a];    
    uicontrol('Style','checkbox','FontSize',12,'Visible','on','Enable','on','String','Mostra stima asintotica',...
              'Units','Normalized','Position',sO.P,'Value',1,'Callback',{@FRDisAttivaCurva,sGD.stimaAsintotica});
    sO.P(2) = sO.P(2)+sO.a*.9;   
    h = uicontrol('Style','checkbox','FontSize',12,'Visible','on','Enable','on','String','Normalizza distribuzioni',...
                 'Units','Normalized','Position',sO.P,'Value',1,'Callback',@FRNormalizzaDistribuzioni);
    FRNormalizzaDistribuzioni(h,[])

    grid on % Attiva la griglia
    ax = gca; ax.GridLineStyle = '--'; ax.FontSize = sI.dimF-5;
        
    title(append("Modello ",modello," - Distribuzione dimensione aggregata"),'FontSize',sI.dimF,'interpreter','latex');
    legend('Location','best','FontSize',sI.dimF,'interpreter','latex');

    xlabel('Lunghezza catena','FontSize',sI.dimF,'interpreter','latex');
    ylabel('Concentrazione','FontSize',sI.dimF,'interpreter','latex');

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Funzioni di Richiamo %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Selezione Nodi FK, ED e SMO
function FRListaNodiSelezione(srg,~)

    global oggIG sPNG sGCN

    iNISel = srg.Value; % Indice dei nodi considerati
    sPNG.vNSC(iNISel) = mod(sPNG.vNSC(iNISel)+1,2); % Commutazione del loro stato
        % S'impongono i nodi selezionati facendoli alternare di stato: se erano
        % 0 diventano 1 e viceversa se erano 1 (il mod in base due serve a ciò)
    
    for n = 1:length(sPNG.vNSC) % Per tutti i nodi
        campo = append("N",string(n));
        if(sPNG.vNSC(n) == 1) % Se il nodo è stato selezionato si cambia il colore
            sPNG.(campo).FaceColor = sGCN.colori(n,:);
        else               % Altrimenti si ristabilisce il suo colore originale
            sPNG.(campo).FaceColor = [0.5 0.5 0.5];
        end
    end

        % Si aggiorna la lista dei nodi selezionati
    sel = find(sPNG.vNSC);
    oggIG.ListaN.Value = sel;

        % Si aggiornano i grafici
    FRCreaGrafici([],[])

end

function FRListaMassaSelezione(srg,~,ns)

    global sGCN cP sPNG oggIG

    nN  = sGCN.nN;

    switch sGCN.mod
        case 'ED'
            sGCN.iMS = srg.Value;
            
                % Aggiornamento delle spunte per mostrare le rispettive curve retali
            switch sGCN.iMS
                case 1 % Curve sane
                    oggIG.CurvaS(1).Enable = 'on';  oggIG.CurvaS(2).Enable = 'on';
                    oggIG.CurvaS(1).Value  = 1;     oggIG.CurvaS(2).Value  = 1;
                    oggIG.CurvaM(1).Enable = 'off'; oggIG.CurvaM(2).Enable = 'off';
                    oggIG.CurvaM(1).Value  = 0;     oggIG.CurvaM(2).Value  = 0;
                case 2 % Curve malate
                    oggIG.CurvaS(1).Enable = 'off'; oggIG.CurvaS(2).Enable = 'off';
                    oggIG.CurvaS(1).Value  = 0;     oggIG.CurvaS(2).Value  = 0;
                    oggIG.CurvaM(1).Enable = 'on';  oggIG.CurvaM(2).Enable = 'on';
                    oggIG.CurvaM(1).Value  = 1;     oggIG.CurvaM(2).Value  = 1;
                case 3 % Curve sane e malate
                    oggIG.CurvaS(1).Enable = 'on';  oggIG.CurvaS(2).Enable = 'on';
                    oggIG.CurvaS(1).Value  = 1;     oggIG.CurvaS(2).Value  = 1;
                    oggIG.CurvaM(1).Enable = 'on';  oggIG.CurvaM(2).Enable = 'on';
                    oggIG.CurvaM(1).Value  = 1;     oggIG.CurvaM(2).Value  = 1;
            end

                % Si nascondono tutte le altre curve accese poi da «FRCreaGrafici»
            for n = 1:nN
                nodo = append('N',string(n));
                sGCN.tN.(nodo).s.Visible = 'off';
                sGCN.tN.(nodo).m.Visible = 'off';
            end


        case 'SMO'

            sGCN.iMA = srg.Value;

                % Parametri
            nC  = sGCN.nC;
            iMA = sGCN.iMA;
            cN  = oggIG.Norm.Value;
        
                % Ricalcolo dell'andamento retale complessivo col nuovo valore di iMA
            Mi = sum(cP(:,iMA:nC,:),1);     % Somma [lungo le colonne] delle concentrazioni delle catene fra tutti i nodi
            Mi = reshape(Mi,nC-iMA+1,ns+1); % Riformulazione del tensore «Mi» cosí d'avere una matrice «nC-iMA+1⨯istanti»
            Mi = (iMA:nC)*Mi;               % Premoltiplicazione del vettore «i:nC» cosí da pesare ogni catena per la sua dimensione in ogni istante
            Mi = Mi/(sGCN.cNR^cN);           % Normalizzazione
        
            sGCN.tN.pT.YData = Mi;
            sGCN.tA.pT.YData = Mi;
    end

        % Si pone nullo vNSP per aggiornare tutti i nodi, visto che si è cambiato
        % l'indice di massa accumulata iMA, senza però commutarne la loro selezione
    sPNG.vNSP = zeros(nN,1);
    FRCreaGrafici([],[])

        % Aggiornamento dei valori asintotici
    FRDisAttivaValoriAs(oggIG.CurvaAs(1),[],sGCN.tN)
    FRDisAttivaValoriAs(oggIG.CurvaAs(2),[],sGCN.tA)

end

function FRCliccoNodi(~,~,indice)

    global oggIG sPNG sGCN

    campo = append("N",string(indice));
    if(sPNG.vNSC(indice) == 0)
        sPNG.vNSC(indice) = 1;
        sPNG.(campo).FaceColor = sGCN.colori(indice,:);
    else
        sPNG.vNSC(indice) = 0;
        sPNG.(campo).FaceColor = [0.5 0.5 0.5];
    end

    sel = find(sPNG.vNSC);
    oggIG.ListaN.Value = sel;

    FRCreaGrafici([],[])

end

function FRCreaGrafici(~,~)

    global cP sPNG sGCN oggIG
        
        % Vettore binario, numero e indici dei nodi selezionati correnti
    vBNS = sPNG.vNSC;
    nNS  = sum(sPNG.vNSC);
    vINS = find(vBNS);

        % Vettore binario, numero e indici dei nodi commutati
    vBNC = mod(sPNG.vNSC+sPNG.vNSP,2);
    nNC  = sum(vBNC);
    vINC = find(vBNC);

    nT   = length(sGCN.dX); % Numero dei tempi considerato

    switch sGCN.mod

        case "FK" % Modello di Fisher-Kolmogorov
            if(nNS == 0) % Se non vi sono nodi selezionati

                    % Si nascondono le curve precedentemente visibili
                for i = 1:nNC
                    n = vINC(i);
                    campo = append('p',string(n));
                    sGCN.tN.(campo).Visible = 'off';
                end

                    % Si nasconde la curva media
                sGCN.tA.p.Visible  = 'off';

            else % Altrimenti se v'è almeno un nodo selezionato

                    % Aggiornamento delle curve malate e sane dei nodi commutati
                for i = 1:nNC % Per ogni nodo commutato
        
                    n = vINC(i); % Indice del nodo commutato
                    nodo = append("p",string(n));
        
                    if(vBNS(n) == 1) % Commutazione positiva (0->1)
        
                            % Visibilità delle curve del nodo
                        sGCN.tN.(nodo).Visible = 'on';
        
                    else % Commutazione negativa (1->0)
        
                            % Aggiornamento della visibilità delle curve dei nodi
                        sGCN.tN.(nodo).Visible = 'off';
        
                    end % Commutazione del singolo nodo
        
                end % Commutazione di tutti i nodi
        

                    % Inizializzazione dei valori medi
                dYMT = zeros(1,nT);

                    % Ricalcolo della curva malata media
                for s = 1:nNS
                    n = vINS(s); % Indice del nodo attivo
                    nodo = append("p",string(n));
                    dYMT = dYMT + sGCN.tN.(nodo).YData;
                end

                    % Aggiornamento delle curva malata media
                sGCN.tA.p.YData = dYMT/nNS;

                    % Aggiornamento della visibilità delle curve media
                sGCN.tA.p.Visible    = 'on';

            end % nNS


        case "ED" % Modello Eterodimero

                % Si disattiva la legenda
            legend(sGCN.tN.ax,'off')
            legend(sGCN.tA.ax,'off')

            iMS = sGCN.iMS;

            if(nNS == 0) % Se non vi sono nodi selezionati

                    % Si nascondono le curve precedentemente visibili
                for i = 1:nNC
                    n = vINC(i);
                    nodo = append('N',string(n));
                    sGCN.tN.(nodo).s.Visible = 'off';
                    sGCN.tN.(nodo).m.Visible = 'off';
                end

                    % Si nasconde le curve medie
                sGCN.tA.s.Visible  = 'off';
                sGCN.tA.m.Visible  = 'off';

                FRDisAttivaCurva(oggIG.CurvaS(1),[],sGCN.tN.sT)
                FRDisAttivaCurva(oggIG.CurvaS(2),[],sGCN.tA.sT)
                FRDisAttivaCurva(oggIG.CurvaM(1),[],sGCN.tN.mT)
                FRDisAttivaCurva(oggIG.CurvaM(2),[],sGCN.tA.mT)

                switch iMS
                    case 1
                        sGCN.tN.sT.Color    = 'k';    sGCN.tN.mT.Color    = 'k';
                        sGCN.tA.sT.Color    = 'k';    sGCN.tA.mT.Color    = 'k';
                    case 2
                        sGCN.tN.sT.Color    = 'k';    sGCN.tN.mT.Color    = 'k';
                        sGCN.tA.sT.Color    = 'k';    sGCN.tA.mT.Color    = 'k';
                    case 3
                        sGCN.tN.sT.Color    = 'b';    sGCN.tN.mT.Color  = 'r';
                        sGCN.tA.sT.Color    = 'b';  sGCN.tA.mT.Color    = 'r';
                end

            else % Altrimenti se v'è almeno un nodo selezionato

                if(iMS == 3)

                        % Aggiornamento delle curve malate e sane dei nodi commutati
                    for i = 1:nNC % Per ogni nodo commutato
            
                        n = vINC(i); % Indice del nodo commutato
                        nodo = append("N",string(n));
            
                        if(vBNS(n) == 1) % Commutazione positiva (0->1)
                                % Visibilità delle curve del nodo
                            sGCN.tN.(nodo).s.Visible = 'on';
                            sGCN.tN.(nodo).s.Marker  = 'x';
                            sGCN.tN.(nodo).m.Visible = 'on';
                            sGCN.tN.(nodo).m.Marker  = '+';
                        else % Commutazione negativa (1->0)
                                % Aggiornamento della visibilità delle curve dei nodi
                            sGCN.tN.(nodo).s.Visible = 'off';
                            sGCN.tN.(nodo).m.Visible = 'off';
                        end % Commutazione del singolo nodo
            
                    end % Commutazione di tutti i nodi

                    
                        % Aggiornamento delle curve retali medie
                    dYcsT = zeros(1,nT);
                    dYcmT = zeros(1,nT);

                        % Ricalcolo delle curve aggregate
                    for s = 1:nNS
                        n = vINS(s); % Indice del nodo attivo
                        nodo = append("N",string(n));
                        dYcsT = dYcsT + sGCN.tN.(nodo).s.YData;
                        dYcmT = dYcmT + sGCN.tN.(nodo).m.YData;
                    end

                        % Aggiornamento delle curva malata aggregata
                    sGCN.tA.s.YData = dYcsT/nNS;
                    sGCN.tA.m.YData = dYcmT/nNS;
    
                        % Aggiornamento della visibilità delle curve medie e totali
                    sGCN.tN.sT.Visible = 'on'; sGCN.tN.mT.Visible = 'on';
                    sGCN.tA.sT.Visible = 'on'; sGCN.tA.mT.Visible = 'on';

                    sGCN.tA.s.Visible  = 'on';  sGCN.tA.m.Visible  = 'on';
                    sGCN.tA.s.Marker   = 'x';   sGCN.tA.m.Marker   = '+';


                        % Aggiornamento della legenda
                    l = gobjects(2,1);
                    l(1) = plot(NaN,NaN,'-x','Color','#8F8F8F','MarkerSize',8,'MarkerEdgeColor','k','LineWidth',2);
                    l(2) = plot(NaN,NaN,'-+','Color','#8F8F8F','MarkerSize',8,'MarkerEdgeColor','k','LineWidth',2);
                    legend(sGCN.tN.ax,l,{"Concentrazione sana" "Concentrazione malata"},...
                           'Location','best','FontSize',17.5,'Interpreter','latex');

                    l = gobjects(2,1);
                    l(1) = plot(NaN,NaN,'-x','Color','b','MarkerSize',8,'MarkerEdgeColor','k','LineWidth',2);
                    l(2) = plot(NaN,NaN,'-+','Color','r','MarkerSize',8,'MarkerEdgeColor','k','LineWidth',2);
                    legend(sGCN.tA.ax,l,{"Concentrazione [media] sana" "Concentrazione [media] malata"},...
                           'Location','best','FontSize',17.5,'Interpreter','latex');

                else % Se si vede solo un tipo di curva

                        % Scelta del pedice
                    catene = ["s" "m"];
                    c = catene(iMS);

                        % Aggiornamento delle curve malate e sane dei nodi commutati
                    for i = 1:nNC % Per ogni nodo commutato
            
                        n = vINC(i); % Indice del nodo commutato
                        nodo = append("N",string(n));
            
                        if(vBNS(n) == 1) % Commutazione positiva (0->1)
                                % Visibilità delle curve del nodo
                            sGCN.tN.(nodo).(c).Visible = 'on';
                            sGCN.tN.(nodo).(c).Marker  = 'none';
                        else % Commutazione negativa (1->0)
                                % Aggiornamento della visibilità delle curve dei nodi
                            sGCN.tN.(nodo).(c).Visible = 'off';
                        end % Commutazione del singolo nodo
            
                    end % Commutazione di tutti i nodi


                        % Aggiornamento delle curve retali medie
                    dYccT = zeros(1,nT);

                        % Ricalcolo delle curve aggregate
                    for s = 1:nNS
                        n = vINS(s); % Indice del nodo attivo
                        nodo = append("N",string(n));
                        dYccT = dYccT + sGCN.tN.(nodo).(c).YData;
                    end

                        % Aggiornamento delle curva aggregata
                    sGCN.tA.(c).YData = dYccT/nNS;


                    if(iMS == 1)
                            % Aggiornamento della visibilità delle curve medie e totali
                        sGCN.tN.sT.Visible = 'on'; sGCN.tN.mT.Visible = 'off';
                        sGCN.tA.sT.Visible = 'on'; sGCN.tA.mT.Visible = 'off';

                        sGCN.tA.s.Visible  = 'on';   sGCN.tA.m.Visible  = 'off';
                        sGCN.tA.s.Marker   = 'none'; sGCN.tA.m.Marker   = 'none';

                            % Aggiornamento della legenda
                        l = plot(NaN,NaN,'-k','Color','#8F8F8F','LineWidth',2);
                        legend(sGCN.tN.ax,l,"Concentrazione sana",'Location','best','FontSize',17.5,'Interpreter','latex');

                        l = plot(NaN,NaN,'-b','LineWidth',2);
                        legend(sGCN.tA.ax,l,"Concentrazione [media] sana",'Location','best','FontSize',17.5,'Interpreter','latex');
                    else
                            % Aggiornamento della visibilità delle curve medie e totali
                        sGCN.tN.sT.Visible = 'off'; sGCN.tN.mT.Visible = 'on';
                        sGCN.tA.sT.Visible = 'off'; sGCN.tA.mT.Visible = 'on';

                        sGCN.tA.s.Visible  = 'off';  sGCN.tA.m.Visible  = 'on';
                        sGCN.tA.s.Marker   = 'none'; sGCN.tA.m.Marker   = 'none';

                            % Aggiornamento della legenda
                        l = plot(NaN,NaN,'-k','Color','#8F8F8F','LineWidth',2);
                        legend(sGCN.tN.ax,l,"Concentrazione malata",'Location','best','FontSize',17.5,'Interpreter','latex');

                        l = plot(NaN,NaN,'-r','LineWidth',2);
                        legend(sGCN.tA.ax,l,"Concentrazione [media] malata",'Location','best','FontSize',17.5,'Interpreter','latex');
                    end
                    
                end % iMS

            end % nNS


        case "SMO" % Modello di Smoluchowski

                % Si disattiva la legenda
            legend(sGCN.tN.ax,'off')
            legend(sGCN.tA.ax,'off')

            if(nNS == 0) % Se non vi sono nodi selezionati

                    % Si nascondono le curve precedentemente visibili
                for i = 1:nNC
                    n = vINC(i);
                    nodo   = append("N",string(n));
                    sGCN.tN.(nodo).p.Visible = 'off';
                    sGCN.tN.(nodo).m.Visible = 'off';
                end

                    % Si nascondono le curve medie
                sGCN.tA.p.Visible  = 'off';
                sGCN.tA.m.Visible  = 'off';
                sGCN.tA.M1.Visible = 'off';

            else % Altrimenti se v'è almeno un nodo selezionato

                    % Disattivazione generale
                iMA  = sGCN.iMA;  % Massa selezionata
                nC   = sGCN.nC;   % Numero di catene
                uC   = oggIG.UltimaCat.Value-1; % Selezione dell'ultima catena
                cN   = oggIG.Norm.Value;        % Normalizzazione

                if(iMA == 1)

                        % Aggiornamento delle curve malate e sane dei nodi commutati
                    for i = 1:nNC % Per ogni nodo commutato
                        
                        n = vINC(i); % Indice del nodo commutato
                        nodo   = append("N",string(n));

                        if(vBNS(n) == 1) % Commutazione positiva (0->1)
            
                                % Visibilità delle curve del nodo
                            sGCN.tN.(nodo).p.Visible = 'on';
                            sGCN.tN.(nodo).m.Visible = 'on';
                            sGCN.tN.(nodo).p.Marker  = '+';
    
                                % Ricalcolo della curva malata del nodo
                            if(sGCN.tN.(nodo).i ~= iMA || sGCN.tN.(nodo).uc ~= uC)
                                M = cP(n,iMA+1:nC+uC,:);     % Concentrazioni delle catene m-nC nel nodo n-esimo
                                M = reshape(M,nC-iMA+uC,nT); % Riformulazione del tensore «Mi» cosí d'avere una matrice «(nC-iMA+1)⨯istanti», ove (nC-iMA+1) è il numero di catene considerate
                                dY = (iMA+1:nC+uC)*M;        % Premoltiplicazione con «m:nC» cosí da pesare ogni catena per la sua dimensione

                                cn = sGCN.tN.(nodo).cn; % Stato di normalizzazione del nodo
                                dY = dY/(sGCN.cNN^cn);  % Normalizzazione nodale [eventuale]

                                sGCN.tN.(nodo).p.YData = dY;
                                sGCN.tN.(nodo).i  = iMA;
                                sGCN.tN.(nodo).uc = uC;
                            end % Se l'indice è diverso allora si aggiorna

                                % Alternamento della [de]normalizzazione [se cN è cambiato]
                            if(sGCN.tN.(nodo).cn ~= cN)
                                    % Alternamento di [de]normalizzazione nodale
                                sGCN.tN.(nodo).p.YData = sGCN.tN.(nodo).p.YData*(sGCN.cNN^(1-2*cN));
                                sGCN.tN.(nodo).m.YData = sGCN.tN.(nodo).m.YData*(sGCN.cNN^(1-2*cN));
                                sGCN.tN.(nodo).cn = cN;
                            end

                        else % Commutazione negativa (1->0)

                                % Aggiornamento della visibilità delle curve dei nodi
                            sGCN.tN.(nodo).p.Visible = 'off';
                            sGCN.tN.(nodo).m.Visible = 'off';

                        end % Commutazione del singolo nodo

                    end % Commutazione di tutti i nodi


                        % Aggiornamento delle curve retali medie
                    if(sGCN.tA.i ~= iMA || sGCN.tA.uc ~= uC || sGCN.tA.ns ~= nNS)
                        sGCN.tA.i  = iMA;
                        sGCN.tA.uc = uC;
                        sGCN.tA.ns = nNS;

                            % Inizializzazione dei valori medi
                        dYMT = zeros(1,nT);
                        dYmT = zeros(1,nT);
    
                            % Ricalcolo delle curve aggregate
                        for s = 1:nNS
                            n = vINS(s); % Indice del nodo attivo
                            nodo = append("N",string(n));
                            dYMT = dYMT + sGCN.tN.(nodo).p.YData;
                            dYmT = dYmT + sGCN.tN.(nodo).m.YData;
                        end
    
                            % Normalizzazione retale
                        dYMT = dYMT*((sGCN.cNN/sGCN.cNR)^cN);
                        dYmT = dYmT*((sGCN.cNN/sGCN.cNR)^cN);
                            % Nel caso vi sia normalizzazione (cN==1) gli sGCN.tN.(nodo).p.YData
                            % sono già normalizzati rispetto a sGCN.cNN, quindi è necessario prima
                            % moltiplicare per essa prima di normalizzare le curve retali con sGCN.cNR
                        
                            % Aggiornamento delle curve aggregate
                        sGCN.tA.p.YData  = dYMT;
                        sGCN.tA.m.YData  = dYmT;
                        sGCN.tA.M1.YData = (dYMT+dYmT);
                    end

                        % Alternamento della [de]normalizzazione nodale
                    if(sGCN.tA.cn ~= cN)
                        sGCN.tA.p.YData  = sGCN.tA.p.YData*(sGCN.cNR^(1-2*cN));
                        sGCN.tA.m.YData  = sGCN.tA.m.YData*(sGCN.cNR^(1-2*cN));
                        sGCN.tA.M1.YData = sGCN.tA.M1.YData*(sGCN.cNR^(1-2*cN));
                        sGCN.tA.cn = cN;
                    end

                        % Aggiornamento della visibilità delle curve aggregate
                    sGCN.tA.p.Visible    = 'on';
                    sGCN.tA.m.Visible    = 'on';
                    sGCN.tA.M1.Visible   = 'on';
                    sGCN.tA.p.Marker     = '+';


                        % Aggiornamento delle legende
                    l = gobjects(2,1);
                    l(1) = plot(NaN,NaN,'x-','Color','#8F8F8F','MarkerSize',8,'MarkerEdgeColor','k','LineWidth',2);
                    l(2) = plot(NaN,NaN,'+-','Color','#8F8F8F','MarkerSize',8,'MarkerEdgeColor','k','LineWidth',2);
                    legend(sGCN.tN.ax,l,{'m','M'},'Location','best','FontSize',17.5,'Interpreter','latex');
        
                    l = gobjects(3,1);
                    l(1) = plot(NaN,NaN,'x-','Color','b','MarkerSize',8,'MarkerEdgeColor','k','LineWidth',2);
                    l(2) = plot(NaN,NaN,'+-','Color','r','MarkerSize',8,'MarkerEdgeColor','k','LineWidth',2);
                    l(3) = plot(NaN,NaN,'o-','Color','g','MarkerSize',8,'MarkerEdgeColor','k','LineWidth',2);
                    legend(sGCN.tA.ax,l,{'m','M','m+M'},'Location','best','FontSize',17.5,'Interpreter','latex');

                else % Se iMA è maggiore di uno

                        % Aggiornamento delle curve malate e sane dei nodi commutati
                    for i = 1:nNC % Per ogni nodo commutato

                        n = vINC(i); % Indice del nodo commutato
                        nodo   = append("N",string(n));

                        if(vBNS(n) == 1) % Commutazione positiva (0->1)
            
                                % Visibilità delle curve del nodo
                            sGCN.tN.(nodo).p.Visible = 'on';
                            sGCN.tN.(nodo).p.Marker  = 'none';
    
                                % Ricalcolo della curva malata del nodo
                            if(sGCN.tN.(nodo).i ~= iMA || sGCN.tN.(nodo).uc ~= uC)
                                M = cP(n,iMA:nC+uC,:);         % Concentrazioni delle catene m-nC nel nodo n-esimo
                                M = reshape(M,nC-iMA+1+uC,nT); % Riformulazione del tensore «Mi» cosí d'avere una matrice «(nC-iMA+1)⨯istanti», ove (nC-iMA+1) è il numero di catene considerate
                                dY = (iMA:nC+uC)*M;            % Premoltiplicazione con «m:nC» cosí da pesare ogni catena per la sua dimensione

                                cn = sGCN.tN.(nodo).cn; % Stato di normalizzazione del nodo
                                dY = dY/(sGCN.cNN^cn);  % Normalizzazione nodale [eventuale]

                                sGCN.tN.(nodo).p.YData = dY;
                                sGCN.tN.(nodo).i = iMA;
                                sGCN.tN.(nodo).uc = uC;
                            end % Se l'indice è diverso allora si aggiorna

                                % Alternamento della [de]normalizzazione [se cN è cambiato]
                            if(sGCN.tN.(nodo).cn ~= cN)
                                    % Alternamento di [de]normalizzazione nodale
                                sGCN.tN.(nodo).p.YData = sGCN.tN.(nodo).p.YData*(sGCN.cNN^(1-2*cN));
                                sGCN.tN.(nodo).m.YData = sGCN.tN.(nodo).m.YData*(sGCN.cNN^(1-2*cN));
                                sGCN.tN.(nodo).cn = cN;
                            end

                        else % Commutazione negativa (1->0)

                                % Aggiornamento della visibilità delle curve dei nodi
                            sGCN.tN.(nodo).p.Visible = 'off';

                        end % Commutazione del singolo nodo

                        sGCN.tN.(nodo).m.Visible = 'off'; % Si nasconde la curva sana

                    end % Commutazione di tutti i nodi


                        % Aggiornamento della curva retale media
                    if(sGCN.tA.i ~= iMA || sGCN.tA.uc ~= uC || sGCN.tA.ns ~= nNS)
                        sGCN.tA.i  = iMA;
                        sGCN.tA.uc = uC;
                        sGCN.tA.ns = nNS;

                            % Inizializzazione dei valori medi
                        dYMT = zeros(1,nT);
    
                            % Ricalcolo delle curva aggregata e celamento
                            % delle curve sane dei nodi selezionati [rimanenti]
                        for s = 1:nNS
                            n = vINS(s); % Indice del nodo attivo
                            nodo = append("N",string(n));
                            sGCN.tN.(nodo).m.Visible = 'off';
                            dYMT = dYMT + sGCN.tN.(nodo).p.YData; 
                        end
    
                            % Normalizzazione relate
                        dYMT = dYMT*((sGCN.cNN/sGCN.cNR)^cN);
                            % Nel caso vi sia normalizzazione (cN==1) gli sGCN.tN.(nodo).p.YData
                            % sono già normalizzati rispetto a sGCN.cNN, quindi è necessario prima
                            % moltiplicare per essa prima di normalizzare le curve retali con sGCN.cNR
    
                            % Aggiornamento delle curve aggregate
                        sGCN.tA.p.YData = dYMT;
                    end

                        % Alternamento della [de]normalizzazione nodale
                    if(sGCN.tA.cn ~= cN)
                        sGCN.tA.p.YData  = sGCN.tA.p.YData*(sGCN.cNR^(1-2*cN));
                        sGCN.tA.cn = cN;
                    end


                        % Aggiornamento della visibilità delle curve aggregate
                    sGCN.tA.p.Visible    = 'on';
                    sGCN.tA.m.Visible    = 'off';
                    sGCN.tA.M1.Visible   = 'off';
                    sGCN.tA.p.Marker     = 'none';


                        % Aggiornamento della legenda
                    l = plot(NaN,NaN,'-','Color','#8F8F8F','LineWidth',2);
                    legend(sGCN.tN.ax,l,append("M",string(iMA)),'Location','best','FontSize',17.5,'Interpreter','latex');
                    legend(sGCN.tA.ax,l,append("M",string(iMA)),'Location','best','FontSize',17.5,'Interpreter','latex');

                end % iMA

            end % nNS

    end % sGCN.mod

    sPNG.vNSP = sPNG.vNSC; % Aggiornamento della lista precedente

end

    % Ricerca nodi
function FRTrovaN(~,~)

    global oggIG sPNG
    
    parola = oggIG.Ricerca.String;

    if(~isempty(parola))
        parola = string(parola);
        oggIG.Ricerca.String = '';
    
        iN = Trova_Indici(parola);
        sPNG.vNSC(iN) = zeros(length(iN),1);
        % Si pone il loro stato nullo cosicché FRListaNodiSelezione li attivi,
        % per evitare che il loro stato venga semplicemente alternato/commutato
        
        oggIG.ListaN.Value = iN;
        FRListaNodiSelezione(oggIG.ListaN,[])
    end

end

function FRResettaN(~,~)

    global oggIG sPNG

    iNAttivi = find(sPNG.vNSC);
    oggIG.ListaN.Value = iNAttivi;

    FRListaNodiSelezione(oggIG.ListaN,[])

end

function FRSelezionaTuttiN(~,~)

    global oggIG sPNG

    iNDisAttivi = find(sPNG.vNSC == 0);
    oggIG.ListaN.Value = iNDisAttivi;

    FRListaNodiSelezione(oggIG.ListaN,[])

end

    % Normalizzazione
function FRNormalizzaReg(srg,~)

    global sGCR

    spunta = srg.Value;
    campi = fieldnames(sGCR);
    
        % Aggiornamento dell'andamento retale complessivo
    for o = 2:length(campi)
        sGCR.(campi{o}).YData = sGCR.(campi{o}).YData*(sGCR.cN^(1-2*spunta));
    end % Il 2 esclude il campi «cN»

end

function FRNormalizzaNodi(srg,~)

    global sGCN sPNG
    spunta = srg.Value;

    switch sGCN.mod
        case 'SMO'
                    % Normalizzazione dell'andamento retale complessivo
            sGCN.tN.pT.YData = sGCN.tN.pT.YData*(sGCN.cNR^(1-2*spunta));
            sGCN.tA.pT.YData = sGCN.tA.pT.YData*(sGCN.cNR^(1-2*spunta));

                    % Normalizzazione dei valori asintotici
            sGCN.tN.pInf.YData = sGCN.tN.pInf.YData*(sGCN.cNN^(1-2*spunta));
            sGCN.tN.mInf.YData = sGCN.tN.mInf.YData*(sGCN.cNN^(1-2*spunta));
        
            sGCN.tA.pInf.YData = sGCN.tA.pInf.YData*(sGCN.cNR^(1-2*spunta));
            sGCN.tA.mInf.YData = sGCN.tA.mInf.YData*(sGCN.cNR^(1-2*spunta));

        case 'ED'
                % Normalizzazione delle curve dei singoli nodi (tN)
            sGCN.tN.sT.YData = sGCN.tN.sT.YData*(sGCN.cNs^(1-2*spunta));
            sGCN.tN.mT.YData = sGCN.tN.mT.YData*(sGCN.cNm^(1-2*spunta));

            for n = 1:sGCN.nN
                nodo = append('N',string(n));
                sGCN.tN.(nodo).s.YData = sGCN.tN.(nodo).s.YData*(sGCN.cNs^(1-2*spunta));
                sGCN.tN.(nodo).m.YData = sGCN.tN.(nodo).m.YData*(sGCN.cNm^(1-2*spunta));
            end

                % Normalizzazione delle curve medie (tA)
            sGCN.tA.s.YData = sGCN.tA.s.YData*(sGCN.cNs^(1-2*spunta));
            sGCN.tA.m.YData = sGCN.tA.m.YData*(sGCN.cNm^(1-2*spunta));

            sGCN.tA.sT.YData = sGCN.tA.sT.YData*(sGCN.cNs^(1-2*spunta));
            sGCN.tA.mT.YData = sGCN.tA.mT.YData*(sGCN.cNm^(1-2*spunta));

                % Normalizzazione dei valori asintotici
            sGCN.tN.sInf.YData = sGCN.tN.sInf.YData*(sGCN.cNs^(1-2*spunta));
            sGCN.tN.mInf.YData = sGCN.tN.mInf.YData*(sGCN.cNm^(1-2*spunta));

            sGCN.tA.sInf.YData = sGCN.tA.sInf.YData*(sGCN.cNs^(1-2*spunta));
            sGCN.tA.mInf.YData = sGCN.tA.mInf.YData*(sGCN.cNm^(1-2*spunta));

    end

        % Si pone nullo vNSP per aggiornare tutti i nodi
    sPNG.vNSP = zeros(length(sPNG.vNSP),1);
    FRCreaGrafici([],[])

end

function FRNormalizzaDistribuzioni(srg,~)

    global sGD
    spunta = srg.Value;

    % Nomi dei grafici da [de]normalizzare
    nomiD = string(fieldnames(sGD.distribuzione));
    nomiM = string(fieldnames(sGD.media));

    % [De]Normalizzazione dei grafici
    for i=1:sGD.numI
        sGD.distribuzione.(nomiD(i)).YData = sGD.distribuzione.(nomiD(i)).YData*(sGD.PInfR^(1-2*spunta));
        sGD.media.(nomiM(i)).YData = sGD.media.(nomiM(i)).YData*(sGD.PInfR^(1-2*spunta));
    end

    for i=1:3
        sGD.stimaAsintotica(i).YData = sGD.stimaAsintotica(i).YData*(sGD.PInfR^(1-2*spunta));
    end

end

    % Altro
function FRDisAttivaCurva(srg,~,oggetti)

    nO = length(oggetti);
    spunta = srg.Value;

    if(spunta == 1)
        for o = 1:nO
            oggetti(o).Visible = 'on';
            oggetti(o).AffectAutoLimits = 'on';
        end
    else
        for o = 1:nO
            oggetti(o).Visible = 'off';
            oggetti(o).AffectAutoLimits = 'off';
        end
    end

end

function FRDisAttivaValoriAs(srg,~,oggetto)

    global sGCN
    
    switch sGCN.mod
        case 'ED'
            spunta = srg.Value;
            iMS = sGCN.iMS;
            if(spunta == 1)
                switch iMS
                    case 1
                        oggetto.sInf.Marker           = 'none';
                        oggetto.sInf.Visible          = 'on';
                        oggetto.sInf.AffectAutoLimits = 'on';
                        oggetto.sInf.Color            = 'k';
    
                        oggetto.mInf.Marker           = 'none';
                        oggetto.mInf.Visible          = 'off';
                        oggetto.mInf.AffectAutoLimits = 'off';
                    case 2
                        oggetto.sInf.Marker           = 'none';
                        oggetto.sInf.Visible          = 'off';
                        oggetto.sInf.AffectAutoLimits = 'off';
    
                        oggetto.mInf.Marker           = 'none';
                        oggetto.mInf.Visible          = 'on';
                        oggetto.mInf.AffectAutoLimits = 'on';
                        oggetto.mInf.Color            = 'k';
                    case 3
                        oggetto.sInf.Marker           = 'x';
                        oggetto.sInf.Visible          = 'on';
                        oggetto.sInf.AffectAutoLimits = 'on';
                        oggetto.sInf.Color            = 'b';
    
                        oggetto.mInf.Marker           = '+';
                        oggetto.mInf.Visible          = 'on';
                        oggetto.mInf.AffectAutoLimits = 'on';
                        oggetto.mInf.Color            = 'r';
                end
            else
                oggetto.sInf.Visible          = 'off';
                oggetto.sInf.AffectAutoLimits = 'off';
                oggetto.mInf.Visible          = 'off';
                oggetto.mInf.AffectAutoLimits = 'off';
            end


        case 'SMO'
            iMA = sGCN.iMA;
            if(iMA < 3)
                srg.Enable = 'on';
                spunta = srg.Value;
                if(spunta == 1)
                    if(iMA == 1)
                        oggetto.pInf.Visible          = 'on';
                        oggetto.pInf.AffectAutoLimits = 'on';
                        oggetto.pInf.Marker           = '+';
                        oggetto.pInf.Color            = 'r';

                        oggetto.mInf.Visible          = 'on';
                        oggetto.mInf.AffectAutoLimits = 'on';
                    else
                        oggetto.pInf.Visible          = 'on';
                        oggetto.pInf.AffectAutoLimits = 'on';
                        oggetto.pInf.Marker           = 'none';
                        oggetto.pInf.Color            = 'k';

                        oggetto.mInf.Visible          = 'off';
                        oggetto.mInf.AffectAutoLimits = 'off';
                    end
                else
                    oggetto.pInf.Visible          = 'off';
                    oggetto.pInf.AffectAutoLimits = 'off';
                    oggetto.mInf.Visible          = 'off';
                    oggetto.mInf.AffectAutoLimits = 'off';
                end
            else
                oggetto.pInf.Visible          = 'off';
                oggetto.pInf.AffectAutoLimits = 'off';
                oggetto.mInf.Visible          = 'off';
                oggetto.mInf.AffectAutoLimits = 'off';
                srg.Enable = 'off';
                srg.Value = 0;
            end
    end

end

function FRMostraLati(srg,~,struttura)

    stato = srg.Value;
    campi = string(fieldnames(struttura));

    if(stato == 0)
        for l = 1:length(campi)
            struttura.(campi(l)).Linea.Visible = 'off';
        end
    else
        for l = 1:length(campi)
            struttura.(campi(l)).Linea.Visible = 'on';
        end
    end

end

function FRConsideraUltimaCatena(srg,~,nC)

    global oggIG sPNG

    uC = srg.Value;
    if(oggIG.ListaM.Value == nC && uC == 0)
        oggIG.ListaM.Value = nC-1;
    end
    oggIG.ListaM.String = append("M",string(1:nC-1+uC));
    
        % Si pone nullo vNSP per aggiornare tutti i nodi
    sPNG.vNSP = zeros(length(sPNG.vNSP),1);
    FRCreaGrafici([],[])

end


%%%%%%%%%%%%%%%%%%%%%%%
%%% Codice scartato %%%
%%%%%%%%%%%%%%%%%%%%%%%

    % Calcolo inefficiente delle masse aggregate nel modello di Smoluchowski
% for i=nC:-1:2
%     Mi = sum(cP(:,i:nC,:),1);     % Somma [lungo le colonne] delle concentrazioni delle catene fra tutti i nodi
%     Mi = reshape(Mi,nC-i+1,ns+1); % Riformulazione del tensore «Mi» cosí d'avere una matrice «(nC-i+1)⨯istanti», ove (nC-i+1) è il numero di catene considerate
%     Mi = (i:nC)*Mi;               % Premoltiplicazione del vettore «i:nC» cosí da pesare ogni catena per la sua dimensione in ogni istante
% 
%     p = plot(dX,Mi, sI.Linea,'LineWidth',sI.SpessL,'MarkerSize',sI.SpessM,'Color',colori(end-i+2,:));
% 
%     if(ismember(i,nCE))
%         p.DisplayName = append("M",string(i));
%         p.LineWidth   = 3; % Ispessisce la curva ogni dieci catene
%     else
%         p.HandleVisibility = 'off';
%     end % Mostra la legenda sse l'aggregato «Mi» ha lunghezza i+1 che è un multiplo di 10 oppure è uguale a 2
% 
%     campo = append("M",string(i));
%     sGCR.(campo) = p;
% end % Non si è interessati [per il momento] a specifiche regioni ma alla concetrazione totale delle catene su tutta la «rete»

% function FRFissa(~,~,modello)
% 
%         % Codice per fissare nel secondo grafico [delle medie] certe curve
%         % da confrontare con altre; il problema è che serve anche un modo
%         % di defissarle e pure un'altro per identificare i nodi a cui fanno
%         % riferimento certe curve; altrimenti il grafico diventa illeggibile
% 
%     global sGCN
% 
%         % Campo precedente e successivo
%     campoP = append("p",string(sGCN.tA.indice));
%     campoS = append("p",string(sGCN.tA.indice+1));
%     ax = sGCN.tA.ax;
% 
%     hold(ax,'on')
%     sGCN.tA.(campoS) = plot(ax,sGCN.dX, ...
%                                      sGCN.tA.(campoP).YData,...
%                                      'LineWidth',2,'Visible','off');
%     sGCN.tA.indice = sGCN.tA.indice + 1;
% end

% function [] = FRSalva(~,~)
%     exportgraphics(f,'C:/Users/Valerio/Desktop/Scaricati/Nome_Filza.formato') % Esporta la figura «f» con nome «Nome_Filza» e formato «formato» (a.e. «.png», «.jpg», ecc.) nel percorso «Percoso» (a.e. «C:/Users/Valerio/Desktop/Scaricati»)
% end
