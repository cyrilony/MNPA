clc
G = zeros(6, 6); 

%Conductance
G0 = 1/R0;
G1 = 1/R1;
G2 = 1/R2;
G3 = 1/R3;
G4 = 1/R4;

%Resistance
R0 = 1000;
R1 = 1;
R2 = 2;
R3 = 10;
R4 = 0.1; 
 
%Variables
g = 100;
Cval = 0.25;
L = 0.2;
vo = zeros(100, 1);
vi = zeros(100, 1);
v3 = zeros(100, 1);


G(1, 1) = 1;                                        
G(2, 1) = G1; G(2, 2) = -(G1 + G2); G(2, 6) = -1;   
G(3 ,3) = -G3; G(3, 6) = 1;                       
G(4, 3) = -g*G3; G(4, 4) = 1;                        
G(5, 5) = -(G4+G0); G(5, 4) = G4;   
G(6, 2) = -1; G(6, 3) = 1;                


C = zeros(6, 6);
C(2, 1) = Cval; C(2, 2) = -Cval;
C(6, 6) = L;
F = zeros(6, 1);
v = 0;

for vin = -10:0.1:10
    v = v + 1;
    F(1) = vin;
    Vm = G\F;
    vi(v) = vin;
    vo(v) = Vm(5);
    v3(v) = Vm(3);
end


figure(1)
plot(vi, vo);
hold on;
plot(vi, v3);
title('DC Sweep (Vin): -10 V to 10 V');
xlabel('Vin')
ylabel('Vo')


vo2 = zeros(1000, 1); 
W = zeros(1000, 1);
Avlog = zeros(1000, 1);

for freq = linspace(0, 100, 1000)
    v = v+1;
    Vm2 = (G+1j*freq*C)\F;
    W(v) = freq;
    vo2(v) = norm(Vm2(5));
    Avlog(v) = 20*log10(norm(Vm2(5))/10);
end 
    
figure(2)
plot(W, vo2)
hold on;
plot(W, Avlog)

title('Vo(w)')
xlabel('w')
ylabel('Av (dB)')


w = pi;
GG = zeros(1000,1);
CC = zeros(1000,1);

for i = 1:1000
    crand = Cval + 0.5*randn();
    C(2, 1) = crand; 
    C(2, 2) = -crand;
    C(3, 3) = L;
    Vm3 = (G+1i*w*C)\F;
    CC(i) = crand;
    GG(i) = 20*log10(norm(Vm3(5))/10);
end

figure(3)
histogram(CC)
figure(4)
histogram(GG)