function [resistance, elastance, intercept] = calcAirwayResistance(labViewDataLocation, channelNumbers)

% This function will use linear regression to calculate the airway
% resistance using the flow, pressure and volume data collected by the
% labview system

% This function assumes that the data from labview has already been
% filtered to remove heart sounds and other noise from the pressure data.
% It also makes the assumtion that the linear offset in the volume data has
% been removed 

% labViewDataLocation --> This should be a string containing the directory
% of the labview data

% channelNumbers --> This should be an array indicating which channels from
% the labview data contains the flow, pressure and volume in that order
% The default value is [1,2,3];

if nargin < 2 
    channelNumbers = [1,2,3];
end

load(labViewDataLocation);

flowChannel = channelNumbers(1);
pressureChannel = channelNumbers(2);
volumeChannel = channelNumbers(3);

%loading data from LabChart
pesStartStop = [datastart(pressureChannel,1:end); dataend(pressureChannel,1:end)];
pressureData = [];

for i = 1:size(pesStartStop,2)
    pressureData = [pressureData, data(pesStartStop(1,i):pesStartStop(2,i))];
end

flowStartStop = [datastart(flowChannel,1:end); dataend(flowChannel,1:end)];
flowData = [];

for i = 1:size(flowStartStop,2)
    flowData = [flowData, data(flowStartStop(1,i):flowStartStop(2,i))];
end

volStartStop = [datastart(volumeChannel,1:end); dataend(volumeChannel,1:end)];
volumeData = [];

for i = 1:size(volStartStop,2)
    volumeData = [volumeData, data(volStartStop(1,i):volStartStop(2,i))];
end

dataMatrix = [ones(size(flowData')) flowData' volumeData'];
coefficients = regress(pressureData',dataMatrix);

resistance = coefficients(2);
elastance = coefficients(3);
intercept = coefficients(1);

end







