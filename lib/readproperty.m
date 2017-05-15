function value = readproperty(XmlFileName,NodeName,PropertyName,RawValue,ReadPropertyValue)
%WRITEPROPERTY Write a property value to a specified nodename in an xml file
% WRITEPROPERTY(XmlFileName,NodeName,PropertyName,value)
%
% INPUT PARAMETERS
%
%   XmlFileName   Name of xml file to change the property value
%   NodeName      Name of node to change the property value
%   PropertyName  Name of property to change the property value
%   rawvalue      if true, will not convert the value into a numeric
%
% OUTPUT PARAMETERS
%
%   value         value of the property. 

if nargin==3
    RawValue=false;
end

xDoc=xmlread(fullfile((XmlFileName)));

properties=xDoc.getElementsByTagName(NodeName);

for ii = 0: properties.getLength-1
    name = properties.item(ii).getAttribute('Name');
    if strcmp(char(name),PropertyName)
        if ReadPropertyValue
            value = str2num(properties.item(ii).getAttribute('Value'));
        else
        value = str2num(properties.item(ii).getTextContent);
        % if you are not sure it is a numeric value, get the raw string
        if RawValue
            value = char(properties.item(ii).getTextContent);
        end
        end
    end
end
