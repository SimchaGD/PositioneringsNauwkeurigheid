clc, clearvars, close all 
DoPrint = 0; 
%% Simulation parameters 
% The simulation runs the model for 50 timeunits 
% ts is the difference between two timeunits 
n = 50; 
t = linspace(0,n,n+1)'; 
ts = t(2)-t(1); 
 
%github test 15:16 
%% 
% The hexapod 626 can move in X, Y, and Z direction and rotate along X, Y,  
% and Z axis. 
 
dof = {'Tx','Ty','Tz','Rx','Ry','Rz'};  
 
%% 
% We let the hexapod maneuver from -25cm to +25cm with respect to the 
% neutral position. 
 
displacement = linspace(-0.25,0.25,n+1)' ;  
PlatformPosInputStruct = struct(); 
 
for ii = 1:3 
    PlatformPosInputStruct.(dof{ii}) = displacement; 
end 
 
%% 
% We let the hexapod spin, turn and revolve from -10 degrees to +10 degrees 
% with respect to neutral angle. 
 
rotation = linspace(-deg2rad(10), deg2rad(10), n+1)'; 
for ii = 4:6 
    PlatformPosInputStruct.(dof{ii}) = rotation; 
end 
 
%% 
% These parameters can deviate from the model between -5 and 5 milimiters 
 
ParameterName = {'FixedJointsRadius','FixedJointsSpacing', 'MovingJointsRadius', 'MovingJointsSpacing'}; 
delta = [-0.001 0.001]*5; % deviance of 5mm 
DiffrencesForTable = cell(2,1);
 
for Property = 1:1
     
    % read from xml file 
    ParameterValue = readproperty('HexapodKinematicsModel_626.xml','Property',ParameterName{Property},false,false); 
     
    for dofIndex = 1:6
        % prettify figure 
        name = [ParameterName{Property} ' ' dof{dofIndex}]; 
        fig = figure('Name', name,'units','normalized','outerposition',[0 0 1 1]);      
        ymin = -2e-3; 
        ymax = 2e-3; 
         
        for deltaIndex = 1:2 
             
            % apply the deviation to the parameters value 
            deviation = delta(deltaIndex); 
            NewValue = ParameterValue + deviation; 
             
            % write to xml 
            writeproperty('HexapodKinematicsReal_626.xml','Property',ParameterName{Property},NewValue,false) 
 
             
            PlatformPosInputMatrix = zeros(length(displacement),6); 
            PlatformPosInputMatrix(:,dofIndex) = PlatformPosInputStruct.(dof{dofIndex}); 
             
            % simulate hexapod 
            sim('HexapodModel'); 
             
            % simulating the hexapod creates a lot of warnings, these are  
            % irrelevant 
            PlatformPosInputMatrix(:,4:6) = rad2deg(PlatformPosInputMatrix(:,4:6))./60;
           
            RealPositions(:,4:6) = rad2deg(RealPositions(:,4:6))./60;
            % make a table with diffrences in plots
            DiffrencesForTable{deltaIndex,1} = [RealPositions(1,:);RealPositions(end,:)];
            if deltaIndex == 2
                TableForParameterdof = CreateTables(DiffrencesForTable, name)
            end
            
            % make a plot for each displacement direction and rotation axes 
            for PlotIndex=1:6 
                subplot(2,3,PlotIndex) 
                PlotDofEffects(PlotIndex, PlatformPosInputMatrix,RealPositions,dof,dofIndex, deviation) 
                
                ax = findobj(gcf,'type','axes'); 
                % set y axes range 
                deltaReal = RealPositions-PlatformPosInputMatrix;                        
                
                yminTemp = min(deltaReal(:))*1.1; 
                ymaxTemp = max(deltaReal(:))*1.1; 
                
                if yminTemp <= ymin 
                    ymin = yminTemp; 
                end 
                if ymaxTemp >= ymax 
                    ymax = ymaxTemp; 
                end 
             
                ylim(ax,[ymin ymax])
            end 
             
            % figure title 
            dim = [0.37 0.96 0.3 0.05]; 
            annotation('textbox',dim,'String',name,'FitBoxToText','on', ... 
                       'EdgeColor', 'none', 'FontSize', 18, ... 
                       'FontName', 'Palatino Linotype','HorizontalAlignment', 'center')
        end 
         
        % save figures as PNG and EMF 
        if DoPrint 
            PrintName = [num2str(fig.Number) '_' name];
            print(fig,['PNGPlots\' PrintName],'-dpng') 
            print(fig,['EMFPlots\' PrintName],'-dmeta') 
        end 
        % write original value to xml 
        writeproperty('HexapodKinematicsReal_626.xml','Property',ParameterName{Property},ParameterValue,false) 
    end 
    hold off 
end