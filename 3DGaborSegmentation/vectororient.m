% VECTORORIENT - Estimates the local orientation of vectors in a 3D image
%
% Usage:  [vect_orient] = vectororient(im, gradientsigma,...
%                                             blocksigma, ...
%                                             orientsmoothsigma)
%
% Arguments:  im                - A normalised input image.
%             gradientsigma     - Sigma of the derivative of Gaussian
%                                 used to compute image gradients.
%             blocksigma        - Sigma of the Gaussian weighting used to
%                                 sum the gradient moments.
% Output:     vect_orient       - A cell of the same size as im, defining a
%                                 3D vector for each point in the space
%
% 2017 - Ignacio Alvarez Illan - illan [at] ugr [dot] es

function [u,v,w] = ...
             vectororient(im, gradientsigma, sze)
        

    % Size of the image
    [X, Y, Z] = size(im);
    
    % Calculate image gradients.
    sze_g = fix(6*gradientsigma);   if ~mod(sze_g,2); sze_g = sze_g+1; end

    f = images.internal.createGaussianKernel([gradientsigma gradientsigma gradientsigma],[sze_g sze_g sze_g]); % Generate Gaussian filter.
    [fx,fy,fz] = gradient(f);          
    
    % Gradient of Gausian.
    Gx = imfilter(im, fx); fprintf('.')
    Gy = imfilter(im, fy);fprintf('.')
    Gz = imfilter(im, fz);fprintf('.')
    
    % Extend the images to average on the borders. Add a margin of size sze
    % at the beginning and at the end
    Gx_ext=zeros(size(Gx)+2*sze);
    Gx_ext(1+sze:end-sze,1+sze:end-sze,1+sze:end-sze)=Gx;
    Gy_ext=zeros(size(Gy)+2*sze);
    Gy_ext(1+sze:end-sze,1+sze:end-sze,1+sze:end-sze)=Gy;
    Gz_ext=zeros(size(Gz)+2*sze);
    Gz_ext(1+sze:end-sze,1+sze:end-sze,1+sze:end-sze)=Gz;
    
    
    for i=(1+sze):X
        for j=(1+sze):Y
            for k=(1+sze):Z
                % Define intervals to average
                i_int = i-sze:i+sze;
                j_int = j-sze:j+sze;
                k_int = k-sze:k+sze;
                
                % Vector calculation
                vect_orient=average_moment(Gx_ext(i_int,j_int,k_int),Gy_ext(i_int,j_int,k_int),Gz_ext(i_int,j_int,k_int));
                u(i-sze,j-sze,k-sze)=vect_orient(1);
                v(i-sze,j-sze,k-sze)=vect_orient(2);
                w(i-sze,j-sze,k-sze)=vect_orient(3);
            end
        end
        fprintf('.')
    end
end

    function vect_orient=average_moment(Gx,Gy,Gz)
    
    M=zeros(3);
    ni=numel(Gx);
    for i=1:ni
        vect=[Gx(i) Gy(i) Gz(i)];
%        norm_vect=vect/norm(vect);
        M=M+vect'*vect;
    end
    [~,eigval,eigvect]=eig(M);
    [~,max_eigval]=max(eigval(:));
    vect_orient=eigvect(:,ceil(sqrt(max_eigval)));
    
    end


    

