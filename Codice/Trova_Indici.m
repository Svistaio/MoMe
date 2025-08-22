function iR = Trova_Indici(semi)

    % Questa funzione trova gl'indici a partire dal nome della regione

    global sLSel

    if(size(semi,2) == 1) % Se la parola cercata è una stringa
    
        iR = [];
        for r = 1:size(semi,1)
            iN = contains(sLSel.vNR,semi(r,1),'IgnoreCase',true);
            iN = find(iN);
            iR(end+1:end+length(iN)) = iN;
        end

    else % Altrimenti se è un vettore di stringhe
        iR = []; % Inizializzazioni
        iR.iTotali = []; % Vettore di numeri di tutti gl'indici selezionati
        iR.legenda = string([]); % Vettore di stringhe per la legenda

        for r = 1:size(semi,1) % Numero di righe
    
            iR.legenda(end+1) = semi(r,2); % Legenda in inglese
            % iR.legenda(end+1) = semi(r,3); % Legenda in italiano
            iR.(semi(r,1)) = [];          % Vettore degl'indici di una sola regione
    
            iN = contains(sLSel.vNR,semi(r,2),'IgnoreCase',true);
            iN = find(iN);

            iR.(semi(r,1))(end+1:end+length(iN)) = iN;
            iR.iTotali(end+1:end+length(iN))     = iN;
            
        end
    end

end