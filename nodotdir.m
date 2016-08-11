function listing = nodotdir(name)
%NODOTDIR Summary of this function goes here
%   Detailed explanation goes here

% Specify strings to be ignored
ignoreNames = {'.','..'};

% Get listing of dir
listing = dir(name);

% Find entries to ignore
ignore = ismember({listing.name},ignoreNames);

% Remove ignored entries
listing(ignore) = [];

end

