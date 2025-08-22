function Mostra_Matrici(sPT)

    global L A G

    condLD = sPT.CondLD;

    sF = [];
    sF.x=0; sF.y=0; sF.l=1; sF.a=0.55;
    sF.p = [sF.x sF.y sF.l sF.a];

    if(condLD == 0) % Se la L è statica

        f = figure('Name',"Matrici della simulazione",'Resize','off', ...
                   'NumberTitle','off','Units', 'Normalized','Position',sF.p);
        movegui(f,'center'); % Muove la figura al centro

        tiledlayout(1,3,"TileSpacing","compact","Padding","compact")

            % Rappresentazione della matrice laplaciana
        nexttile
        imagesc(L(0)); axis xy; colorbar; colormap(jet); title("L");
    
            % Rappresentazione della matrice dei gradi
        nexttile
        imagesc(G(0)); axis xy; colorbar; colormap(jet); title("G");
    
            % Rappresentazione della matrice d'adiacenza
        nexttile
        imagesc(A(0)); axis xy; colorbar; colormap(jet); title("A");

    else % Altrimenti se la L è dinamica

        sF.p(4) = sF.p(4)+0.05;
        f = figure('Name',"Matrici della simulazione",'Resize','off', ...
                   'NumberTitle','off','Units', 'Normalized','Position',sF.p);
        movegui(f,'center'); % Muove la figura al centro

        sF.p(3) = sF.p(3)-0.075; sF.p(4) = sF.p(4)+0.15;
        sF.p(1) = (1-sF.p(3))/2-0.01; sF.p(2) = 1-0.05-sF.p(4);
        tiledlayout(1,3,"TileSpacing","compact","Padding","compact","Position",sF.p)


                %%% Immagini %%%
        global sMatrici

            % Rappresentazione della matrice laplaciana
        nexttile
        sMatrici.L = imagesc(L(0)); axis xy; colorbar; colormap(jet); title("L");
    
            % Rappresentazione della matrice dei gradi
        nexttile
        sMatrici.G = imagesc(G(0)); axis xy; colorbar; colormap(jet); title("G");
    
            % Rappresentazione della matrice d'adiacenza
        nexttile
        sMatrici.A = imagesc(A(0)); axis xy; colorbar; colormap(jet); title("A");


                %%% Bottoni %%%
        global sBottMM contM
        contM = 0;

        sB = [];
        sB.dimT = 12;
        sB.sl = 0.002;

        sB.l = 0.075; sB.a = 0.09;
        sB.x = 0.5-0.01-(2*sB.sl+3*sB.l)/2; sB.y = 0.04;
        sB.P = [sB.x sB.y sB.l sB.a];

            % Indientro
        bottIT = uicontrol('Style','pushbutton','Enable','on','FontSize',sB.dimT,'String','Indientro', ...
                           'Units', 'Normalized','Position',sB.P,'CallBack',{@FRIndietro,sPT.dt});
        sBottMM.ITM = bottIT;
    
            % Istanti
        sB.x = sB.x + sB.l + sB.sl;
        sB.P = [sB.x sB.y sB.l sB.a];
        listaIstanti = append("Passo ",string(0:sPT.nt)'," - Tempo ",string((0:sPT.nt)*sPT.dt)');
        bottT = uicontrol('Style','popupmenu','Value',1,'Enable','on','FontSize',sB.dimT,'String',listaIstanti, ...
                          'Units', 'Normalized','Position',sB.P,'CallBack',{@FRIstanti,sPT.dt});
        sBottMM.TM = bottT;
    
            % Salto
        sB.a = sB.a/2; sB.l = sB.l/2; sB.x = sB.x + sB.l;
        sB.P = [sB.x sB.y sB.l sB.a];
        bottST = uicontrol('Style','edit','Units','Normalized','Enable','on','FontSize',sB.dimT, ...
                            'String',num2str(floor(sPT.nt/10)),'Position',sB.P);
        sBottMM.STM = bottST;
    
        sB.x = sB.x - sB.l; sB.P = [sB.x sB.y sB.l sB.a*0.85];
        uicontrol('Style','text','Units','Normalized','Enable','on',...
                  'FontSize',sB.dimT,'String','Salto:','Position',sB.P);
    
            % Avanti
        sB.a = sB.a*2; sB.l = sB.l*2; sB.x = sB.x + sB.l+sB.sl;
        sB.P = [sB.x sB.y sB.l sB.a];
        bottAT = uicontrol('Style','pushbutton','Enable','on','FontSize',sB.dimT,'String','Avanti', ...
                          'Units', 'Normalized','Position',sB.P,'CallBack',{@FRAvanti,sPT.nt,sPT.dt});
        sBottMM.ATM = bottAT;
    
    end

        % Alternativa equivalente a «imagesc»
    % pcolor(A); shading flat; colorbar;
        
        % Esporta la figura «f» con nome «Nome_Filza» e formato «formato» (a.e. «.png», «.jpg», ecc.) nel percorso «Percoso» (a.e. «C:/Users/Valerio/Desktop/Scaricati»)
    % exportgraphics(f,'C:/Users/Valerio/Desktop/Scaricati/DNO SE 50.png','Resolution',250)

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Funzioni di richiamo %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function FRIndietro(~,~,dt)
    
    global contM sBottMM
    
    salto = str2double(sBottMM.STM.String);
    if(contM-salto>1)
        contM = contM-salto;
        Aggiorna_Matrici(contM*dt)
    else
        contM = 1;
        Aggiorna_Matrici(contM*dt)
    end
    sBottMM.TM.Value = contM;

end

function FRIstanti(srg,~,dt)
    
    global contM

    contM = srg.Value;
    Aggiorna_Matrici(contM*dt)

end

function FRAvanti(~,~,nt,dt)
    
    global contM sBottMM

    salto = str2double(sBottMM.STM.String);
    if(contM+salto<nt+1)
        contM = contM+salto;
        Aggiorna_Matrici(contM*dt)
    else
        contM = nt+1;
        Aggiorna_Matrici(contM*dt)
    end
    sBottMM.TM.Value = contM;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Funzioni ausiliari %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%

function Aggiorna_Matrici(t)

    global sMatrici
    global L A G
    
    sMatrici.L.CData = L(t);
    sMatrici.G.CData = G(t);
    sMatrici.A.CData = A(t);

end
