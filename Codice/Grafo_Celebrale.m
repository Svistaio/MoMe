
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Codice del progetto di MóMe sul Grafo Neurale o Grafo celebrale %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Imposta la cartella corrente a quella contenente il codice («CreaGrafici.m») qui mostrato
% cd(fileparts(mfilename('fullpath')));
cd(fileparts(matlab.desktop.editor.getActiveFilename));

    % Pulizia generale
clear        % Pulisce le variabili
close all    % Chiude tutte le figure aperte
clc          % Pulisce la finestra dei comandi

    % Raccolta dati dall'utente
[sPL,sPM,sCI,sPT] = Interfaccia_Grafica();

    % Termina il codice se si è premuto il bottone «esci»
global termina
if(termina == 1)
    close all
    return;
end

    % Costruzione delle matrici relativi ai grafi
Assembla_Matrici(sPL,sPT,sPM);

    % Plottaggio delle matrici d'adiacenza, laplaciana e dei gradi
Mostra_Matrici(sPT)

    % Simulazione
Simulazione_Prioni(sPT,sPM,sCI);

    % Rappresentazione grafica dell'evoluzione prionica
Grafici_Prioni(sPM,sPT)

    % Evoluzione dei prioni direttamente sul grafo
Evoluzione_Prioni(sPT,sPM)

    % Stima dei tempi d'omogeneità
Stima_Tempi(sPM)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Salvataggio con matlab2tikz %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Cambio delle unità da normalizzate a centimetri
% set(gcf,'Units','centimeters');

% Pulizia della figura prima del salvataggio
% cleanfigure();

% Salvataggio del grafico in formato «.tex»
% matlab2tikz('../Figure/Prova.tex','floatFormat',%.3f); % Di base è «%.15g»
% matlab2tikz('../Figure/Prova.tex','standalone',true);

