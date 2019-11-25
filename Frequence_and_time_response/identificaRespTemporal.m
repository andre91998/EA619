% inicializa a remoteAPI
vrep=remApi('remoteApi');
% por seguranca, fecha todas as conexoes abertas
vrep.simxFinish(-1);
%se conecta ao V-rep usando a porta 19997 (mesmo computador)
clientID=vrep.simxStart('127.0.0.1',19997,true,true,5000,5);

if clientID == -1
    fprintf('aconteceu algum problema na conexao com o servidor da remoteAPI!\n');
    return;
end

% escolhe a comunicacao sincrona
vrep.simxSynchronous(clientID,true);

% pega um handle para a massa superior (chamada de topPlate). Ele sera
% usado para aplicarmos a forca.
[err,h]=vrep.simxGetObjectHandle(clientID,'SpringDamper_topPlate',vrep.simx_opmode_oneshot_wait);

% pega a posicao inicial da massa
[res,posTopPlate]=vrep.simxGetObjectPosition(clientID,h,-1,vrep.simx_opmode_oneshot_wait);

% coloca a posicao (tres coordenadas, mas apenas a z vai interessar) na
% variavel position.
position = posTopPlate;

%aplica a forma de -50 N na massa (a forca eh aplicada no centro de massa)
[res retInts retFloats retStrings retBuffer]=vrep.simxCallScriptFunction(clientID,'myFunctions',vrep.sim_scripttype_childscript,'addForceTo',[h],[0.0,0.0,0,0,0,-100],[],[],vrep.simx_opmode_blocking);

% espera sincronizar
vrep.simxSynchronousTrigger(clientID);

% ajusta o passo de tempo (deve ser o mesmo que esta ajustado no v-rep)
timeStep = 0.01;

%inicializa o tempo da simulacao.
timeSim=0;
% laco principal (fica ate nao haver mudanca significativa na posicao da
% massa)
posicao=[]; %50:1;
x=1;
Flag=0;
while timeSim < 2

    % faz a leitura da posicao da massa
    [res,posTopPlate]=vrep.simxGetObjectPosition(clientID,h,-1,vrep.simx_opmode_oneshot_wait);
    
    %imprime na tela
    fprintf('posicao = [%.5f,%.5f,%.5f]\n',posTopPlate(1),posTopPlate(2),posTopPlate(3));
    
    %guarde a nova posicao posTopPlate aqui...
    
    timeSim=[timeSim timeSim(1,end)+timeStep];
    
    % espera sincronizar
    vrep.simxSynchronousTrigger(clientID);
    
    % se a posicao z da massa no instante atual nao for muito diferente da posicao z do
    % instante de tempo anterior, poderia terminar a simulacao.Acrescente 
    % aqui uma condicao para terminar (nao eh obrigatorio)
    if Flag==0
        pos_inicial=posTopPlate(3);
    end    
    Flag=1;
    
    posicao(x,1) = posTopPlate(3)-pos_inicial;
    x=x+1;
end

% chama o destrutor
vrep.delete(); % call the destructor!

fprintf('Simulacao terminada!\n');
plot(timeSim(1:end-1),posicao);