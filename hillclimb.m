function [ uf,res ] = hillclimb( f,lap,u0 )

% Erik Lamoureux
% March 1, 2016

% Takes a function, time, and intitial position. Outputs a surface plot
% of the function with a hill climb path from the initial position to the 
% peak of the hill, a column vector of the final position, and the norm
% of the gradient at the final position.

% Define x bounds.
a = -0.5;
b = 2.5;

% Define y bounds.
c = -0.5;
d = 3.0;

% Define tolerable error.
h = 0.1;

% Define differentiators. 
D2x = @(f,x,y) (f(x+h,y)-f(x-h,y))/(2*h);
D2y = @(f,x,y) (f(x,y+h)-f(x,y-h))/(2*h);

% Define x and y from the lower bound to the upper with 
% the tolerable error as the difference between consecutive 
% values. 
x = a:h:b;
y = c:h:d;

% Define x and y over a grid.
[X,Y] = meshgrid(x,y);

% Determine Z.
Z = f(X,Y);

% Plot surface plot.
figure
surf(X,Y,Z);
hold on;

% Determine the numerical gradient vector.
rhs = @(t,u) [D2x(f,u(1),u(2)); D2y(f,u(1),u(2))]; 
% Define the time vector.
tspan=[0 lap]; 
% Set a better accuracy than default
options = odeset('RelTol',1e-6, 'AbsTol', [1e-6 1e-6]); 
% Determine time output and velocity output. Note: tout is not used in this
% function.
[tout, uout] = ode45(rhs, tspan, u0, options);
% Determine the x and y trajectories.
xtraj = uout(:,1); 
ytraj = uout(:,2);

% Plot trajectories.
plot3(xtraj,ytraj,f(xtraj,ytraj)+0.03,'r','Linewidth',5)
hold on;
% Modify plot.
colormap bone;
xlabel('x');
ylabel('y');
zlabel('z');
title('Hill Climbing Path');
hold off;

% Determine final position, and norm of the gradient at this point to be
% outputed. 
j = length(uout);
xf = uout(j,1);
yf = uout(j,2);
uf = [xf;yf];
res = norm([D2x(f,xf,yf) D2y(f,xf,yf)]);

end

