%% * User
nUsers = 2;

%% * Transceiver
eirp = db2pow(36 - 30);
nTxs = 20;
txPower = eirp / nTxs;

%% * Channel
centerFrequency = 2.4e9;
bandwidth = 1e7;
nSubbands = 10;
[carrierFrequency] = carrier_frequency(centerFrequency, bandwidth, nSubbands);
distance = 20;
[pathloss] = large_scale_fading(distance) * ones(nUsers, 1);
nRealizations = 1;
fadingType = 'selective';

%% * Harvester
% assumptions: antenna impedance = 50 ohms, ideality factor = 1, thermal voltage = 25.85 mV
beta2 = 9.6712e2;
beta4 = 6.0304e6;
tolerance = 1e-3;

%% * Variables
nWeights = 40;
Variable.weight = [ones(nWeights, 1), 10 .^ ([-3, -1 : 2 / (nWeights - 3) : 1, 3])'];
