function PlotDofEffects(PlotIndex, PlatformPosInputMatrix,RealPositions,dofNames,dofIndex, deviation)

        if deviation >= 0
            if PlotIndex==dofIndex
                plot(PlatformPosInputMatrix(:,dofIndex),RealPositions(:,PlotIndex)-PlatformPosInputMatrix(:,dofIndex),'.-')
            else
                plot(PlatformPosInputMatrix(:,dofIndex),RealPositions(:,PlotIndex),'.-')
            end
        else
            if PlotIndex==dofIndex
                plot(PlatformPosInputMatrix(:,dofIndex),RealPositions(:,PlotIndex)-PlatformPosInputMatrix(:,dofIndex),'*-')
            else
                plot(PlatformPosInputMatrix(:,dofIndex),RealPositions(:,PlotIndex),'*-')
            end
        end
        
        hold all
        ylim([min(min(RealPositions-PlatformPosInputMatrix)) max(max(RealPositions-PlatformPosInputMatrix))]*1.1)
        
        if PlotIndex == 1 || PlotIndex == 2 || PlotIndex == 3
            title(['Pos' dofNames{PlotIndex}])
        else
            title(['Rot' dofNames{PlotIndex}])
        end
        
        xlabel(['Model Platform Position ' dofNames{dofIndex}])
        ylabel(['Real Platform Position' dofNames{PlotIndex}])
        grid on
end