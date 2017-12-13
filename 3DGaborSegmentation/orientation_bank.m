
function rotated_bank=orientation_bank(refimage,angleInc,interpolation)


 % Generate rotated versions of the refimage.  Note orientation
    % image provides orientation *along* the ridges, hence +90
    % degrees, and imrotate requires angles +ve anticlockwise, hence
    % the minus sign.
    %
    % The argument interpolation can be 1 or 2. 
    % 1- Bilinear interpolation (default)
    % 2- nearest interpolation
    if lt(nargin,3), interpolation=1; end
    possible_interpolations= {'bilinear' 'nearest'};
    method=possible_interpolations{interpolation};
    
    rotated_bank = cell(180/angleInc,180/angleInc);
    angle1rotated=zeros(size(refimage));
    angle2rotated=zeros(size(refimage));
    count=1;
    for o1 = 1:180/angleInc
        for i=1:size(refimage,3)
            refimage2D=squeeze(refimage(:,:,i));
            bankslice = imrotate(refimage2D,-(o1*angleInc+90),method,'crop');
            angle1rotated(:,:,i)=bankslice;
        end
        if count>10, fprintf('.'); count=1; end
            
        for o2=1:180/angleInc
            for i=1:size(refimage,1)
                angle1rotated2D=squeeze(angle1rotated(i,:,:));
                bankslice = imrotate(angle1rotated2D,(o2*angleInc),method,'crop');
                angle2rotated(i,:,:)=bankslice;
            end
            rotated_bank{o1,o2}=angle2rotated;
        end
        count=count+1;
    end