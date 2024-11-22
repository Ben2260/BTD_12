clear
close all
clc
warning('off')
Z = 3.546746135626791e+04; % Taken from acent code
%%Ascent
init_cond = [0,0,Z,0,0,0];
[t,y] = ode45(@(t,y) flightpath_ode(t,y), [0 4000], init_cond);
% Units convert:
height_feet = y(:,3)./0.3048;

%%Descent

%%Freefall

figure(1)
plot(t,height_feet)
hold on
plot(t(end),height_feet(end), 'marker','x', 'markersize',10,'linewidth',2)
xlabel("time")
ylabel('position [ft]')
hold off
function [dydt] = flightpath_ode(t,y)

    % Constants:
    m_tot = 3.5 + 2.2+ 0.5 + 0.15; %freshman payloads + our beacon + parachute + tether + 2000g balloon [kg];
    cd = .97; %estimated coefficient of drag of a weather balloon from google
    R_earth = 6371*1000; %radius of earth in boulder
    GM = (6.6743*10^-11)*(5.97218*10^24);

    
    
    % Unpack the variables
    X = y(1); % X position
    Y = y(2); % Y position
    Z = y(3); % Z position (height)
    vX = y(4); % X velocity
    vY = y(5); % Y velocity
    vZ = y(6); % Z velocity
    if round(Z,-3) ~= 0
        
        [~,~,~,rho] = atmoscoesa(Z); % standard atmosphere for our altitudes
                                     % we nolonger need anything but the air
                                     % density at those heights
        
         g = GM/((R_earth+Z).^2); %gravity with respect to altitude  
        
        % Forces
        weight_force =(m_tot)*g;
        area = 2.98; % [m^2]

     
        Drag = 0.5*cd*vZ.^2.*rho*area; 
    
        F_net = Drag- weight_force;
        ascent_accel = F_net/(m_tot); %acceleration of total system
    
        ax = 0;
        ay = 0;
        az = ascent_accel;
        dydt = [vX; vY; vZ; ax; ay; az];
    else
        dydt = [0;0;0;0;0;0];
    end
end
