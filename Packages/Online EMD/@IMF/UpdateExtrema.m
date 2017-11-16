function UpdateExtrema(this)
% UpdateSourceExtrema( IMF this )
% Used to update the list of the data source's extrema. This is only used to
% determine where to pick up with the next round of block sifting - not actually
% used during the sifting process itself.
%
% Examines the source_data for any new extrema. If any are found, add them to
% our lists.
%
% Search for extrema begins at the last one we found, or t==0 if we haven't
% found any yet.
%
% Note: Could optimise this to remember the exact time we've searched up to so
% far, but that would be more complicated. Maybe for version 2.
%
search_bound_left = max( [1, this.source_max_t, this.source_min_t] );
search_bound_right = this.data_source.Latest;

% Get data
data_chunk = this.GetSourceData(search_bound_left,search_bound_right);

% Find locations of extrema. Indmin, indmax, and indzer will be
% array indices referenced against the start of the data chunk (i.e.
% the left search bound), not the real time origin.
[indmin, indmax, indzer] = extr(data_chunk);

% Extract the extrema values.
% valmin = arrayfun( @(ind)(this.data_source.Get(ind)), indmin );
% ^ a more fun (but less efficient) way of doing the same thing.
valmin = data_chunk(indmin);
valmax = data_chunk(indmax);
valzer = data_chunk(indzer);

% Adjust indices to reference time origin.
indmin = indmin + search_bound_left - 1;
indmax = indmax + search_bound_left - 1;
indzer = indzer + search_bound_left - 1;

% Append newly found extrema to our lists.
this.source_max_v = [this.source_max_v valmax];
this.source_max_t = [this.source_max_t indmax];
this.source_min_v = [this.source_min_v valmin];
this.source_min_t = [this.source_min_t indmin];

% Output sanity checking
% All extrema must be unique
assert ( numel(this.source_max_t) == numel(unique(this.source_max_t)), 'Bug: Some maxima were found twice!');
assert ( numel(this.source_min_t) == numel(unique(this.source_min_t)), 'Bug: Some minima were found twice!');
% The number of maxima and minima can't differ by more than one (as
% this would imply that we'd missed a maximum or minimum.)
assert ( abs (numel(this.source_min_t) - numel(this.source_max_t)) <= 1, 'Bug: Number of maxima and minima differ by more than one.');
% List of maxima times must have as many elements as the list of
% maxima values.
assert ( numel(this.source_max_v) == numel(this.source_max_t) );
assert ( numel(this.source_min_v) == numel(this.source_min_t) );
end