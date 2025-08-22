function Stima_Tempi(sPM)

    global L
    
    tauD = 1/norm(L(0)); % Scala temporale diffusiva

    switch sPM.modello
        case "FK"
            % disp(74.6034^2/norm(L(0))) % Scala temporale diffusiva con lunghezza
            tauC = 1/sPM.alfa;     % Scala temporale della crescita
        case "ED" % Riformularlo col max
            % disp(74.6034^2/norm(L(0))) % Scala temporale diffusiva con lunghezza
            tauC = max([1/sPM.k1 1/sPM.k1tilde]);     % Scala temporale della crescita
        case "SMO"
            % disp(74.6034^2/norm(L(0))) % Scala temporale diffusiva con lunghezza
            nC = sPM.nC; mi = sPM.k2; beta = sPM.f;
    
            A = zeros(nC-2);
            for i=2:nC-1
                for j=2:nC-1
                    if(i==2)
                        A(i-1,i-1) = -mi;
                    else
                        A(i-1,i-1) = -mi-(beta/2)*(i-3);
                    end
                    if(i<=nC-3)
                        A(i-1,i+1:end) = -mi;
                    end
                end
            end
            autoV = abs(eig(A))';
    
            iANN = autoV>0; % Indici [logici] degli autovalori non nulli
            tauC = max([1/sPM.k1 1./autoV(iANN)]); % Scala temporale della crescita
            % disp(sum([1/sPM.k1 1./autoV(iANN)]==tauN))
    end
    
    f = @(tauD,tauN) log10(tauD/tauN+1)/(20/9)+1;
    Th = 10*tauC*f(tauD,tauC);
    
    % f = @(tauD) (9/20)*log10(tauD+1)+1;
    % Th = 10*tauC*f(tauD);

    Tab = table([tauD floor(round(log10(tauD),10))]',...
                [tauC floor(round(log10(tauC),10))]',...
                [Th floor(round(log10(Th),10))]',...
                'VariableNames',{'tauD','tauC','Th'});
    disp(Tab)

end