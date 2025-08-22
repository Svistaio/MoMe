function Evoluzione_Prioni(sPT,sPM)

        % Inizializzazione della figura
    sF = [];
    sF.x=0; sF.y=0; sF.l=.6; sF.a=.8;
    sF.p = [sF.x sF.y sF.l sF.a];
    f = figure('Name',"Evoluzione grafo",'Resize','off', ...
               'NumberTitle','off','Units', 'Normalized','Position',sF.p);
    movegui(f,'center'); % Muove la figura al centro

    sF.l = 0.8; sF.a = 0.8;
    sF.x = (1-sF.l)/2-0.02; sF.y = 1-0.02-sF.a;
    sF.p = [sF.x sF.y sF.l sF.a];
    tiledlayout(1,1,"TileSpacing","compact","Padding","compact","Position",sF.p)
    nexttile


        % Grafo celebrale
    global sPNE sLNE cP
    [sPNE,sLNE] = Cervello3D([]);
    view(90,0);
    
    sPNE.cLD = sPT.CondLD;
    sPNE.ns  = sPT.ns;
    sPNE.mod = sPM.modello;
    sPNE.nC  = sPM.nC;

    switch sPNE.mod
        case "SMO"
            sPNE.MInfN = sPM.MInfN;
        case "ED"
            sPNE.cmInf = sPM.cmInf;
    end

    bC = colorbar;
    limiti = [min(cP,[],'all'),max(cP,[],'all')];
    clim(limiti); bC.Ticks = limiti;
    bC.TickLabels = ["min","max"];
    colormap jet;


        % Oggetti grafici interattivi
    global sBottEP cont
    cont = 1;

    sB = [];
    sB.dimT = 12;
    sB.sl = 0.002;

    sB.l = 0.15; sB.a = 0.075;
    sB.x = 0.5-0.01-(2*sB.sl+3*sB.l)/2; sB.y = 0.04;
    sB.P = [sB.x sB.y sB.l sB.a];

            % Indientro
    bottIT = uicontrol('Style','pushbutton','Enable','off','FontSize',sB.dimT,'String','Indientro', ...
                       'Units', 'Normalized','Position',sB.P,'CallBack',@FRIndietro);
        sBottEP.IT = bottIT;

            % Istanti
    sB.x = sB.x + sB.l + sB.sl;
    sB.P = [sB.x sB.y sB.l sB.a];
    listaIstanti = append("Passo ",string(sPT.is-1)'," - Tempo ",string(sPT.it(sPT.is))');
    bottT = uicontrol('Style','popupmenu','Value',1,'Enable','on','FontSize',sB.dimT,'String',listaIstanti, ...
                      'Units', 'Normalized','Position',sB.P,'CallBack',@FRIstanti);
        sBottEP.T = bottT;

            % Salto
    sB.a = sB.a/2; sB.l = sB.l/2; sB.x = sB.x + sB.l;
    sB.P = [sB.x sB.y sB.l sB.a];
    bottST = uicontrol('Style','edit','Units','Normalized','Enable','on','FontSize',sB.dimT, ...
                        'String',num2str(floor(sPT.ns/30)),'Position',sB.P);
        sBottEP.ST = bottST;

    sB.x = sB.x - sB.l; sB.P = [sB.x sB.y sB.l sB.a*0.85];
    uicontrol('Style','text','Units','Normalized','Enable','on',...
              'FontSize',sB.dimT,'String','Salto:','Position',sB.P);

            % Avanti
    sB.a = sB.a*2; sB.l = sB.l*2; sB.x = sB.x + sB.l+sB.sl;
    sB.P = [sB.x sB.y sB.l sB.a];
    bottAT = uicontrol('Style','pushbutton','Enable','on','FontSize',sB.dimT,'String','Avanti', ...
                      'Units', 'Normalized','Position',sB.P,'CallBack',{@FRAvanti,sPT.ns});
        sBottEP.AT = bottAT;

            % Mostra rete
    sB.P = [0 0 .1 .1];
    t = uicontrol('Style','text','FontSize',sB.dimT,'String','Mostra rete','Visible','off','Units', 'Normalized');
    attivaLati = uicontrol('Style','checkbox','Value',0,'FontSize',sB.dimT,'String',' Mostra rete', ...
                           'Units', 'Normalized','Position',sB.P,'CallBack',@FRMostraLati);
    est = get(t,'extent'); est(3) = est(3)+0.0175; attivaLati.Position = [0.5-est(3)/2-0.0175 .01 est(3) est(4)];
        sBottEP.AL = attivaLati;
    FRMostraLati(sBottEP.AL,[])

            % Ferma
    global ferma; ferma = 0;
    sB.P = [0 0 .1 .06];
    sB.P([1 2]) = sB.P([1 2])+[0.01 0.01];
    bFerma = uicontrol('Style','pushbutton','FontSize',sB.dimT,'String','Ferma','Interruptible','on','BusyAction','queue', ...
                       'Enable','off','Units', 'Normalized','Position',sB.P,'CallBack',@FRFerma);

            % Scorri
    sB.P = [0 0 .1 .06]; sB.P(1) = 1-sB.P(3);
    sB.P([1 2]) = sB.P([1 2])+[-0.01 0.01];
    uicontrol('Style','pushbutton','FontSize',sB.dimT,'String','Scorri', ...
              'Units', 'Normalized','Position',sB.P,'CallBack',{@FRScorri,sPT.ns,bFerma});
    sPNE.Scorri  = 0; % Bandiera per indicare se si è all'interno di «FRScorri»

    
        % Impostazione al tempo iniziale
    Aggiorna_Grafo()

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Funzioni di richiamo %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function FRIndietro(~,~)
    
    global cont sBottEP
    
    salto = str2double(sBottEP.ST.String);
    if(cont-salto>1)
        cont = cont-salto;
        Aggiorna_Grafo()
    else
        cont = 1;
        Aggiorna_Grafo()
    end
    sBottEP.T.Value = cont;

end

function FRIstanti(srg,~)
    
    global cont

    cont = srg.Value;
    Aggiorna_Grafo()

end

function FRAvanti(~,~,ns)
    
    global cont sBottEP

    salto = str2double(sBottEP.ST.String);
    if(cont+salto<ns+1)
        cont = cont+salto;
        Aggiorna_Grafo()
    else
        cont = ns+1;
        Aggiorna_Grafo()
    end
    sBottEP.T.Value = cont;

end

function FRMostraLati(srg,~)

    global sLNE

    stato = srg.Value;
    campi = string(fieldnames(sLNE));

    if(stato == 0)
        for l = 1:length(campi)
            sLNE.(campi(l)).Linea.Visible = 'off';
        end
    else
        for l = 1:length(campi)
            sLNE.(campi(l)).Linea.Visible = 'on';
        end
    end

end

function FRScorri(~,~,ns,bFerma)

    global sBottEP sPNE
    global cont ferma

    oggetti = string(fieldnames(sBottEP));
    for c = 1:length(oggetti)
        for d = 1:length(sBottEP.(oggetti(c)))
            if(~strcmp(sBottEP.(oggetti(c))(d).Style,'text'))
                sBottEP.(oggetti(c))(d).Enable = 'off';
            end % Se l'oggetto non è di tipo testo allora disattivalo
        end
    end
    bFerma.Enable = 'on';

    sPNE.Scorri = 1;
    while(cont ~= ns+1 && ferma == 0)
        FRAvanti([],[],ns)
        drawnow
        pause(0)
    end
    sPNE.Scorri = 0;

    for c = 1:length(oggetti)
        for d = 1:length(sBottEP.(oggetti(c)))
            if(~strcmp(sBottEP.(oggetti(c))(d).Style,'text'))
                sBottEP.(oggetti(c))(d).Enable = 'on';
            end % Se l'oggetto non è di tipo testo allora disattivalo
        end
    end
    bFerma.Enable = 'off';
    ferma = 0;

    if(cont == ns+1)
        sBottEP.AT.Enable = 'off';
    end
        if(cont == ns+1)
        sBottEP.AT.Enable = 'off';
    end

end

function FRFerma(srg,~)

    global ferma % Alterna lo stato di ferma
    ferma = mod(ferma+1,2);
    srg.Enable = 'off';

end

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Funzioni ausiliari %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%

function Aggiorna_Grafo()

    global sPNE sLNE cP
    global A sBottEP cont

    colori = colormap("jet"); % Mappa di colori

         %%% Aggiornamento dei nodi %%%
    iCM = length(colori); % Indice massimo del colore
    [xRif,yRif,zRif] = sphere(sPNE.nF);

    campi = string(fieldnames(sPNE));

    switch sPNE.mod

        case "FK" % Modello di Fisher-Kolmogorov
            for i = 1:sPNE.nN
                ci = cP(i,cont);

                r = ci/1;
                if(r>=1)
                    iCN = iCM;
                else % «iCN» e «rCN» sono ordinatamente l'indice del colore e il raggio del nodo
                    iCN = floor(r*iCM)+1;
                end
                rCN = 1+r*.5;

                sPNE.(campi(i)).FaceColor = colori(iCN,:);
                sPNE.(campi(i)).XData = sPNE.r*xRif*rCN+sPNE.m*sPNE.CoordP(i,1);
                sPNE.(campi(i)).YData = sPNE.r*yRif*rCN+sPNE.m*sPNE.CoordP(i,2);
                sPNE.(campi(i)).ZData = sPNE.r*zRif*rCN+sPNE.m*sPNE.CoordP(i,3);    
            end

        case "ED" % Modello Eterodimero
            cmInf = sPNE.cmInf;
            for i = 1:sPNE.nN
                ci = cP(i,2,cont);

                r = ci/cmInf;
                if(r>=1)
                    iCN = iCM;
                else % «iCN» e «rCN» sono ordinatamente l'indice del colore e il raggio del nodo
                    iCN = floor(r*iCM)+1;
                end
                rCN = 1+r*.5;

                sPNE.(campi(i)).FaceColor = colori(iCN,:);
                sPNE.(campi(i)).XData = sPNE.r*xRif*rCN+sPNE.m*sPNE.CoordP(i,1);
                sPNE.(campi(i)).YData = sPNE.r*yRif*rCN+sPNE.m*sPNE.CoordP(i,2);
                sPNE.(campi(i)).ZData = sPNE.r*zRif*rCN+sPNE.m*sPNE.CoordP(i,3);    
            end

        case "SMO" % Modello di Smoluchowski
            nC  = sPNE.nC;
            MInf = sPNE.MInfN;
            for i = 1:sPNE.nN
                ci = cP(i,2:nC,cont)*((2:nC)');

                r = ci/MInf;
                if(r>=1)
                    iCN = iCM;
                else % «iCN» e «rCN» sono ordinatamente l'indice del colore e il raggio del nodo
                    iCN = floor(r*iCM)+1;
                end
                rCN = 1+r*.5;

                sPNE.(campi(i)).FaceColor = colori(iCN,:);
                sPNE.(campi(i)).XData = sPNE.r*xRif*rCN+sPNE.m*sPNE.CoordP(i,1);
                sPNE.(campi(i)).YData = sPNE.r*yRif*rCN+sPNE.m*sPNE.CoordP(i,2);
                sPNE.(campi(i)).ZData = sPNE.r*zRif*rCN+sPNE.m*sPNE.CoordP(i,3);
            end

    end



        %%% Aggiornamento dei lati %%%
    if(sPNE.cLD == 1 && sBottEP.AL.Value == 1)
        AI   = A(0); % Matrice d'adiacenza al tempo iniziale
        AMax = max(AI,[],'all');
        AMin = min(AI,[],'all');

            % Funzione lineare che associa LMax<->1.5 e LMin<->1
        interp = @(x,a,b) a*(AMax-x)/(AMax-AMin)+b*(x-AMin)/(AMax-AMin);

        AI   = A(cont); % Matrice d'adiacenza al tempo iniziale

        campi = string(fieldnames(sLNE));
        nN = length(campi);
        for l = 1:nN
            lato = campi(l);
            i    = sLNE.(lato).pi;
            j    = sLNE.(lato).pf;
            Aij = AI(i,j);
            sLNE.(lato).Linea.LineWidth = interp(Aij,.5,4);
            iCol = floor(interp(Aij,0,255))+1;
            if(iCol>256)
                sLNE.(lato).Linea.Color     = [colori(256,:) .3];
            else
                sLNE.(lato).Linea.Color     = [colori(iCol,:) .3];
            end
        end
    end % Se la laplaciana evolve


        % DisAttivazione dei bottoni
    if(sPNE.Scorri == 0)
        switch cont
            case 1
                sBottEP.IT.Enable = 'off';
            case sPNE.ns+1
                sBottEP.AT.Enable = 'off';
            otherwise
                sBottEP.AT.Enable = 'on';
                sBottEP.IT.Enable = 'on';
        end
    else
        sBottEP.AT.Enable = 'off';
        sBottEP.IT.Enable = 'off';
    end

end
