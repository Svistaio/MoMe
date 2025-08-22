function [sPN,sLN] = Cervello3D(f)

    global avvia A

        %%% Sagoma (superficie corticale) del cervello %%%
    vertici   = readmatrix('..\Dati\vertices.txt');
    triangoli = readmatrix('..\Dati\triangles.txt')+1;
    
        % Riduzione della complessità della triangolazione
    [triangoliR,verticiR] = reducepatch(triangoli,vertici,0.3);

    rotO = [0  1  0
           -1  0  0
            0  0  1]; % Rotazione oraria 3D
    
    verticiR = (rotO*verticiR')';
    
    trisurf(triangoliR,verticiR(:,1),verticiR(:,2),verticiR(:,3),'PickableParts','none', ...
            'FaceColor',[.6 .6 .6],'EdgeColor','none','FaceAlpha',0.025)
    
    hold on

        %%% Nodi del grafo celebrale %%%
    tabCoord = readtable('../Dati/3D_Graph_Nodes_Coordinates','TextType','string');
    
    cPN = table2array(tabCoord(:,4:6)); % Coordinate punti celebrali
    cPN = (rotO*rotO*cPN')';            % Rotazione oraria di 180°
    nN = size(cPN,1);                   % Numero di nodi
    barN = sum(cPN,1)/nN;               % Baricentro dei nodi
    cPN = cPN - barN;                   % Centro nell'origine

        % Raggio, fattore di scala e numero di facce della sfera
    r = 2.5; m = 2; nF = 10;
    [xSfera,ySfera,zSfera] = sphere(nF);

    sPN = []; % Struttura dei punti dei nodi
    for p = 1:nN

        xP = r*xSfera + m*cPN(p,1);
        yP = r*ySfera + m*cPN(p,2);
        zP = r*zSfera + m*cPN(p,3);

        campo = append("N",string(p));
        sPN.(campo) = surf(xP,yP,zP,'FaceColor',[0.5 0.5 0.5],'FaceAlpha',1,'EdgeColor','none');
        if(~isempty(f))
            sPN.(campo).ButtonDownFcn = @(src,event) f(src,event,p);
        else % Se è presente una funzione di richiamo la si associa ai nodi
            sPN.(campo).HitTest = 'off';
        end % Altrimenti si disattiva la loro interazione 

        material(sPN.(campo),[.9 1 1 10 .5]); % [AmbientStrength DiffuseStrength SpecularStrength SpecularExponent SpecularColorReflectance]
        % La [quasi] perfezione: [1 1 1 10 .5] con intensità luminosa «luce = camlight(45,45); luce.Color = [.5 .5 .5];»
        % Il quintetto [.5 .75 .5 10 .25] sembra essere una buona combinazione

    end

    view(0,0)

    sPN.nN     = nN;         % Numero di nodi
    sPN.vNSC  = zeros(nN,1); % Vettore [binario] dei nodi selezionati correnti
    sPN.vNSP  = zeros(nN,1); % Vettore [binario] dei nodi selezionati precedenti
    sPN.CoordP = cPN;        % Coordinate dei punti
    sPN.r      = r;          % Raggio delle sfere
    sPN.m      = m;          % Fattore di scala
    sPN.nF     = nF;         % Numero di facce della sfera

        % impostazioni per la luce cosí da dare un effetto 3D
    lighting gouraud;

    iL = .5;% intensità luce
        % Luce obliqua
    luce = camlight(45,45); luce.Color = [iL iL iL];

    % iL = .25;% intensità luce
    %     % Luce anteriore
    % luce = camlight(0,0); luce.Color = [iL iL iL];
    %     % Luce laterale destra
    % luce = camlight(90,0); luce.Color = [iL iL iL];
    %     % Luce laterale sinistra
    % luce = camlight(-90,0); luce.Color = [iL iL iL];
    %     % Luce superiore
    % luce = camlight(0,90); luce.Color = [iL iL iL];

    %     % Luce posteriore
    % luce = camlight(180,0); luce.Color = [iL iL iL];
    %     % Luce inferiore
    % luce = camlight(0,-90); luce.Color = [iL iL iL];

    % camlight headlight;
    % camlight(45,0);
    % camlight(-45,0);

    axis equal


        %%% Lati del grafo celebrale %%%
    sLN = []; % Struttura dei lati tra i nodi
    cPN = m*cPN;

    if(avvia)

        AI   = A(0); % Matrice d'adiacenza al tempo iniziale
        AMax = max(AI,[],'all');
        AMin = min(AI,[],'all');

            % Funzione lineare che associa LMax<->1.5 e LMin<->1
        interp = @(x,a,b) a*(AMax-x)/(AMax-AMin)+b*(x-AMin)/(AMax-AMin);
        colori = colormap("jet");

        for i = 1:nN-1
            for j = i+1:nN
    
                Aij = AI(i,j);
                if(Aij ~= 0)
                    campo = append('L',string(i),string(j));
                    sLN.(campo).Linea = line(cPN([i j],1),cPN([i j],2),cPN([i j],3), ...
                                       'PickableParts','none','LineWidth',interp(Aij,.5,4));
                    sLN.(campo).Linea.Color = [colori(floor(interp(Aij,0,255))+1,:) .3];
                    sLN.(campo).pi = i;
                    sLN.(campo).pf = j;
                end

            end
        end

    end % Se il codice è avviato si disegnano i lati secondo la L

end

