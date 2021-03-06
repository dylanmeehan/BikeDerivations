%Dylan Meehan (dem292@cornell.edu)
%MAE 4900, independent research project, Spring 2019, Advised by Andy Ruina

%Derivation of Lean Angular Acceleration equation for a robotic bicycle
%uses a "simplest" bicycle models, but expands to allow rotational inertia

clear

%define parameters (and gravity)
syms m I1 I2 I3 I13 h b l g real 

%define variables
syms phi phi_dot phi_ddot delta delta_dot v v_dot real

%define unit vectors of beta frame
%I think psi is "ignorable" so I can ingore psi, as well as i_hat and j_hat
lambda = [1 0 0]'; 
n = [0 1 0]';
k = cross(lambda, n);

%calculate unit vectors of C frame (componenents in beta frame)
e_r = cos(phi)*k - sin(phi)*n;
e_phi = -cos(phi)*n - sin(phi)*k;

%%%%%   use psi_ddot and psi_dot from Zhidi's derivation %%%%% 
psi_dot = v*tan(delta)/(l*cos(phi));
psi_ddot = (delta_dot*v*cos(phi)+ v_dot*cos(delta)*cos(phi)*sin(delta)...
    + phi_dot*v*cos(delta)*sin(delta)*sin(phi))/...
    (l*cos(delta)^2*cos(phi)^2);

%%%%%%%%%%%%%%%%%%%     calculate acceration of point G    %%%%%%%%%%%%%%%%
%vectors are expressed in Beta frame
a_GrelBeta = -phi_dot^2*h*e_r + phi_ddot*h*e_phi;
a_CrelO = v_dot*lambda + v*psi_dot*n;
v_GrelBeta = cross(phi_dot*lambda, h*e_r);
r_GrelC = h*e_r + b*lambda;

%angular velocity of beta frame wrt F, in beta components
omega_Beta = psi_dot*k;
omega_dot_Beta = psi_ddot*k;

%angular velocity of bike, C frame
omega_BikeinBeta = phi_dot*lambda + psi_dot*k; %omega of bike expressed in beta frame
omega_dot_BikeinBeta = phi_ddot*lambda + psi_ddot*k + phi_dot*psi_dot*n;

a_G = a_CrelO + a_GrelBeta + cross(omega_Beta, cross(omega_Beta, r_GrelC))...
    + cross(omega_dot_Beta, r_GrelC) + 2*cross(omega_Beta,v_GrelBeta);

%%%%%%%%%%%%%%%%%%       calculate Hdot_relCprime   %%%%%%%%%%%%%%%%%%%%%%%%%%%%


%define intial moment of inertia. Equal to moment of inertia in C frame
I_inC = [ I1   0  I13;  %equivalent to I0
        0   I2  0;
        I13 0  I3  ];
    
R = [  0        0           1;
     -sin(phi)  -cos(phi)   0;
     cos(phi)   -sin(phi)   0];
 
 %calculate moment of inertia in beta frame, expressed in beta frame
I_inBeta = R*I_inC*(R');
 
Hdot_relGinBeta = I_inBeta* omega_dot_BikeinBeta...
           + cross(omega_BikeinBeta, I_inBeta* omega_BikeinBeta)  
 
%rotate Hdot from Beta to F frame
Hdot_GrelCprime = cross(r_GrelC, m*a_G);
 
Hdot_relCprime = Hdot_GrelCprime + Hdot_relGinBeta;
 
%%%%%%%%%%%%%%%%%%%%%%        AMB about C'    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
M_relC = cross(r_GrelC,-m*g*k);

%take AMB and dot with lambda
AMB_eqn = dot(Hdot_relCprime - M_relC, lambda);
AMB_eqn = simplify(AMB_eqn);
AMB_eqn = expand(AMB_eqn)
AMB_eqn = AMB_eqn*(-1); %negate everything
%^there is no I3 term in this, this seems wrong
eqn_Latex = latex(AMB_eqn);


%print matlab lean equation to txt file
fid=fopen('LeanEquationMatlab.txt','w');
fprintf(fid, '%s\n', char(AMB_eqn));
fclose(fid);


