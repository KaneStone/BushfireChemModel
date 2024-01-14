% read in and stitch photolysis if TUV crashes

% what to read in here
outputdir = '/Users/kanestone/work/code/BushfireChemModel/output/TUVoutput/temp/stitched/';

for i = 1:91
    p1 = load(['/Users/kanestone/work/code/BushfireChemModel/output/TUVoutput/temp/new3/',num2str((i-1)),'km_0.25hourstep_photo_new3.mat']);
    p2 = load(['/Users/kanestone/work/code/BushfireChemModel/output/TUVoutput/temp/new2/',num2str((i-1)),'km_0.25hourstep_photo_new2.mat']);
    p3 = load(['/Users/kanestone/work/code/BushfireChemModel/output/TUVoutput/temp/new1/',num2str((i-1)),'km_0.25hourstep_photo_new1.mat']);
    pout = p1.pout+p2.pout+p3.pout;
    save([outputdir,num2str((i-1)),'km_0.25hourstep_photo.mat'],'pout')
end