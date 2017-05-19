function PlotDofEffects(PlotIndex, PlatformPosInputMatrix,RealPositions,dofNames,dofIndex, deviation)
    deltaReal = RealPositions(:,PlotIndex)-PlatformPosInputMatrix(:,dofIndex);
    
    
    if deviation >= 0
        linestyle = 'b*-';
    else 
        linestyle = 'ro-';
    end
    
    % set y input
    if PlotIndex==dofIndex
        MotionMatrix = deltaReal;
    else
        MotionMatrix = RealPositions(:,PlotIndex);    
    end
    
    plot(PlatformPosInputMatrix(:,dofIndex),MotionMatrix,linestyle)
    hold all
    
    % prettify figures
    PosRot = {'Position ', 'Rotation '};
    Units = {' in metres',' in radiants'};
    if PlotIndex <= 3
        effect = PosRot{1};
        yUnit = Units{1};
    else
        effect = PosRot{2};
        yUnit = Units{2};
    end
    title([effect dofNames{PlotIndex}])
    ylabel(['Real Platform ' effect dofNames{PlotIndex} yUnit])
    
    if dofIndex <= 3
        movement = PosRot{1};
        xUnit = Units{1};
    else
        movement = PosRot{2};
        xUnit = Units{2};
    end
    xlabel(['Model Platform ' movement dofNames{dofIndex} xUnit])
    
    grid on
end