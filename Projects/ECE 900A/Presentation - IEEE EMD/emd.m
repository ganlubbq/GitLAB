%% EMD.m
% Empirical Mode Decomposition, process from the Hilbert Transform.
% Generate a matrix of intrinsic mode functions (each as a row) with
% residual function in the last row.

%% functionname: function description
function imf = emd(x);
	c = x(:)';
	N = length(x);

	imf = [];
	while(1)
		h = c;	% at the beginning of sifting, h is the signal.
		SD = 1;	% standard deviation, which will be used to stop sifting.

		while SD > 0.3  % atypical Standard Deviation found online.
			% find local max/min points
			d = diff(h);    % differentiating maxima and minima.
			maxmin = [];	% matrix to store the optima
			
			for i=1:N-2
				if d(i)==0
					maxmin=[maxmin, i];
				elseif sign(d(i))~=sign(d(i+1)) % approximation.
					maxmin=[maxmin, i+1];
				end
			end

			if size(maxmin,2) < 2	% then it is residue.
				break
			end

			% divide maxmin into maxes and mins

			if maxmin(1) > maxmin(2)
				maxes = maxmin(1:2:length(maxmin));
				mins = maxmin(2:2:length(maxmin));
			else
				maxes = maxmin(2:2:length(maxmin));
				mins = maxmin(1:2:length(maxmin));
			end

			% make the endpoints both maxes and mins
			maxes = [1 maxes N];
			mins = [1 mins N];

			% spline interpolate to get max and min envelopes to form IMF.

			maxenv = spline(maxes,h(maxes),1:N);
			minenv = spline(mins, h(mins),1:N);

			m = (maxenv + minenv)/2;	% mean of max and min envelopes.
			prevh = h;	% copy of the previous value of h before modifying.
			h = h - m;	% subtract the mean to h.

			% calculate standard deviation
			eps = 1e-12;	% to avoid zero values. (divide by zero).
			SD = sum( ((prevh -h).^2) ./ (prevh.^2 + eps) );
		end

		imf = [imf; h];	% store the extracted IMF's in the matrix "imf"
		% if size(maxmin,2) < 2, then h is residue.

		% stop the criterion of the algo.
		if size(maxmin,2) < 2
			break
		end
		c = c - h;	% subtract the extracted IMF from the signal.
    end