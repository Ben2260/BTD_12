clear
close all
clc

m_tot = 7.2 + 2.2+ 0.5 + 0.2 +2; %freshman payloads + our beacon + parachute + tether + 2000g balloon [kg];
height = 1524:32004; %altitudes in meters
R_earth = 6371*1000; %radius of earth in boulder
GM = (6.6743*10^-11)*(5.97218*10^24);
g= GM./(R_earth+height).^2; %gravity with respect to altitude  
wind_vel = zeros(size(height));
%r_max = 5.25; %bust radius of 2000g balloon [m]
initial_r = 1.8;

%max_volume = 4/3 * pi * (r_max).^3; % 2000g balloon maximum volume before burst
[T,a,P,rho] = atmoscoesa(height); %standard atmosphere for our altitudes
initial_vol =  4/3 * pi * (initial_r)^3;
R = 8.314; %gas constant
M_Hy = 0.002; %molar mass of hydrogen
rho_Hy = (P*M_Hy)./(R*T); %density of hydrogen at different alittudes from IGL
gas_mass= rho_Hy(1)*initial_vol;
radius = initial_r +((3*gas_mass*R.*T)./(4*pi.*P)).^(1/3); %((3/4)*(P(1)*initial_vol)./(P*pi)).^(1/3);
volume = (4/3)*pi.*(radius).^3;


%%Forces
weight_force =(m_tot+gas_mass)*g;
Buoyancy_F = rho.*volume.*g; %Buoyancy force of our balloon 
cd = .47; %estimated coefficient of drag of a weather balloon from google
velocity_balloon = sqrt((8*g.*((rho-rho_Hy).*volume-m_tot-gas_mass))./(4*cd*rho.*radius.^2*pi)); %sqrt((8*radius.*-g.*(rho_Hy-rho))./(3*cd*rho));
Drag = 0.5*cd*velocity_balloon.^2.*rho*pi.*radius.^2;
vx = zeros(size(velocity_balloon));
vy = zeros(size(velocity_balloon));
velocity = [vx;vy;velocity_balloon]';
F_net = Buoyancy_F - weight_force - Drag; 
ascent_accel = F_net/(m_tot+gas_mass); %acceleration of total system
ax = zeros(size(ascent_accel));
ay = zeros(size(ascent_accel));
acceleration = [ax; ay; ascent_accel]';

descent_rate = 4.877; %[m/s] from 12ft rocketman parachute chart
avg_velocity = sum(velocity(1:end,3))/length(velocity_balloon);
ascent_time = height(end)/avg_velocity;
t = 0:10000000;
init_cond = [0,0,height(1),0,0,0];
[t,y] = ode45(@(t,y) flightpath_ode(t,y), [0 1000000], init_cond);   
plot(t,y(:,3))
function [dydt] = flightpath_ode(t,y)

    % Constants:
    R = 8.314; %gas constant
    M_Hy = 0.002; %molar mass of hydrogen
    m_tot = 7.2 + 2.2+ 0.5 + 0.2 +2; %freshman payloads + our beacon + parachute + tether + 2000g balloon [kg];
    cd = .47; %estimated coefficient of drag of a weather balloon from google
    R_earth = 6371*1000; %radius of earth in boulder
    GM = (6.6743*10^-11)*(5.97218*10^24);
    initial_r = 1.8;
    initial_vol =  4/3 * pi * (initial_r)^3;
    gas_mass = 0.072888535093877*initial_vol;
    

    % Unpack the variables
    X = y(1); % X position
    Y = y(2); % Y position
    Z = y(3); % Z position (height)
    vX = y(4); % X velocity
    vY = y(5); % Y velocity
    vZ = y(6); % Z velocity

    [T,~,P,rho] = atmoscoesa(Z); %standard atmosphere for our altitudes
    g= GM./(R_earth+Z).^2; %gravity with respect to altitude  
    radius = initial_r +((3*gas_mass*R.*T)./(4*pi.*P)).^(1/3); %((3/4)*(P(1)*initial_vol)./(P*pi)).^(1/3);
    volume = (4/3)*pi.*(radius).^3;
    rho_Hy = (P*M_Hy)./(R*T); %density of hydrogen at different alittudes from IGL
    
    % Forces
    weight_force =(m_tot+gas_mass)*g;
    Buoyancy_F = rho.*volume.*g; %Buoyancy force of our balloon 
    %velocity_balloon = sqrt((8*g.*((rho-rho_Hy).*volume-m_tot-gas_mass))./(4*cd*rho.*radius.^2*pi));
    Drag = 0.5*cd*vZ.^2.*rho*pi.*radius.^2;

    F_net = Buoyancy_F - weight_force - Drag;
    ascent_accel = F_net/(m_tot+gas_mass); %acceleration of total system

    ax = 0;
    ay = 0;
    az = ascent_accel;


    dydt = [vX; vY; vZ; ax; ay; az];
end
% [t, y] = ode45(@(t, y) balloon_ode(t, y, accel_grav, n, M_Hy, Vol_init, m_tot, F_Wx, F_Wy, F_Wz), tspan, initial_conditions);
% 
% function dydt = balloon_ode(t, y, accel_grav, n, M_Hy, Vol_init, m_tot, F_Wx, F_Wy, F_Wz)
%     % Unpack the variables
%     x = y(1); % X position
%     y_pos = y(2); % Y position
%     z = y(3); % Z position (height)
%     vx = y(4); % X velocity
%     vy = y(5); % Y velocity
%     vz = y(6); % Z velocity
% 
%     % Buoyant force
%     F_b = (M_Hy * n / Vol_init) * Vol_init * accel_grav(z);
% 
%     % Gravitational force
%     F_g = accel_grav(z) * m_tot;
% 
%     % Net forces
%     Fx = F_Wx;
%     Fy = F_Wy;
%     Fz = F_Wz + F_b - F_g;
% 
%     % Equations of motion
%     dydt = [vx; vy; vz; Fx / m_tot; Fy / m_tot; Fz / m_tot];
% end
