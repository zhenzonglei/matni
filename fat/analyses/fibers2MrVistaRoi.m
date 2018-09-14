
function fibers2MrVistaRoi(roifg,roiFolder,volFolder,outname,roiNum,xformVAnatToAcpc)

roi = dtiNewRoi(roifg.name, roifg.colorRgb./255, round(horzcat(roifg.fibers{:}))');
coordinateSpace='acpc';
versionNum=1;
roi.name=outname;

          %  cd(fullfile(ExpDir))
            %outname=[hemname ROIName{1} '_' hemname inputROIName{1} '_DC']
cd(roiFolder);
save(outname,'coordinateSpace', 'versionNum', 'roi')

cd(volFolder);            
view = initHiddenVolume(5,1,[]);
for(ii=1:length(roiNum))
    %roi = handles.rois(roiNum(ii));
    coords = unique(round(mrAnatXformCoords(inv(xformVAnatToAcpc),roi.coords)),'rows')';
    view = newROI(view, ['dti_' roi.name], 1);
    view.ROIs(view.selectedROI).coords = coords;
    saveROI(view, view.ROIs(length(view.ROIs)), 0, 1)
end

% Is there a better way to do this?
mrGlobals;
eval([view.name '=view;']);
end