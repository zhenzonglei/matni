function ras_coords = mm_crs2ras(vol_file,crs_coords)
% transform samples' crs coords to ras coords

nii = niftiRead(vol_file,[]);
ras_coords = mrAnatXformCoords(nii.qto_xyz, crs_coords');

end

