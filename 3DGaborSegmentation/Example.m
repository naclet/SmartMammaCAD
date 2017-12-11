

% Create an intersecting sphere with a plane
B=strel('sphere',15);
C=zeros(60,60,60);
C(15:15+30,15:15+30,15:15+30)=B.Neighborhood;
C(:,:,12:18)=1;

% Applpy 3D Gabor filtering

sigma=8;
frequency=1.5;
[nim,u,v,w] = vectororient(C,1,sigma, frecuency);