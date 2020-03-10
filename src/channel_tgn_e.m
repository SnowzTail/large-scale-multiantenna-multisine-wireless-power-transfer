function [channel] = channel_tgn_e(distance, nSubbands, nTxs, carrierFrequency, fadingType)
    % Function:
    %   - simulate channel using the power delay profile of the IEEE TGn NLOS channel model E
    %
    % InputArg(s):
    %   - distance [d]: distance between base station and user
    %   - nSubbands [N]: number of subbands/subcarriers
    %   - nTxs [M]: number of transmit antennas
    %   - carrierFrequency: center frequency at each subband
    %   - fadingType: "flat" or "selective"
    %
    % OutputArg(s):
    %   - channel [\boldsymbol{h_{q, n}}] (nTxs * nSubbands): channel frequency response at each subband
    %
    % Comment(s):
    %   - assume single receive antenna
    %   - the model only considers power delay profile of clusters
    %   - the reference pass loss is set to 60.046 dB for a distance of 10 m
    %
    % Reference(s):
    %   - V. Erceg et al., "TGn channel models," in Version 4. IEEE 802.11–03/940r4, May 2004.
    %
    % Author & Date: Yang (i@snowztail.com) - 07 Mar 20

    nClusters = 4;
    nTaps = 18;
    tapDelay = 1e-9 * [0 10 20 30 50 80 110 140 180 230 280 330 380 430 490 560 640 730]';
    tapPower = zeros(nTaps, nClusters);
    tapPower(:, 1) = db2pow([-2.6 -3.0 -3.5 -3.9 -4.5 -5.6 -6.9 -8.2 -9.8 -11.7 -13.9 -16.1 -18.3 -20.5 -22.9 -inf -inf -inf]');
    tapPower(:, 2) = db2pow([-inf -inf -inf -inf -1.8 -3.2 -4.5 -5.8 -7.1 -9.9 -10.3 -14.3 -14.7 -18.7 -19.9 -22.4 -inf -inf]');
    tapPower(:, 3) = db2pow([-inf -inf -inf -inf -inf -inf -inf -inf -7.9 -9.6 -14.2 -13.8 -18.6 -18.1 -22.8 -inf -inf -inf]');
    tapPower(:, 4) = db2pow([-inf -inf -inf -inf -inf -inf -inf -inf -inf -inf -inf -inf -inf -inf -20.6 -20.5 -20.7 -24.6]');

    % model taps as i.i.d. CSCG variables
    tapGain = repmat(sqrt(tapPower / 2), [1 1 nTxs]) .* (randn(nTaps, nClusters, nTxs) + 1i * randn(nTaps, nClusters, nTxs));
    tapGain = squeeze(sum(tapGain, 2));

    fading = zeros(nTxs, nSubbands);
    switch fadingType
    case 'selective'
        for iTx = 1 : nTxs
            for iSubband = 1 : nSubbands
                fading(iTx, iSubband) = sum(tapGain(:, iTx) .* exp(1i * 2 * pi * carrierFrequency(iSubband) * tapDelay));
            end
        end
    case 'flat'
        for iTx = 1 : nTxs
            fading(iTx, :) = repmat(sum(tapGain(:, iTx) .* exp(1i * 2 * pi * mean(carrierFrequency) * tapDelay)), [1 nSubbands]);
        end
    end

    pathlossExponent = 2;
    pathloss = db2pow(60.046 + 10 * pathlossExponent * log10(distance / 10));
    channel = fading / sqrt(pathloss);

end
