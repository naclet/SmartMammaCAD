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

function [im_filt,u,v,w] = ...
             vectororient(im, gradientsigma, sze,unfreq)
        

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
    im_ext = zeros(size(im)+2*sze);
    im_ext(1+sze:end-sze,1+sze:end-sze,1+sze:end-sze) = im;
   
    
    % Create Gaussian for filtering   
    sigmax= (1/3)*sze; % FWHM is aprox. 3*sigma
    sigmay= (1/3)*sze;
    sigmaz= (1/3)*sze;
    [x,y,z] = meshgrid(-sze:sze);
    gaussian = exp(-(x.^2/sigmax^2 + y.^2/sigmay^2 +  z.^2/sigmaz^2)/2);
    
    % Inicialize outputs
    im_filt=zeros(size(im));
    u=zeros(size(im));
    v=zeros(size(im)); 
    w=zeros(size(im));     
    
   f = images.internal.createGaussianKernel([gradientsigma gradientsigma gradientsigma],3*[sze_g sze_g sze_g]); %
    Gxx=imfilter(Gx.*Gx,f);
    Gxy=imfilter(Gx.*Gy,f);
    Gxz=imfilter(Gx.*Gz,f);
    Gyy=imfilter(Gy.*Gy,f);
    Gyz=imfilter(Gy.*Gz,f);
    Gzz=imfilter(Gz.*Gz,f);
    
    
    for i=1:X
        for j=1:Y
            for k=1:Z
                
                % Vector calculation
                vect_orient = average_moment(Gxx(i,j,k),Gxy(i,j,k),Gxz(i,j,k),Gyy(i,j,k),Gyz(i,j,k),Gzz(i,j,k));
                u(i,j,k) = vect_orient(1);
                v(i,j,k) = vect_orient(2);
                w(i,j,k) = vect_orient(3);
                
                % filtering
                vect3D=vect_orient(1)*x./max(x(:))+vect_orient(2)*y./max(y(:))+vect_orient(3)*z./max(z(:));
%                gaussian = exp(-((vect_orient(1)*x+vect_orient(2)*y+vect_orient(3)*z).^2/sigmax^2)/2 );
                im_filt(i,j,k)=vector_filter(im_ext(i:i+2*sze,j:j+2*sze,k:k+2*sze),gaussian,vect3D,unfreq);
                
            end
        end
        fprintf('.')
    end
    
    
end

    function vect_orient=average_moment(Gxx,Gxy,Gxz,Gyy,Gyz,Gzz)
    
    M=[Gxx Gxy Gxz;
        Gxy Gyy Gyz;
        Gxz Gyz Gzz];
    [~,eigval,eigvect]=eig(M);
    [~,max_eigval]=max(eigval(:));
    vect_orient=eigvect(:,ceil(sqrt(max_eigval)));
    
    end

    function im_filt=vector_filter(im,gaussian,vect,unfreq)
    
%    unfreq=0.05;
    alpha_phase=0;
   im_filt=sum(sum(sum(im.*gaussian.*(exp(i*2*pi*unfreq*vect+alpha_phase)))));
  
    end
