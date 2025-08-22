
    %%% Regioni del cervello %%%

clear
close all
clc

f = figure('Resize','on','Visible','off','NumberTitle','off','Units','Normalized');

global avvia
avvia = 1;
[sPNG,sLNG] = Cervello3D([]);

campi = string(fieldnames(sLNG));
for l = 1:length(campi)
    sLNG.(campi(l)).Linea.Visible = 'off';
end

    % Ricerca degl'indici dei nodi delle regioni d'interesse
nomiR = [
    "T"  "Temporal"  "Temporale"
    "F"  "Frontal"   "Frontale"
    "P"  "Parietal"  "Parietale"
    "O"  "Occipital" "Occipitale"
    "L"  "Limbic" "Limbico"
    "BG" "Basal ganglia" "Gangli basali"
    "BS" "Brainstem" "Tronco encefalico"
    % "entorhinal"
];
iNR = Trova_Indici(nomiR);

if(isstruct(iNR))
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
    
        % Plottamento delle specifiche regioni
    sI.Linea  = "-"; sI.SpessL = 2;
    for r = 1:length(reg)-2                
        iR = iNR.(reg(r+2));   % Indici dei nodi nella regione
        nR = length(iR);       % Numero dei nodi nella regione
    
        for i = 1:nR
            campo = append("N",string(iR(i)));
            sPNG.(campo).FaceColor = colori.(reg(r+2));
        end
    end
else
    for n = 1:length(iNR)
        campo = append("N",string(iNR(n)));
        sPNG.(campo).FaceColor = [1 0 1];
    end
end

grid off
axis off;

view(55,10)
exportgraphics(gcf,'../Figure/nodiInfettiCervello.png','BackgroundColor','none','Resolution',750);

% view(0,0)
% exportgraphics(gcf,'../Figure/regioniCervelloFronte.png','BackgroundColor','none','Resolution',750);

% view(90,0)
% exportgraphics(gcf,'../Figure/regioniCervelloLato.png','BackgroundColor','none','Resolution',750);

% view(90,90)
% exportgraphics(gcf,'../Figure/regioniCervelloAlto.png','BackgroundColor','none','Resolution',750);