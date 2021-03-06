function [param] = setParams(varargin)
%SETPARAMS Sets the parameters for simulating laser dynamics
%%   
% SETPARAMS
%
%% Description
%
%   Editable file for setting structure containing parameters for 
%   simulations of coupled mode lasers with optical injection. See [1] for
%   further details.
%
%   [1] N. Li et al, Sci Rep 8, 109 (2018)
%
%% Usage
%
%	param = setParams([filename])
%
%% Arguments
%
%   [filename]  Optional filename (char array) for saving parameters to a
%               MAT file. E.g. 'myfile.mat' (do not use double quotes). The
%               '.mat' extension is optional - it will be added if it is
%               not present.
%
%% Returns
%
%	param       A structure containing the parameters:
%
%       param.yn        carrier recombination rate (1/tau_N)
%       param.kp        cavity loss rate (1/(2*tau_p))
%       param.aH        Linewidth enhancement factor
%       param.kinj      Injection level rate (K_inj/tau_N)
%       param.DWA       Free-running minus laser A angular frequency 
%       param.DWB       Free-running minus laser B angular frequency 
%       param.DW        Cavity detuning (see notes)
%       param.DWinj 	Injection detuning (W_inj - W)
%       param.QA        Normalised pumping rate in guide A    
%       param.QB        Normalised pumping rate in guide A 
%       param.eta       Amplitude of coupling coefficient (symmetric case)
%       param.etaAB     Amplitude of coupling coefficient AB (asymmetric)
%       param.etaBA     Amplitude of coupling coefficient BA (asymmetric)
%       param.theta     Phase of coupling coefficient 
% 
%% Notes
%  
%  The cavity detuing DW is included for compatibility with the coupled
%  mode model without injection. The rate equations with injection do not
%  use it explicitly.
%
%% Editable variables
%
%  This section contains variables intended to be regularly edited in-file.
%  These variables may then be converted to modelling units or used to set
%  calculated variables.
%
%  Note that these are default values and may be reset elsewhere.
%
%       Variable        Description                             Units
%       -------------------------------------------------------------------
%       tau_N           Electron lifetime                       (ns)
%       tau_p           Photon lifetime                         (ps)
%       aH              Linewidth enhancement factor              
%       F0              Free running frequency                  (GHz)
%       FA              Frequency of laser in guide A           (GHz)
%       FB              Frequency of laser in guide B           (GHz)
%       F_inj           Injection laser frequency               (GHz)
%       PA              P/Pth ratio in guide A                    
%       PB              P/Pth ratio in guide B                    
%       CQ              Pump gain constant CQ                     
%       K_inj           Dimensionless injection level K_inj       
%       a               Half-width of waveguide                 (micron)
%       d               Half edge-to-edge separation of         (micron)
%                       waveguides
%       C_eta           Waveguide parameter for magnitude       (1/ns)
%       C_theta         Waveguide parameter for phase           (rad)
%       Wr              Real part of the transverse                 
%                       propagation constant in cladding
%       Wi              Imaginary part of the transverse           
%                       propagation constant in cladding
%       -------------------------------------------------------------------


    % ---------------------------------------------------------------------
    %     Laser parameters (note units)
    % ---------------------------------------------------------------------
    
    % Electron lifetime (ns)
    tau_N = 1;
    
    % Photon lifetime (ps)
    tau_p = 1.53;
    
    % Linewidth enhancement factor
    aH = 2.0;
    
    % Free running frequency (GHz) 
    % N.B. will be converted to (rad/ns)
    F0 = 2.3061e+05;
    
    % Frequency of laser in guide A (GHz) 
    % N.B. will be converted to (rad/ns)
    FA = 2.3061e+05;
    
    % Frequency of laser in guide B (GHz) 
    % N.B. will be converted to (rad/ns)
    FB = 2.3061e+05;
    
    % Injection laser frequency (GHz)
    % N.B. will be converted to (rad/ns)
    F_inj = 2.3061e+05;
    
    % Ratio of pump to threshold pumping (P/Pth) in guide A
    PA = 2;
    
    % Ratio of pump to threshold pumping (P/Pth) in guide B
    PB = 2;
    
    % Pump gain constant CQ
    CQ = 11.4;
    
    % Dimensionless injection level K_inj
    K_inj = 0;
    
    % ---------------------------------------------------------------------
    %     Waveguide parameters (note units)
    % ---------------------------------------------------------------------
    
    % Half-width of waveguide (microns)
    a = 4.0;
    
    % Half edge-to-edge separation of waveguides (microns)
    d = 4.0;
    
    % Waveguide parameter C_eta for magnitude (1/ns)
    C_eta = 83.6;
    
    % Waveguide parameter C_theta for phase (rad) 
    C_theta = 0;
    
    % Real part of the transverse propagation constant in cladding 
    Wr = 1.26;
    
    % Imaginary part of the transverse propagation constant in cladding 
    Wi = 0;
    
    
%%  Calculated variables and conversions
%
% The calculations and conversions in this section are not intended to be
% regularly edited. These use the variables set in the section above and
% convert them (where necessary) to the correct units.

    % Carrier recombination rate (1/ns)
    yn = 1.0/(tau_N);

    % Convert photon lifetime to ns
    ns = 1E-3; % ps
    tau_p = tau_p*ns;
    
    % Cavity loss rate (1/ns)
    kp = 1.0/(2.0*tau_p);
    
    % Convert F0 - FA to rad/ns
    DWA = 2.0*pi*(F0 - FA);
    
    % Convert F0 - FB to rad/ns
    DWB = 2.0*pi*(F0 - FB);
    
    % Convert F_inj - F0 to rad/ns
    DWinj = 2.0*pi*(F_inj - F0);
    
    % Cavity detuing (included for compatibility with model without
    % injection)
    DW = 2.0*pi*(FB - FA);
    
    % Normalised pumping rate in guide A
    QA = CQ*(PA - 1) + PA;
    
    % Normalised pumping rate in guide B
    QB = CQ*(PB - 1) + PB;
    
    % Magnitude of coupling coefficient (1/ns)
    eta = C_eta*exp(-2.0*Wr*d/a);
    
    % Magnitude of coupling coefficient AB (1/ns)
    etaAB = eta;
    
    % Magnitude of coupling coefficient AB (1/ns)
    etaBA = eta;
    
    % Phase of coupling coefficient
    theta = C_theta - 2.0*Wi*d/a;
    
    % Injection level rate (1/ns)
    kinj = K_inj/tau_N;

    % Set parameter structure
	param.yn = yn;          % Carrier recombination rate
	param.kp = kp;          % Cavity loss rate
	param.aH = aH;          % Linewidth enhancement factor
    param.kinj = kinj;      % Injection level rate
    param.DWA = DWA;        % Free-running minus laser A angular frequency 
	param.DWB = DWB;        % Free-running minus laser B angular frequency
    param.DW = DW;          % Cavity detuning 
    param.DWinj = DWinj;    % Injection detuning
	param.QA = QA;          % Normalised pumping rate in guide A    
	param.QB = QB;          % Normalised pumping rate in guide B 
	param.eta = eta;        % Amplitude of coupling coefficient 
    param.etaAB = etaAB;    % Amplitude of coupling coefficient AB 
    param.etaBA = etaBA;    % Amplitude of coupling coefficient BA
	param.theta = theta;	% Phase of coupling coefficient 
	
    
%%  Optional file saving
%
% This section optionally saves the parameter structure to a MAT file if a
% filename was passed when the function was called.

    save_file = false;

    if (nargin > 0) 
        
        filename = varargin{1};
        
        % Check if filename is a string
        if (ischar(filename))
            
            save_file = true;
            
            if not(strcmp(filename(end-3:end),'.mat'))
                
                % Concatonate with extension
                filename = [filename '.mat'];
                
            end  
            
        end
        
    end
    
    if (save_file) 
        
        save(filename, 'param');
        
    end

end

