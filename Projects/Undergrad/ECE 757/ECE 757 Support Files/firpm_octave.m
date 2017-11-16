% firpm.m: Wrapper for remez function.  Filename be renamed
% to simply "firpm.m" for older version of Matlab, as well
% as Octave.
function [b]=firpm(varargin)
[b]=remez(varargin{:})';

