% FILTERORIENT - Estimates the local orientation of vectors in a 3D image
%
% Usage:  [vect_orient] = filterorient(im, gradientsigma,...
%                                             blocksigma, ...
%                                             orientsmoothsigma)
%
% Arguments:  im                - A normalised input image.
%             gradientsigma     - Sigma of the derivative of Gaussian
%                                 used to compute image gradients.
%             blocksigma        - Sigma of the Gaussian weighting used to
%                                 sum the gradient moments.
%             orientsmoothsigma - Sigma of the Gaussian used to smooth
%                                 the final orientation vector field. 
%                                 Optional: if ommitted it defaults to 0

function [vect_orient] = ...
             filterorient(im, gradientsigma, blocksigma, orientsmoothsigma)
        
    if ~exist('orientsmoothsigma', 'var'), orientsmoothsigma = 0; end
    % Size of the image
    [X, Y, Z] = size(im);
    
    % Calculate image gradients.
    sze = fix(6*gradientsigma);   if ~mod(sze,2); sze = sze+1; end

    f = images.internal.createGaussianKernel([gradientsigma gradientsigma gradientsigma],[sze sze sze]); % Generate Gaussian filter.
    [fx,fy,fz] = gradient(f);          
    
    % Gradient of Gausian.
    Gx = imfilter(im, fx); fprintf('.')
    Gy = imfilter(im, fy);fprintf('.')
    Gz = imfilter(im, fz);fprintf('.')
    
    for i=1:(X-sze)
        for j=1:(Y-sze)
            for k=1:(Z-sze)
                vect_orient{i,j,k}=average_moment(Gx(i:i+sze,j:j+sze,k:k+sze),Gy(i:i+sze,j:j+sze,k:k+sze),Gz(i:i+sze,j:j+sze,k:k+sze));
            end
        end
        fprintf('.')
    end
end

    function vect_orient=average_moment(Gx,Gy,Gz)
    
    M=zeros(3);
    ni=numel(Gx);
    for i=1:ni
        g_vect=[Gx(i) Gy(i) Gz(i)];
        M=M+g_vect*g_vect';
    end
    [~,eigval,eigvect]=eig(M);
    [~,max_eigval]=max(eigval(:));
    vect_orient=eigvect(:,ceil(sqrt(max_eigval)));
    
    end


    

