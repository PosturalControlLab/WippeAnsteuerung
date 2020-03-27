function data = calibrateData(data_raw)
data = data_raw;

%     data(:,3) = data_raw(:,3) - mean(data_raw(1:10,3)); %Offset Korrektur
%     data(:,3) = data(:,3) / 0.7886; %Eichung mit 0,77 V/° Potti Spannung zu Winkel


