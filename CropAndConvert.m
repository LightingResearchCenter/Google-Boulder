%% Reset MATLAB
close all
clear
clc

%% Enable dependencies
[githubDir,~,~] = fileparts(pwd);
d12packDir      = fullfile(githubDir,  'd12pack');
circadianDir	= fullfile(githubDir,'circadian');
addpath(d12packDir,circadianDir);

%% Map paths
timestamp = datestr(now,'yyyy-mm-dd_HHMM');
rootDir = '\\root\projects';
calPath = fullfile(rootDir,'DaysimeterAndDimesimeterReferenceFiles',...
    'recalibration2016','calibration_log.csv');
prjDir  = fullfile(rootDir,'Google-Boulder','DaysimeterData','fall');
orgDir  = fullfile(prjDir,'originalData');
dbName  = [timestamp,'.mat'];
dbPath  = fullfile(prjDir,dbName);

%% Crop and convert data
LocObj = d12pack.LocationData;
LocObj.State_Territory          = 'Boulder';
LocObj.PostalStateAbbreviation	= 'CO';
LocObj.Country                  = 'United States of America';
LocObj.Organization             = 'Google';

listingCDF   = dir(fullfile(orgDir,'*.cdf'));
cdfPaths     = fullfile(orgDir,{listingCDF.name});
loginfoPaths = regexprep(cdfPaths,'\.cdf','-LOG.txt');
datalogPaths = regexprep(cdfPaths,'\.cdf','-DATA.txt');

for iFile = numel(loginfoPaths):-1:1
    cdfData = daysimeter12.readcdf(cdfPaths{iFile});
    ID = cdfData.GlobalAttributes.subjectID;
    
    thisObj = d12pack.HumanData;
    thisObj.CalibrationPath = calPath;
    thisObj.RatioMethod     = 'newest';
    thisObj.ID              = ID;
    thisObj.Location        = LocObj;
    thisObj.TimeZoneLaunch	= 'America/New_York';
    thisObj.TimeZoneDeploy	= 'America/Denver';
    
    % Import the original data
    thisObj.log_info = thisObj.readloginfo(loginfoPaths{iFile});
    thisObj.data_log = thisObj.readdatalog(datalogPaths{iFile});
    
    % Crop the data
    thisObj = crop(thisObj);
    
    objArray(iFile,1) = thisObj;
end

%% Save converted data to file
save(dbPath,'objArray');


