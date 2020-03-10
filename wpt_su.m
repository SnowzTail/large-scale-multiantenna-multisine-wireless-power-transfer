clear; close all; clc; initialize; config_su;
%% Waveform design by SU WPT algorithm
voltage = zeros(length(Variable.nSubbands), length(Variable.distance), nRealizations);
for iCase = 1 : length(Variable.nTxs)
    nTxs = Variable.nTxs(iCase);
    nSubbands = Variable.nSubbands(iCase);
    carrierFrequency = centerFrequency - bandwidth * (1 - 1 / nSubbands) / 2: bandwidth / nSubbands: centerFrequency + bandwidth * (1 - 1 / nSubbands) / 2;
    for iDistance = 1 : length(Variable.distance)
        distance = Variable.distance(iDistance);
        for iRealization = 1 : nRealizations
            % \boldsymbol{h}_{q,n}
            channel = channel_tgn_e(distance, nSubbands, nTxs, carrierFrequency, fadingType);
            % \boldsymbol{s_n}
            waveform = waveform_su(beta2, beta4, powerBudget, channel, tolerance);
            % v_{\text{out},q}
            voltage(iCase, iDistance, iRealization) = harvester(beta2, beta4, waveform, channel);
        end
    end
end
voltage = mean(voltage, 3);
save('data/wpt_su.mat');
%% Result
legendString = cell(length(Variable.nTxs), 1);
figure('Name', sprintf('Average output voltage by SU WPT as a function of distance'));
for iCase = 1 : length(Variable.nTxs)
    semilogy(Variable.distance, voltage(iCase, :));
    legendString{iCase} = sprintf('M = %d, N = %d', Variable.nTxs(iCase), Variable.nSubbands(iCase));
    hold on;
end
hold off;
grid minor;
legend(legendString);
xlabel('Distance [m]')
ylabel('Average v_{out} [V]')
savefig('results/wpt_su.fig');
