%% Initial constants

m_tot = 7.2 + 2.2 + 0.5 + 0.2 + 2; 
R = 8.314;                  
G = (6.6743 * 10^-11);        
M_Hy = 0.002;               
radi_sea = 6378.137 * 1000;        
mass_eart = 5.972 * 10^24;    
radi_DtCO = 1.581912 * 1000;       

%% Anonymous functions:
% Acceleration due to gravity with respect to height.
accel_grav = @(r) (G * mass_eart) / (r + radi_DtCO)^2;

% Volume of a sphere
volu_sphe = @(r) (4/3) * pi * r^3;

%% Manufacturer constants:
Vol_init = 3.89;            
Pres_Burst = 5.3 * 100;       
alti_Burst = 35.4;          
volu_Burst = volu_sphe(1054 / 100);
[T, ~, ~, ~] = atmoscoesa(1000 * (radi_DtCO / 1000 + alti_Burst), "Error");
n = (Pres_Burst * volu_Burst) / (R * T);

%% Wind values:
F_Wx = 0;
F_Wy = 0;
F_Wz = 0;

%% Initial flight conditions:
posi_init = [0, 0, radi_DtCO];
Velo_init = [0, 0, 0];
acce_init = [F_Wx, F_Wy, F_Wz + accel_grav(0) * m_tot];

%% Define the differential equations with parameters
function dydt = balloon_ode(t, y, accel_grav, n, M_Hy, Vol_init, m_tot, F_Wx, F_Wy, F_Wz)
    % Unpack the variables
    x = y(1); % X position
    y_pos = y(2); % Y position
    z = y(3); % Z position (height)
    vx = y(4); % X velocity
    vy = y(5); % Y velocity
    vz = y(6); % Z velocity
    
    % Buoyant force
    F_b = (M_Hy * n / Vol_init) * Vol_init * accel_grav(z);
    
    % Gravitational force
    F_g = accel_grav(z) * m_tot;
    
    % Net forces
    Fx = F_Wx;
    Fy = F_Wy;
    Fz = F_Wz + F_b - F_g;
    
    % Equations of motion
    dydt = [vx; vy; vz; Fx / m_tot; Fy / m_tot; Fz / m_tot];
end

function dydt = decent_balloon_ode(t, y, accel_grav, n, M_Hy, Vol_init, m_tot, F_Wx, F_Wy, F_Wz)
    % Unpack the variables
    x = y(1); % X position
    y_pos = y(2); % Y position
    z = y(3); % Z position (height)
    vx = y(4); % X velocity
    vy = y(5); % Y velocity
    vz = y(6); % Z velocity
    
    
    % Gravitational force
    F_g = accel_grav(z) * m_tot;
    
    % Net forces
    Fx = F_Wx;
    Fy = F_Wy;
    Fz = F_Wz - F_g;
    
    % Equations of motion
    dydt = [vx; vy; vz; Fx / m_tot; Fy / m_tot; Fz / m_tot];
end

% Initial conditions [x, y, z, vx, vy, vz]
initial_conditions = [0, 0, radi_DtCO, 0, 0, 0];

% Time span (up to burst altitude)
tspan = [0, 3600]; % Simulate up to 1 hour (3600 seconds)

% Use ode45 with parameters passed via anonymous function
[t, y] = ode45(@(t, y) balloon_ode(t, y, accel_grav, n, M_Hy, Vol_init, m_tot, F_Wx, F_Wy, F_Wz), tspan, initial_conditions);

% Use ode45 with parameters passed via anonymous function
[fall_t, fall_y] = ode45(@(t, y) balloon_ode(t, y, accel_grav, n, M_Hy, Vol_init, m_tot, F_Wx, F_Wy, F_Wz), tspan, initial_conditions);

%% Initial constants
m_tot = 7.2 + 2.2 + 0.5 + 0.2 + 2; 
R = 8.314;                  
G = (6.6743 * 10^-11);        
M_Hy = 0.002;               
radi_sea = 6378.137 * 1000;        
mass_eart = 5.972 * 10^24;    
radi_DtCO = 1.581912 * 1000;       

%% Anonymous functions:
% Acceleration due to gravity with respect to height.
accel_grav = @(r) (G * mass_eart) / (r + radi_DtCO)^2;

% Volume of a sphere
volu_sphe = @(r) (4/3) * pi * r^3;

%% Manufacturer constants:
Vol_init = 3.89;            
Pres_Burst = 5.3 * 100;       
alti_Burst = 35.4;          
volu_Burst = volu_sphe(1054 / 100);
[T, ~, ~, ~] = atmoscoesa(1000 * (radi_DtCO / 1000 + alti_Burst), "Error");
n = (Pres_Burst * volu_Burst) / (R * T);

%% Wind values:
F_Wx = 0;
F_Wy = 0;
F_Wz = 0;

%% Initial flight conditions:
posi_init = [0, 0, radi_DtCO];
Velo_init = [0, 0, 0];
acce_init = [F_Wx, F_Wy, F_Wz + accel_grav(0) * m_tot];


% Initial conditions [x, y, z, vx, vy, vz]
initial_conditions = [0, 0, radi_DtCO, 0, 0, 0];

% Time span (up to burst altitude)
tspan = [0, 3600]; % Simulate up to 1 hour (3600 seconds)

% Use ode45 with parameters passed via anonymous function
[t, y] = ode45(@(t, y) balloon_ode(t, y, accel_grav, n, M_Hy, Vol_init, m_tot, F_Wx, F_Wy, F_Wz), tspan, initial_conditions);

% Extract the solutions
x = y(:, 1);
y_pos = y(:, 2);
z = y(:, 3);

% 3D Plot of the balloon's ascent
figure;
plot3(x, t, z+1500, '-b', 'LineWidth', 2);
grid on;
xlabel('X Position (meters)');
ylabel('Time (seconds)');
zlabel('Altitude (meters)');
title('3D Flight Path of Weather Balloon');
legend('Weather Balloon Path');


fall_x = fall_y(:, 1);
fall_y_pos = fall_y(:, 2);
fall_z = fall_y(:, 3) + z(1);


figure;
plot(flip(fall_t+t(end)), flip(fall_z'), '-r', 'LineWidth', 2);
grid on;
xlabel('Time (seconds)');
ylabel('Altitude (km)');

title('3D Flight Path of Weather Balloon');
legend('Weather Balloon Path');
