function [] = LIGO_to_LibComCat(LIGO_format_data, out_fname)
[~,I] = sort(LIGO_format_data(:,1),'ascend');
%
% Put LIGO Data In Order
%
LIGO_format_data = LIGO_format_data(I,:);
%
% Create Table
%
OT = cell(size(LIGO_format_data,1),1);
EvType = cell(size(LIGO_format_data,1),1);
EventID = zeros(size(LIGO_format_data,1),1);
for ii = 1 : length(EvType)
    OT{ii,:} = datestr(LIGO_format_data(ii,1),'yyyy-mm-dd HH:MM:SS.FFF');
    EvType{ii,:} = 'earthquake';
    EventID(ii,:) = ii;
end
Latitude = LIGO_format_data(:,11);
Longitude = LIGO_format_data(:,12);
Depth = LIGO_format_data(:,14);
Magnitude = LIGO_format_data(:,2);
T = table(EventID, OT, Latitude, Longitude, Depth, Magnitude, EvType);
write(T,out_fname)
