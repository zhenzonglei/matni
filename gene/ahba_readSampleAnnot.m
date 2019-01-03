function sample = readSampleAnnot(annotFile)
% sample = readSampleAnnot(annotFile)
% annotFile = 'SampleAnnot.csv';

fmt = '%d %d %d %s %q %q %d %d %d %d %f %f %f';
fid = fopen(annotFile);
C = textscan(fid, fmt, 'Headerlines',1,'Delimiter',',');
fclose(fid);

sample.stru_id = C{1}; 
sample.slab_num = C{2};
sample.well_id = C{3};
sample.slab_type = C{4};
sample.stru_acronym = C{5};
sample.stru_name = C{6};
sample.polygon_id = C{7};
sample.nat_ijk =  [C{8}, C{9}, C{10}];
sample.mni_xyz =  [C{11}, C{12}, C{13}]; 

clear C
