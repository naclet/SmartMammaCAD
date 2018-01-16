function [X0,X1,listX0,listX1]=createDatabase(database,saveoption)
% Creatye machine learning database from mat files
if nargin==1
    saveoption=false;
end
X1=[]; X0=[];
pathimg='/media/ialvarezillan/MyPassport/';
if strcmp('NME',database)
    listamask={'1-4mask.mat' '1-10mask.mat'  '1-13mask.mat' '1-14mask.mat'};% '1-12mask.mat''2-1mask.mat' '2-7mask.mat'};
    listaimg={'1-4r.mat' '1-10r.mat'  '1-13r.mat' '1-14r.mat'};% '2-1r.mat' '2-7r.mat'};'1-12r.mat'
    
elseif strcmp('DCE-MRI',database)
    nam=dir([pathimg database filesep '*.mat']);
    listaimg={nam.name};
end
totst=[];
totbmask=[];
totlmask=[];
for i=1:numel(listaimg)
    if ~isempty(strfind(listaimg{i},'different_protocol')), continue, end
    load([pathimg database filesep listaimg{i}]);
    [~,maskt]=mascara(stack_all);
    SE=strel('cube',10);
    mask2=imclose(~maskt,SE);
    if strcmp('NME',database)
        load([pathimg database filesep listamask{i}]);
       [stack_all,mask,mask2]=torax_segmentation(stack_all,database,mask,mask2);
        [x0,x1]=create_labelleddata(stack_all,mask,mask2);
    elseif  strcmp('DCE-MRI',database)
        [stack_all,mask2]=torax_segmentation(stack_all,database,mask2); 
        [x0,x1]=create_labelleddata(stack_all,mask2);      
    end
    totst=[totst stack_all];
    totbmask=[totbmask; mask2 ];
    totlmask =[totlmask; mask];
    listX0{i}=x0;
    listX1{i}=x1;
    X1=[X1 x1.x1];
    X0=[X0 x0.x0];
    if saveoption
    save([pathimg database filesep 'X0-' listaimg{i}],'x0')
    if ~isempty(X1), save([pathimg database filesep 'X1-' listaimg{i}],'x1'); end
    end
end
if saveoption
if ~isempty(X1), save([pathimg database filesep 'X1'],'X1'); end
save([pathimg database filesep 'X0'],'X0') 
end
end
 % 2-8 doesnt have the same size (29 temporal frames)
 %load('/media/ialvarezillan/MyPassport/NME/2-8mask.mat')
 %load('/media/ialvarezillan/MyPassport/NME/2-8r.mat')
 
