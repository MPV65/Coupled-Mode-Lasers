function [tout, Nout] = run(rate_eqs, N0, param, tsim, dt)
%RUN Runs the time dependent simulation of the rate equations using the 
%Runge-Kutta method
%   
%% Usage
%
%   [tout, Nout] = run(@rate_eqs, N0, param, tsim, dt);
%
%% Arguments
%
%   rate_eqs    Handle to the function providing the rate equations for the
%               dynamical system. This function will have the calling
%               signature:
%
%                   rate_eqs(t, N0, param) 
%
%               where t is the time instance at which the equations are
%               calculated. N0 and param are described below. 
%
%	N0          Vector of inital conditions for the dynamical variables of
%               the rate equations. 
%
%               (See documentation for the specific function providing the 
%               rate equations for details).
%
%   param       A structure containing the parameters for the rate
%               equations. 
%
%               (See documentation for the specific function providing the 
%               rate equations for details).
%
%   tsim        Time span for the simulation (in ns)
%
%   dt          time step to be used for fixed step integration. If dt <= 0
%               then the variable step routine is used.
%
%
%% Returns
% 
%   tout        Array of the time values for the computed solution.
%
%   Nout        Array containing the computed dynamical variables at each
%               time step.
%
%% Dependencies
%
%   If dt > 0, the routine calls the RK.m routine in the directory:
%
%       /Coupled-Mode-Lasers/Numeric 
%
%% Code

    % Test if rate_eqs is a function handle
    if (not(isa(rate_eqs, 'function_handle')))
   
        error('First argument is not a function handle')

    end

    % Check the in-house Runge-Kutta routine is on the MATLAB path if using
    % the fixed-step routine
    if (dt > 0)

        if (exist('RK4','file') ~= 2)

            % Folder containing RK4.m
            addpath([userpath '/Coupled-Mode-Lasers/Numeric']); 

        end
        
    end

    % Time span
    t1 = tsim;
    t0 = 0.0;
    
    % Anonymous handle to function
    odefun = @(t, N) rate_eqs(t, N, param); 
    
    if (dt <= 0) 
        
        % Use MATLAB variable step integrator ode45
        npts = 4001; 
        dt = (t1 - t0)/(npts - 1.0);

        tspan = t0:dt:t1;

        reltol = 1E-6;
        options = odeset('RelTol', reltol);

        % Runge-Kutta implementation
        [tout, Nout] = ode45(odefun, tspan, N0, options);  
        
    else
        
        % Use in-house fixed-step routine
        warning(strcat('Using fixed-step Runge-Kutta routine:',...
            ' you may need to perform convergence tests'))
        
        [tout, Nout] = RK4(odefun, N0, t0, t1, dt); 
        
    end

end

