function [X0,X1]=create_labelleddata(stack_all,mask,mask2)

if nargin<3
    x0=double(stack_all(:,mask>0));X1.x1=[];
    X0.x0=x0;X0.breast_mask=mask;
else
% set threshold for consider interesting data (many lie below the 0.001
% range
th=0.01;
x1=double(stack_all(:,mask>th));
x0=double(stack_all(:,and(mask2,lt(mask,th))));

%Weight the data 
x0=(x0-mean(x0(:)))./std(x0(:));
x1=(x1-mean(x1(:)))./std(x1(:));

%the last row will be the label row
x1=[x1 ;mask(mask(:)>th)'];
X0.x0=x0;X0.breast_mask=mask2;
X1.x1=x1;X1.labels_mask=mask;X1.breast_mask=mask2;
end