function [big_mask,x,reduced_mask,reduced_img]=create_ROImask(imgnii, xmlfile, imgcoarse)

stacki2=double(imgnii.img);

x=extract_ROI('.',xmlfile);
fprintf 'Point coordinates extracted\n'

big_mask=zeros(size(stacki2));
list=find(x(1,1,:));
[N, M]=size(squeeze(big_mask(:,1,:)));
for i=list(1):list(end)
    ncc=bwconncomp(x(:,1,i)>0);
    for j=1:ncc.NumObjects
        mask=points2bw(x(ncc.PixelIdxList{j},:,i),N,M);
        big_mask(:,size(stacki2,2)-i,:)=squeeze(big_mask(:,size(stacki2,2)-i,:))+mask;
    end
end


[reduced_mask,reduced_img]=resize_delineatedcontour(imgnii,imgcoarse,big_mask);

fprintf('completed!\n')
end

% cd(dire)
% dcmi=dir('IM-0001*.dcm');
% if isempty(dcmi), bajauno=1; cd('DICOM'); dcmi=dir('IM-0001*.dcm');end
% for i=1:numel(dcmi)
% a=dicomread(dcmi(i).name);
% stacki2(:,:,i)=a;
% end
% cd ..

