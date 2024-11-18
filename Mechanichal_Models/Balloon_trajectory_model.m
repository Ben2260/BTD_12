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

%max_volume = 4/3 * pi * (r_max).^3; % 2000g balloon maximum volume before burst
[T,a,P,rho] = atmoscoesa(height); %standard atmosphere for our altitudes
initial_vol =  4/3 * pi * (1.8)^3;
radius = ((3/4)*(P(1)*initial_vol)./(P*pi)).^(1/3);
volume = (4/3)*pi.*(radius).^3;
R = 8.314; %gas constant
M_Hy = 0.002; %molar mass of hydrogen
rho_Hy = (P*M_Hy)./(R*T); %density of hydrogen at different alittudes from IGL
gas_mass= rho_Hy(1)*initial_vol;

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
ascent_accel = F_net/m_tot; %acceleration of total system
ax = zeros(size(ascent_accel));
ay = zeros(size(ascent_accel));
acceleration = [ax; ay; ascent_accel]';

descent_rate = 4.877; %[m/s] from 12ft rocketman parachute chart
avg_velocity = sum(velocity(1:end,3))/length(velocity_balloon);
ascent_time = height(end)/avg_velocity;
t = 0:ascent_time;
init_cond = [0,0,height(1)];
dr = flightpath_ode(t, velocity,acceleration);
[t,dy] = ode45(@flightpath_ode, [0 ascent_time], init_cond);   

function [dydt] = flightpath_ode(t,vel, accel)
    for i = 1:length(vel)
    x(i) = vel(1:(i), 1);
    y(i) = vel(1:(i), 2);
    z(i) = vel(1:(i), 3);
    dx(i) = accel(1:(i),1);
    dy(i) = accel(1:(i),2);
    dz(i) = accel(1:(i),3);
    end
    dydt = [x;y;z;dx;dy;dz]';
    
end

