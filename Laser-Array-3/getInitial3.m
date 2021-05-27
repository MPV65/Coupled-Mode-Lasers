function [N0] = getInitial3(param, varargin)
%
%   TO BE CHANGED TO 3 LASER ARRAY
%
%GETINITIAL Set initial values for simulation or first guess at steady
%state solution
% 
%%  Usage
%
%    N0 = getInitial(param, [varargin]);
%
%%  Arguments
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
%   varargin    optional string taking the values:
%
%       "steady-state"  set steady state values (or nearest guess)
%
%%  Returns
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
%%  Notes
%
%
%%

    steady_state = false;

    % Check for flag to plot graphs
    if (nargin > 1)

        if (varargin{1} == "steady-state")
            
            steady_state = true;
            
        end

    end

    
    % Set default initial conditions
    N0 = zeros(6,1);
    %
    %    Carrier concentrations:
    %       MA   = N0(1)        Carrier concentration in guide A
    %       MB   = N0(2)        Carrier concentration in guide B
    %    Optical fields:
    %       YA   = N0(3)        Amplitude in guide A
    %       YB   = N0(4)        Amplitude in guide B
    %       phiA = N0(5)        Phase of optical field in guide A
    %       phiB = N0(6)        Phase of optical field in guide B

    if (steady_state)
        
        % TODO: Update this with analytical steady state solutions if
        % available
        
        dM = 0.000001;
        MS = 1.0;
        MA = MS + dM;   % Guide 1
        MB = MS + dM;   % Guide 2
        
        dA = 0.000001;
        YAS = real(sqrt(param.QA - 1));
        YBS = real(sqrt(param.QB - 1));
        YA = YAS + dA;   % Guide 1
        YB = YBS + dA;   % Guide 2
        
        phiA = 0.00;        % Phase of optical field in guide A 
        phiB = 0.001;       % Phase of optical field in guide B 
             
    else
        
        MA = 0.0;   % Guide 1
        MB = 0.0;   % Guide 2
        IA = 1E-4;          % Initial signal power symmetric mode 
        IB = 1E-4;          % Initial signal power anti-symmetric mode 
        YA = sqrt(IA);      % symmetric component of light 
        YB = sqrt(IB);      % anti-symmetric component of light 
        phiA = 0.00;        % Phase of optical field in guide A 
        phiB = 0.001;       % Phase of optical field in guide B 
        
    end
    


    N0(1) = MA;         % Carrier concentration in guide A
    N0(2) = MB;         % Carrier concentration in guide B
    N0(3) = YA;     	% Amplitude in guide A
    N0(4) = YB;     	% Amplitude in guide B
    N0(5) = phiA;       % Phase of optical field in guide A 
    N0(6) = phiB;       % Phase of optical field in guide A    
    
end

