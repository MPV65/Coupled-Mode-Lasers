%% Coupled Mode Laser Pairs
%
% The set of routines in this directory implements the coupled mode model 
% for a pair of laterally coupled slab waveguides [1].
%
%% Important note
%
% Several routines call utility functions defined in the  'Numeric' 
% directory. It is important that the relative location of this directory
% is correct, as the routines that call these functions attempt to add the
% directory to the path if it is not already on it.
% 
% Both the 'Numeric' and 'Coupled Mode Twin' directorie should therefore be
% in the 'Photonic-Neurons' directory, which in turn should be directly on
% the default MATLAB path. This should be
%
% 	'C:\Users\<user_name>\Documents\MATLAB'  
%
% or similar. Type 'userpath' at the command line to check. 
%
%% Functionality
%
% <html>
% <table><th>Routine</th><th>Notes</th><tr>
% <tr><td><a href='coupled1D.html'>coupled1D</a></td><td>Implements the 
% rate equations for the model. Used in conjuction with the Runge-Kutta 
% solver and called by <b>coupled1DS</b></td><tr>
% <tr><td><a href='coupled1DS.html'>coupled1DS</a></td><td>Interface 
% routine calling <b>coupled1D</b>. Used in conjunction with the non-linear
% solver to find steady state solutions</td></tr>
% <tr><td><a href='loadParams.html'>loadParams</a></td><td>Loads laser
% parameters that have been saved as MAT files.</td></tr>
% <tr><td><a href='runCoupled1D.html'>runCoupled1D</a></td><td>Runs a time
% simulution (see notes below for an example).</td></tr>
% <tr><td><a href='singleSlab.html'>singleSlab</a></td><td>Calculates the
% mode profile and coupling coefficients for identical slab waveguides.
% This is called by the routine <b>runCoupled1D</b> to calculate the
% coupling coefficient for the waveguide separation. It may also be called
% directly to plot the modal profile.</td></tr>
% </table>
% </html>
%
%% Rate equations
%
% The normalised rate equations for the coupled mode model are [1]
%
% $$\frac{dM_{A,B}}{dt} = \gamma_{n}\left[Q_{A,B} - M_{A,B}\left(1 + 
% \left|Y_{A,B}\right|^{2}\right)\right],$$
%%
% $$\frac{dY_{A}}{dt} = \kappa_{p}\left(M_{A} - 1\right)Y_{A} - 
% \eta Y_{B}\sin\left(\theta + \phi\right),$$
%%
% $$\frac{dY_{B}}{dt} = \kappa_{p}\left(M_{B} - 1\right)Y_{B} - 
% \eta Y_{A}\sin\left(\theta - \phi\right),$$
%%
% $$\frac{d\phi}{dt} = \alpha_{H}\kappa_{p}\left(M_{A} - M_{B}\right) - 
% \Delta\Omega + \eta\left[\frac{Y_{A}}{Y_{B}}\cos\left(\theta - 
% \phi\right) - \frac{Y_{B}}{Y_{A}}\cos\left(\theta + \phi\right)\right],$$
%
% where the $M_{A,B}$ are the carrier densities in guides $A$ and $B$,
% $Y_{A}$ and $Y_{B}$ are the optical fields, $\phi$ is the phase
% difference between the fields in $A$ and $B$, $\gamma_{n} = 1/\tau_{N}$,
% where $\tau_{N}$ is the carrier lifetime, $\kappa_{p} = 1/(2\tau_{p})$,
% where $\tau_{p}$ is the photon lifetime, $\eta$ and $\theta$ are the
% magnitude and phase of the coupling coefficient, $Q_{A}$ and $Q_{B}$ are
% the normalised pumping rates in each laser and $\alpha_{H}$ is the
% linewidth enhancement factor.
%
% These equations are implemented in the function <coupled1D.html 
% coupled1D>, which is used with both the Runge-Kutta solver to find the 
% temporal dynamics and the non-linear solver for finding the steady state 
% solutions.

%% Example code
%
% The code examples here are all contained within the script
% *CoupledMode*, which may be run directly from the command line or by
% clicking on the run button in the editor.
%
% The <loadParams.html loadParams> routine loads a mat file containing
% laser guide parameters. The file 'PRA.mat' contains parameters for Ref
% [1]. This returns a structure variable, which should be named 'param'.
%
param = loadParams('PRA_95_053869');  % Laser cavity parameters using in Ref [1]
%%
% See <loadParams.html loadParams> for details of the fields initialised.
%
% To perform a time simulation, we will need to assign further values to
% pass to the routine <runCoupled1D.html runCoupled1D>. These are
%
tsim = 8;   % Simulation time (in units of 1/yn)
QA = 10;    % Normalised pump power in laser A
QB = 10;    % Normalised pump power in laser B
d = 16;     % Distance between guides (microns)
DW = 0;     % Frequency detuning

opt = 1;    % Optional parameter for 'runCoupled1D.m' to plot graphs
%%
% Call the routine to calculate temporal dynamics
%
[tout, Nout] = runCoupled1D(tsim, QA, QB, d, DW, param, opt);   %#ok<ASGLU>
%%
% The return value 'tout' is a 4001x1 array contained the time points, 
% 'Nout' is a 4001x5 array containing the dynamic variables (see 
% <runCoupled1D.html runCoupled1D> for details).
%
% Without extra arguments, the routine sets default values for the initial 
% conditions. It is also possible to pass initial conditions to the
% function as an optional extra argument in the form of a 5 x 1 array. The
% values of the array should be in normalised form and in the order:
%
%%
% <html>
% <table>
% <tr><td>N0(1)</td><td>Carrier concentration in guide A</td></tr>
% <tr><td>N0(2)</td><td>Carrier concentration in guide B</td></tr>
% <tr><td>N0(3)</td><td>Optical amplitude in guide A</td></tr>
% <tr><td>N0(4)</td><td>Optical amplitude in guide B</td></tr>
% <tr><td>N0(5)</td><td>Relative phase between fields in A and B</td></tr>
% </table>
% </html>
%
% We may set up such an array using the steady state values at the end of
% the simulation carried out above, using
%

N0 = Nout(end,:);   % End values of simulation
N0 = transpose(N0); % Transpose array to be in 5 x 1 form

%%
% The runCoupled1D routine may now be called using
%
opt = 0;    % Do not plot graphs this time
[tout, Nout] = runCoupled1D(tsim, QA, QB, d, DW, param, opt, N0);


%% References
% [1] M. J. Adams, N. Li, B. R. Cemlyn, H. Susanto and I. D. Henning, Phys.
% Rev. A 95(5), 053869 (2017)