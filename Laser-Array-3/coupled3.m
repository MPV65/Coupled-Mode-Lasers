function [dN] = coupled3(~, N0, param)
%
%   TO BE CHANGED TO 3 LASER ARRAY
%
%COUPLEDInj Rate equations for the coupled mode model with optical
%injection and asymmetric coupling.
%%
% *COUPLEDInj*
%
%%  Description
%
% Provides the rate equations for the coupled mode model with optical
% injection. The implementation is for the model given in [1], although
% with the opposite sign convention taken for the phases on the optical
% fields, as used in [2] for direct comparison with the model without
% injection.
%  
% This routine is used directly by the Runge-Kutta solver (ode45) and 
% indirectly (via coupledInjS) in conjunction with the nonlinear solver 
% (fsolve).
%  
% [1] N. Li et al, Sci Rep 8, 109 (2018)
% [2] M.J. Adams et al, Phys. Rev. A 95(5), 053869 (2017)
%
%%  Usage
%
%    dN = coupledInj(t, N0, param);
%
%%  Arguments
%
%    t          An array of time steps (not used in the routine, but 
%               required for Runge-Kutta implementation).
%
%    N0         Vector of inital conditions for the equations:
%
%    Carrier concentrations:
%       MA   = N0(1)        Carrier concentration in guide A
%       MB   = N0(2)        Carrier concentration in guide B
%    Optical fields:
%       YA   = N0(3)        Amplitude in guide A
%       YB   = N0(4)        Amplitude in guide B
%       phiA = N0(5)        Phase of optical field in guide A
%       phiB = N0(6)        Phase of optical field in guide B
%
%    param      a structure containing the parameters:
%
%       param.yn        carrier recombination rate (1/tau_N)
%       param.kp        cavity loss rate (1/(2*tau_p))
%       param.aH        Linewidth enhancement factor
%       param.kinj      Injection level rate (K_inj/tau_N)
%       param.DWA       Free-running minus laser A angular frequency 
%       param.DWB       Free-running minus laser B angular frequency 
%       param.DWinj 	Injection detuning (W_inj - W)
%       param.QA        Normalised pumping rate in guide A    
%       param.QB        Normalised pumping rate in guide A 
%       param.etaAB     Amplitude of coupling coefficient AB (asymmetric)
%       param.etaBA     Amplitude of coupling coefficient BA (asymmetric) 
%       param.theta     Phase of coupling coefficient 
%
%%  Returns
%
%    dN         An array of the derivatives of the variables in N0
%
%%  Notes
%
%
%%

    MA = N0(1);         % Carrier concentration in guide A
    MB = N0(2);         % Carrier concentration in guide A
    YA = N0(3);         % Amplitude in guide A
    YB = N0(4);         % Amplitude in guide B
    phiA = N0(5);       % Phase of field in guide A 
    phiB = N0(6);       % Phase of field in guide B 
    
    phi = phiB - phiA;  % Relative phase between fields in B and A
    
    % Intensities (all values real)
    IA = YA*YA;
    IB = YB*YB;

    yn = param.yn;          % 1/(tau_N) - carrier recombination rate
    kp = param.kp;          % 1/(2*tau_p) - cavity loss rate
    aH = param.aH;          % Linewidth enhancement factor
    kinj = param.kinj;      % Injection level rate (K_inj/tau_N)
    DWA = param.DWA;        % Free-running minus laser A angular frequency 
    DWB = param.DWB;        % Free-running minus laser B angular frequency 
    DWinj = param.DWinj; 	% Injection detuning (W_inj - W)
    QA = param.QA;          % Normalised pumping rate in guide A    
    QB = param.QB;          % Normalised pumping rate in guide A 
	etaAB = param.etaAB;    % Amplitude of coupling coefficient AB 
	etaBA = param.etaBA;    % Amplitude of coupling coefficient BA 
    theta = param.theta;    % Phase of coupling coefficient 
    

    dN = zeros(size(N0));

    % dMA/dt:
    dN(1) = yn*(QA - MA*(1.0 + IA));

    % dMB/dt:
    dN(2) = yn*(QB - MB*(1.0 + IB));

    % dYA/dt:
    dN(3) = kp*(MA - 1.0)*YA - etaAB*YB*sin(theta + phi) + kinj*cos(phiA);

    % dYB/dt
    dN(4) = kp*(MB - 1.0)*YB - etaBA*YA*sin(theta - phi);

    % dphiA/dt 
    dN(5) = aH*kp*(MA - 1) - DWA - (YB/YA)*etaAB*cos(theta + phi) + kinj*sin(phiA)/YA - DWinj;
    
    % dphiB/dt 
    dN(6) = aH*kp*(MB - 1) - DWB - (YA/YB)*etaBA*cos(theta - phi) - DWinj;

end














