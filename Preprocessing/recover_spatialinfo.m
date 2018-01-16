function [img]= recover_spatialinfo(data,x)
img=zeros(size(x.breast_mask));
th=0.01;

if isfield(x,'labels_mask')
    img(gt(x.labels_mask,th))=data;

else
    
    img(and(x.breast_mask,lt(x.labels_mask,th)))=data;
end

end