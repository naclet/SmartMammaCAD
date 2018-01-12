first=dir('t1_fl3d_cor_dyn_17iso_IPa_230Restzeit_0*');
second=dir('t1_fl3d_cor_dyn_17iso_IPa_0*');
for i=1:numel(first)
cd(first(i).name)
nam=dir('*.nii');
if i<10, copyfile(nam(1).name,['../00' num2str(i) '.nii']);
else
copyfile(nam(1).name,['../0' num2str(i) '.nii'])
end
cd ..
end
for j=1:numel(second)
i=i+1;
cd(second(j).name)
nam=dir('*.nii');
copyfile(nam(1).name,['../0' num2str(i) '.nii'])
cd ..
end
cd ..