function [y] = test(myfunc)
%TEST Summary of this function goes here
%   Detailed explanation goes here
    
    % myfunc should be a handle to a function
    
    xmax = 2*pi;
    xmin = 0;
    npts = 201;
    dx = (xmax-xmin)/(npts-1);
    
    x = xmin:dx:xmax;
    
    func2 = @(x) myfunc(x);
    
    y = func2(x);
    
    warning(strcat('Using fixed-step Runge-Kutta routine:',...
            ' you may need to perform convergence tests'))
    
    figure
    plot(x, y)
    
end

