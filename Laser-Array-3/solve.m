function [Ns, found, E, esign] = solve(N0, param, varargin)
%
%   TO BE GENERALISED
%
%SOLVE Attempts to find the steady state solution for the rate
%equations
%   
%% Description
%
%% Usage
%
%   [Ns, found, E, esign] = SolveCoupled1D(QA, QB, d, DW, param, varargin);
%
%% Arguments
%
%	tsim        integer specifying the simulation time tspan via tspan =
%               tsim/yn, where yn is the recombination rate (in 1/ns) 
%
%	N0          Vector of inital conditions for the equations
%
%               Carrier concentrations:
%                   MA   = N0(1)        Carrier concentration in guide A
%                   MB   = N0(2)        Carrier concentration in guide B
%               Optical fields:
%                   YA   = N0(3)        Amplitude in guide A
%                   YB   = N0(4)        Amplitude in guide B
%                   phiA = N0(5)        Phase of optical field in guide A
%                   phiB = N0(6)        Phase of optical field in guide B
%
%
%   param       structure containing laser parameters
%
%               param.yn        carrier recombination rate (1/tau_N)
%               param.kp        cavity loss rate (1/(2*tau_p))
%               param.aH        Linewidth enhancement factor
%               param.kinj      Injection level rate (K_inj/tau_N)
%               param.DWA       Free-running minus laser A angular frequency 
%               param.DWB       Free-running minus laser B angular frequency 
%               param.DW        Cavity detuning (see notes)
%               param.DWinj 	Injection detuning (W_inj - W)
%               param.QA        Normalised pumping rate in guide A    
%               param.QB        Normalised pumping rate in guide A 
%               param.eta       Amplitude of coupling coefficient (not used)
%               param.etaAB     Amplitude of coupling coefficient AB (asymmetric)
%               param.etaBA     Amplitude of coupling coefficient BA (asymmetric)
%               param.theta     Phase of coupling coefficient 
%
%   varargin    optional values:
%
%
%% Returns
% 
%   tout        4001 x 1 array of time values
%
%   Nout        4001 x 5 array containing the time evolution of variables
%
%                   Nout(:,1)   Carrier concentration in guide A
%                   Nout(:,2)   Carrier concentration in guide B
%                   Nout(:,3)   Optical amplitude in guide A
%                   Nout(:,4)   Optical amplitude in guide B
%                   Nout(:,5)   Phase of optical field in guide A
%                   Nout(:,6)   Phase of optical field in guide B
%
%% Code

    found = false;

    % Anonymous handle to function   
    fun = @(x) coupledInjS(x, param);    

    options = optimoptions('fsolve','Display','off');

    [Ns, ~, exitflag, ~, Jacob] = fsolve(fun, N0, options);

    if (exitflag > 0)
        
        % Steady state solution found
        found = true;

        % Find eigenvalues of Jacobian
        E = eig(Jacob);
        
        % Get real parts of eigenvalues
        Er = real(E);
        Emax = max(Er);
        
        if (Emax < 0.0)

            esign = -1; % Stable solution

        else

            esign = 1;  % Unstable solution

        end

    else
        
        % No solution found

        % Set esign to zero
        esign = 0;

        % Return array of zeros
        E = zeros(size(N0));

    end

end

