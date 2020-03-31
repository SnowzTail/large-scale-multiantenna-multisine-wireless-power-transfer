%% Transceiver
eirp = db2pow(36 - 30);
nTxs = 4;
txPower = eirp / nTxs;
%% Channel
centerFrequency = 2.4e9;
bandwidth = 1e7;
distance = 10;
[pathloss] = large_scale_fading(distance) * ones(nUsers, 1);
nRealizations = 2e2;
fadingType = 'selective';
%% Harvester
% assumptions: antenna impedance = 50 ohms, ideality factor = 1, thermal voltage = 25.85 mV
beta2 = 9.6712e2;
beta4 = 6.0304e6;
tolerance = 1e-3;
%% Variables
Variable.nUsers = 1 : 2 : 5;
Variable.nSubbands = 2 .^ (0 : 5);
