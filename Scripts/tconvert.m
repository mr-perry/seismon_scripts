function tout = tconvert(tin)
%
% function tout = tconvert(tin)
%
% Converts between gps (numerical format) and date (string)
%
% 'tin' can be an entire column vector of date strings or gps seconds
%
% The list of leap seconds is:
%
% leapseconds = 86400*datenum(strcat(...
%     {'6/30/1972','12/31/1972','12/31/1973','12/31/1974',...
%     '12/31/1975','12/31/1976','12/31/1977','12/31/1978','12/31/1979',...
%     '6/30/1981','6/30/1982','6/30/1983','6/30/1985','12/31/1987',...
%     '12/31/1989','12/31/1990','6/30/1992','6/30/1993','6/30/1994',...
%     '12/31/1995','6/30/1997','12/31/1998','12/31/2005','12/31/2008', ...
%     '6/30/2012','6/30/2015'},...
%     ' 23:59:59'));
%
% This list needs to be updated whenever a new leap second occurs.
%
% Last changed: 8/25/2010
%
% Jan Harms
%

leapseconds = [62246102399,62261999999,62293535999,62325071999,62356607999,...
    62388230399, 62419766399, 62451302399, 62482838399, 62530099199,...
    62561635199, 62593171199, 62656329599, 62735299199, 62798457599,...
    62829993599, 62877254399, 62908790399, 62940326399, 62987759999,...
    63035020799, 63082454399, 63303379199, 63398073599, 63508320000,...
    63602928000];

if isnumeric(tin)
    %calculate date string
    thisday = tin+62483270409;
 %   thisday = thisday-sum(thisday(:,ones(1,length(leapseconds)))...
 %       >leapseconds(ones(length(thisday),1),:),2);
    tout = thisday-sum(thisday(:,ones(1,length(leapseconds)))...
        >leapseconds(ones(length(thisday),1),:),2);
  %  tout = datestr(thisday/86400);
else
    %calculate GPS seconds
    thisday = 86400*datenum(tin);  
    tout = thisday-62483270409+sum(thisday(:,ones(1,length(leapseconds)))...
        >leapseconds(ones(length(thisday),1),:),2);
end

end

