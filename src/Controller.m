function u = Controller_JNB(input)
%--------------------------------------------INPUTS FROM PREVIOUS BLOCK--------------------------------------------------
w_MGB = input(1);            % Getting flywheel angular velocity
dw_MGB = input(2);           % Getting flywheel angular acceleration
T_MGB = input(3);            % Getting flywheel torque
Q_BT = input(4);               % Getting charge value

%--------------------------------------------GLOBAL VARIABLES --------------------------------------------------
global w_EM_max;             % Define maximum motor angular velocity (Globallly Declared) 
global T_EM_max;             % Define maximum motor torque (Globally Declared)
global Q_BT_IC;              % Define initial battery charge (Globally Declared)

%----------------------------------------STOP TIME FOR SIMULINK MODEL--------------------------------------------------
current_system = get_param(0, 'CurrentSystem'); 
stop_time= str2double(get_param(current_system, 'StopTime'));

%---------------------------------------------CONSTANT VARIABLES--------------------------------------------------
theta_EM = 0.1;              % Define motor inertia
epsilon = 0.01;              % Define epsilon 
u_LPS_max = 0.1;             % Define maximum torque-split factor for LPS 

%---------------------------------------SELECTION OF DRIVING CYCLE NEDC OR FTP-75--------------------------------------------------
 if stop_time == 1220
     T_MGB_th = 60;          % Define LPS Torque threshold for NEDC
     T = 29;                 % Define Electric Drive Torque threshold for NEDC
     u_LPS_min = -.576;      % Define minimum torque-split factor for for NEDC                  
 elseif stop_time == 1877
     T_MGB_th = 100;         % Define torque threshold for FTP-75                       
     T = 32;                 % Define Electric Drive Torque threshold for FTP-75     
     u_LPS_min = -.212;      % Define minimum torque-split factor for for FTP-75     
                                                               
 else
     warning('Please choose NEDC or FTP-75 cycle') 
 end

%======================================RULE BASED STRATEGIES FOR HYBRIDIZATION===========================================

%-------------------------------------------------RGENERATION MODE-------------------------------------------------------
if (T_MGB < 0)               
    u(1) = 0;                   
    u(2) = min((interp1(w_EM_max,-T_EM_max,w_MGB)+abs(theta_EM*dw_MGB)+epsilon)/T_MGB,1); 
    
%--------------------------------------------LOAD POINT SHIDFTING MOTOR--------------------------------------------------
elseif ((T_MGB > T_MGB_th)  &&  Q_BT > (0.8 * Q_BT_IC))     
    u(1) = 1;                                           
    u(2) = min((interp1(w_EM_max,T_EM_max,w_MGB)-abs(theta_EM*dw_MGB)-epsilon)/T_MGB,u_LPS_max);
    
%-----------------------------------------------ELECTRIC DRIVE MODE--------------------------------------------------
elseif ((T_MGB > 0) && (T_MGB < T) && Q_BT >= (0.35*Q_BT_IC)) 
    u(1) = 0;                                           
    u(2) = 1; 

%------------------------------------------LOAD POINT SHIDFTING GENERATOR--------------------------------------------------
elseif (T_MGB > T) && (T_MGB < T_MGB_th )               
    u(1) = 1;                                           
    u(2) = max((interp1(w_EM_max,-T_EM_max,w_MGB)+abs(theta_EM*dw_MGB)+epsilon)/T_MGB,u_LPS_min); 
    
%--------------------------------------------CONVENTIONAL ENGINE MODE--------------------------------------------------
else                                                  
    u(1) = 1;                                           
    u(2) = 0;                                           
end