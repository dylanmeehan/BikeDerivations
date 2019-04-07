syms delta v delta_dot g phi 
l = 1.02;
b= 0.3;
h = 0.9;
m=94;
I1=9.2;
I13=2.4


denominator = (h*l+I1*l/(h*m));
phi_ddot = g*l*phi/denominator ...
        - delta_dot*v*b/denominator...
        - delta*v^2/denominator...
        +I13*delta_dot*v/(l*m*h^2+I1*l)