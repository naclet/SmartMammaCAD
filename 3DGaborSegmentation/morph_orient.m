function im_eroded=morph_orient(binary_im,orient1,orient2,k,angleInc,operation)

% This function performs an oriented morphological operarion of the image
% If operation=1, then the operation is a erosion
% If operation=2. then the operation is a dilation
 im_eroded=zeros(size(binary_im));
 
nhood=zeros([2*k+1 2*k+1 2*k+1]);
SE=strel('square',k);
nhood(ceil((2*k+1)/2),1:size(SE.Neighborhood,1),1:size(SE.Neighborhood,1))=SE.Neighborhood;
nhood_bank=orientation_bank(nhood,angleInc,2);
[validr, validc, valids]=ind2sub(size(binary_im),find(binary_im));

% Convert orientation matrix values from radians to an index value
% that corresponds to round(degrees/angleInc)
maxorientindex = round(180/angleInc);
orientindex1 = round(orient1/pi*180/angleInc);
orientindex2 = round(orient2/pi*180/angleInc);
i1 = find(orientindex1 < 1);   orientindex1(i1) = orientindex1(i1)+maxorientindex;
i1 = find(orientindex1 > maxorientindex);
orientindex1(i1) = orientindex1(i1)-maxorientindex;
i2 = find(orientindex2 < 1);   orientindex2(i2) = orientindex1(i2)+maxorientindex;
i2 = find(orientindex2 > maxorientindex);
orientindex2(i2) = orientindex2(i2)-maxorientindex;

% Expand the image to filter the image boundary
binary_imn=zeros(size(binary_im,1)+2*k,size(binary_im,2)+2*k,size(binary_im,3)+2*k);
binary_imn(1+k:size(binary_im,1)+k,1+k:size(binary_im,2)+k,1+k:size(binary_im,3)+k) = binary_im;

for i=1:numel(validr)
    r = validr(i);
    c = validc(i);
    s = valids(i);
    and_matrix=and(binary_imn(r:r+2*k, c:c+2*k,s:s+2*k),nhood_bank{orientindex1(r,c,s),orientindex2(r,c,s)});
    equality_matrix=(and_matrix==nhood_bank{orientindex1(r,c,s),orientindex2(r,c,s)});
    if operation==1
        im_eroded(r,c,s)=all(equality_matrix(:));
    elseif operation==2
        im_eroded(r,c,s)=any(equality_matrix(:));
    end



end