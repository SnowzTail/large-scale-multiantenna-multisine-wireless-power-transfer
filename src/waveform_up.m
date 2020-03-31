function [waveform, sumVoltage, userVoltage, minVoltage] = waveform_up(beta2, beta4, txPower, channel)
    % Function:
    %   - optimize the amplitude and phase of transmit multisine waveform
    %
    % InputArg(s):
    %   - beta2 [\beta_2]: diode second-order parameter
    %   - beta4 [\beta_4]: diode fourth-order parameter
    %   - txPower [P]: transmit power constraint
    %   - channel [h_{q, n}] (nTxs * nSubbands * nUsers): channel frequency response at each subband
    %
    % OutputArg(s):
    %   - waveform [\boldsymbol{s}_n] (nTxs * nSubbands): complex waveform weights for each transmit antenna and subband
    %   - sumVoltage [\sum v_{\text{out}}]: sum of rectifier output DC voltage over all users
    %   - userVoltage [v_{\text{out}, q}]: individual user voltages
    %   - minVoltage [\min v_{\text{out}}]: minimum user voltage
    %
    % Comment(s):
    %   - for single-user and multi-user MISO systems
    %   - allocate power uniformly over all subbands
    %   - asymptotically optimal spatial beamformer
    %
    % Reference(s):
    %   - B. Clerckx and E. Bayguzina, "Waveform Design for Wireless Power Transfer," IEEE Transactions on Signal Processing, vol. 64, no. 23, pp. 6313–6328, Jan. 2016.
    %
    % Author & Date: Yang (i@snowztail.com) - 11 Mar 20


    % \boldsymbol{w}_n
    precoder = sum(conj(channel) ./ vecnorm(channel, 2, 1), 3);
    % \boldsymbol{p}
    carrierWeight = sqrt(txPower / norm(precoder, 'fro') ^ 2);
    % \boldsymbol{s}_n
    waveform = carrierWeight * precoder;
    % \sum v_{\text{out}}, v\{\text{out}, q}
    [sumVoltage, userVoltage, minVoltage] = harvester_compact(beta2, beta4, waveform, channel);

end
