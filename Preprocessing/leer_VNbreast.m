function [b,mask_g]=leer_VNbreast(directoriodeimagenes)
list=dir(directoriodeimagenes);
p_img=dicomread([directoriodeimagenes filesep list(3).name]);
S=size(p_img,1);
b=zeros(numel(list)-3,S,S);
mask_g=zeros(numel(list)-3,S,S);
for i=3:(numel(list)-1)
    b(i-2,:,:)=dicomread([directoriodeimagenes filesep list(i).name]);
    in=dicominfo([directoriodeimagenes filesep list(i).name]);
    if isfield(in,'CurveData_0')
        curve=in.CurveData_0;
        x(:,2)=curve(1:2:end);
        x(:,1)=curve(2:2:end);
        mask=points2bw(x,S,S);
        mask_g(i-2,:,:)=mask;
        clear x
        fprintf .\n
    end
    inNum(i-2)=in.InstanceNumber;
end
[~,order]=sort(inNum);
b=b(order,:,:);
mask_g=mask_g(order,:,:);
end