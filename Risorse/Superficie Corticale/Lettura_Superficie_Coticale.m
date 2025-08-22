
    % Estrazione delle info relative alla filza h5
nomeFilzaH5 = 'Superficie_Corticale.h5';
info = h5info(nomeFilzaH5);

    % Scansione di tutti gl'insiemi di dati
for i = 1:length(info.Datasets)

        % Nome dell'insieme dei dati e relativo percorso nella filza h5
    nomeDati = info.Datasets(i).Name;
    percorso = ['/' nomeDati];

        % Dati dall'insieme
    data = h5read(nomeFilzaH5,percorso);
    data = data';

        % Nome della filza in uscita
    nomeFilzaTxt = [nomeDati '.txt'];

    if(~isempty(data))
        writematrix(data,nomeFilzaTxt,'Delimiter',',');
        fprintf('Salvato: %s\n', nomeFilzaTxt);
    end % Se i dati non sono vuoti li salva in una filza di testo

end

vertici   = readmatrix('.\vertices.txt');
triangoli = readmatrix('.\triangles.txt')+1;

rotO = [0 -1  0
        1  0  0
        0  0  1]; % Rotazione antioraria 3D

vertici = (rotO*vertici')';

trisurf(triangoli,vertici(:,1),vertici(:,2),vertici(:,3),...
        'FaceColor',[0.6 0.6 0.6],'EdgeColor','none','FaceAlpha',0.075)

lighting phong;  
camlight headlight;
material dull;

hold on 

tabCoord = readtable('../Dati/3D_Graph_Nodes_Coordinates','TextType', 'string');

[xSfera,ySfera,zSfera] = sphere(50);
cPN = table2array(tabCoord(:,4:6)); % Coordinate punti celebrali
nN = size(cPN,1); % Numero di nodi

barN = sum(cPN,1)/nN; % Baricentro dei nodi
cPN = cPN - barN;
r = 2.5; m = 2;

for p = 1:nN
    xP = r*xSfera + m*cPN(p,1);
    yP = r*ySfera + m*cPN(p,2);
    zP = r*zSfera + m*cPN(p,3);

    surf(xP,yP,zP,'FaceColor',[0.5 0.5 0.5],'FaceAlpha', 0.5,'EdgeColor','none');
    hold on
end
hold off

view(0,0)