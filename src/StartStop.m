function state_CE = StartStop(input)

w_MGB = input(1);            % get flywheel angular velocity
dw_MGB = input(2);           % get flywheel angular acceleration
T_MGB = input(3);            % get flywheel torque
Q_BT = input(4);                % get vehicle speed

global Q_BT_IC;

%Get Simulation Stop Time of Current Model
current_system = get_param(0, 'CurrentSystem'); % Now current_system refers to the simulink block.
stop_time= str2double(get_param(current_system, 'StopTime')); % Getting Simulation Stop Time of curremt system.


 if stop_time == 1220
     T = 29;             % 29     % Define Electric Drive Torque threshold for NEDC
     
 elseif stop_time == 1877
     T = 32;               %30.8   % Define Electric Drive Torque threshold for FTP-75      %32
  else
     warning('Unexpected Cycle Type Selected.') % Unexpexted Cycle is selected. Please select Proper Cycle
     
 end

if (T_MGB<0) 
    state_CE=0;
elseif ((T_MGB > 0) && (T_MGB < T) && Q_BT >= (0.34*Q_BT_IC))
    state_CE=0;
else
    state_CE=1;
    
end