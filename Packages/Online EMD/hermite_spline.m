function v = hermite_spline(x,y,u)
%PCHIPTX  Textbook piecewise cubic Hermite interpolation.
%  v = hermite_spline (x,y,u) finds the Hermite piecewise cubic
%  interpolant P(x), with P(x(j)) = y(j), and returns v(k) = P(u(k)).
%
% --
%
% The cool thing about Hermite interpolation is that it only uses local
% information to calculate the splines, which means that the splines you've
% already calculated **don't change** when you add new data. (Except for
% directly adjacent to the new data.)\
%
% --
%
% This code was derived from Cleve Moler's 'pchiptx.m', which exactly
% implements the algorithm used for MATLAB pchip(). See his book,
% 'Numerical Computing With MATLAB' sec 3.4 for the source. (Yes, *that*
% Cleve Moler, the head guru at the Mathworks.)
%
% The modification is that the gradients at interior points are no longer
% calculated to be "shape preserving", which is where the gradient is
% assumed zero at all turning points in the data. This causes funny
% behaviour when interpolating series like [1 1 -1 -1 1 1 -1 -1].
%
% --
%
% Li-aung "Lewis" Yip - liaung.yip@ieee.org, 10 Sep 2010.
% Modified from original by Cleve Moler.
% Search keywords: "Hermite splines", "Hermite interpolation", "Local data",
% 'Derivative estimate".
% --

%  First derivatives

assert ( numel(x) == numel(y), 'Input vectors x and y must be same length!');

h = diff(x);
delta = diff(y)./h;

if ( numel(x) == 0 )
    error('Hermite_Spline(): warning - asked to interpolate zero points. Meaningless!.');
    return;
end
if ( numel(x) == 1 )
    warning('Hermite_spline(): warning - interpolating one point?! Fitting straight line.');
    v = zeros(size(u)) + y(1)
    return;
end

if ( numel(x) == 2 )
    warning ('Hermite_spline(): Warning - interpolating between two points. Fitting a linear model.');
    v = interp1(x,y,u,'linear');
    return;
end
assert( numel(x) > 2 );

d = pchipslopes(h,delta);

%  Piecewise polynomial coefficients

n = length(x);
c = (3*delta - 2*d(1:n-1) - d(2:n))./h;
b = (d(1:n-1) - 2*delta + d(2:n))./h.^2;

%  Find subinterval indices k so that x(k) <= u < x(k+1)

k = ones(size(u));
for j = 2:n-1
    k(x(j) <= u) = j;
end

%  Evaluate interpolant

s = u - x(k);
v = y(k) + s.*(d(k) + s.*(c(k) + s.*b(k)));


% -------------------------------------------------------

    function d = pchipslopes(h,delta)
        %  PCHIPSLOPES  Slopes for shape-preserving Hermite cubic
        %  pchipslopes(h,delta) computes d(k) = P'(x(k)).
        
        %  Slopes at interior points
        %  delta = diff(y)./diff(x).
        %  d(k) = 0 if delta(k-1) and delta(k) have opposites
        %         signs or either is zero.
        %  d(k) = weighted harmonic mean of delta(k-1) and
        %         delta(k) if they have the same sign.
        
        n = length(h)+1;
        d = zeros(size(h));
        
        % Modified from original pchiptx, which:
        % - used the "harmonic mean"
        % - was "shape preserving" - presumes that al turning points have zero
        %   derivative.
        %
        % Modified this to use the equation:
        %
        %       delta(i-1) * h(i) + delta(i) * h(i-1)
        % d_i = -------------------------------------
        %                 h(i) + h(i-1)
        %
        % Remember delta(i) are the straight-line gradients between points, and
        % the h(i) are the spacings between points. This equation has the
        % following properties....
        
        % - If the spacings between points are equal, d_i is just the average of
        %   the two adjacent delta(i) (gradients).
        % - If the spacings between points are unequal, the gradient at a point is more
        %   strongly influenced by the closer of its neighbouring points.
        % - Unlike pchip(), the gradient is not set to zero if there is a
        %   turning point in the data. This is because the actual maxima may fall
        %   between two data points, not exactly on one.
        %
        k = 2:n-1;
        d(k) = ( delta(k-1) .* h(k) + delta(k) .* h(k-1) ) ./ ( h(k) + h(k-1) );
        
        %  Slopes at endpoints
        
        d(1) = pchipend(h(1),h(2),delta(1),delta(2));
        d(n) = pchipend(h(n-1),h(n-2),delta(n-1),delta(n-2));
        
        % -------------------------------------------------------
    end

    function d = pchipend(h1,h2,del1,del2)
        %  Noncentered, shape-preserving, three-point formula.
        d = ((2*h1+h2)*del1 - h1*del2)/(h1+h2);
        if sign(d) ~= sign(del1)
            d = 0;
        elseif (sign(del1)~=sign(del2))&(abs(d)>abs(3*del1))
            d = 3*del1;
            
            
        end
%         d = 0;
    end

end
