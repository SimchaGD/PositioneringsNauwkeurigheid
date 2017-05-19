function TableForParameterdof = CreateTables(DiffrencesForTable, name)
T = table([DiffrencesForTable{1}(:,1);DiffrencesForTable{2}(:,1)],...
          [DiffrencesForTable{1}(:,2);DiffrencesForTable{2}(:,2)],...
          [DiffrencesForTable{1}(:,3);DiffrencesForTable{2}(:,3)],...
          [DiffrencesForTable{1}(:,4);DiffrencesForTable{2}(:,4)],...
          [DiffrencesForTable{1}(:,5);DiffrencesForTable{2}(:,5)],...
          [DiffrencesForTable{1}(:,6);DiffrencesForTable{2}(:,6)],...
          'RowNames',{'-5mm | -25cm/-10�','-5mm | +25cm/+10�','+5mm | -25cm/-10�','+5mm | +25cm/+10�'});
      
T.Properties.VariableNames = {'Tx' 'Ty' 'Tz' 'Rx' 'Ry' 'Rz'};

TableForParameterdof = T;

          
          