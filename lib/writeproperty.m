function writeproperty(XmlFileName,TagName,AttributeName,content,ChangeAttributeValue)
%WRITEPROPERTY Write the Contents or change the value of attribute 'Value' from an Element with attribute 'Name'=AttributeName' in a specified xml file
% WRITEPROPERTY(XmlFileName,TagName,AttributeName,content,ChangeAttributeValue)
%
% INPUT PARAMETERS
%
%   XmlFileName             Name of xml file 
%   TagName                 TagName of Element to change the content
%   AttributeName           Value of attribute 'Name' to change the content
%   content                 Textcontent of the Element. Must be of type string or numeric
%   ChangeAttributeValue    True: changing the value of attribute 'Value'
%                           false: changing the contents of ElementName with attribute 'Name' = AttributeName
%
%    if ChangeAttributeValue = true
%
%    <Parameter Name='ActMOIFixed' Value='77' />
%    <ElementName Name='AttributeName' Value='content' />
%
%    if ChangeAttributeValue = false
%
%    <Property Name='ActuatorMaximumPosition' Type='Float' Unit='m'>3.865</Property>
%    <ElementName Name='AttributeName' ...>content</ElementName>

if nargin == 4
    ChangeAttributeValue = false;
end

% check if content is string, if not convert with num2str
if ~ischar(content)
    if isnumeric(content)
        content = num2str(content);
    else
        error('content is not provided as string or numeric')
    end
end

xDoc=xmlread(fullfile((XmlFileName)));

elements=xDoc.getElementsByTagName(TagName);

% find all elements with attribute 'Name' = AttributeName
matchElement = [];
for ii = 0: elements.getLength-1
    name = elements.item(ii).getAttribute('Name');
    if strcmp(char(name),AttributeName)
            matchElement = [matchElement ii];
    end
end

% generate warning if NO or if more than one elements are found
switch length(matchElement)
    case 0
        warning('No elements with tagname = %s and attribute Name = %s',TagName,AttributeName)
        return
    case 1
    otherwise
        warning('Found %d elements with tagname = %s and attribute Name = %s',length(matchElement), TagName, AttributeName)
end

% set attribute Value or the textcontent of the matching elemements
for jj = 1:length(matchElement)
    if ChangeAttributeValue
      elements.item(matchElement(jj)).setAttribute('Value',content)
    else
      elements.item(matchElement(jj)).setTextContent(content)
    end
end

% bypass xmlwrite for pretty print
str = char(xDoc.saveXML(xDoc.getDocumentElement));
% enforce UTF-8 encoding (bug in saveXML)
str=strrep(str, 'encoding="UTF-16"', 'encoding="UTF-8"');
% use single quote instead of double quote
str=strrep(str, '"', '''');
fid = fopen(XmlFileName, 'wt');
fwrite(fid, str);
fclose(fid);