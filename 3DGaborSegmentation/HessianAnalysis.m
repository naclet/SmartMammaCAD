function [aut1,aut2,aut3,detHess,R1,R2,s,avec1,avec2,avec3]=HessianAnalysis(Gxx,Gyy,Gzz,Gxy,Gyz,Gzx)
[s1, s2, s3]=size(Gxx);
for i=1:s1
for j=1:s2
for k=1:s3
Hess=[Gxx(i,j,k) Gxy(i,j,k) Gzx(i,j,k); Gxy(i,j,k) Gyy(i,j,k) Gyz(i,j,k); Gzx(i,j,k) Gyz(i,j,k) Gzz(i,j,k)];
[eigvect, eival]=eig(Hess);
detHess(i,j,k)=det(Hess);
eigvectsort=sort(abs(diag(eival)));
if ~isreal(eigvect), eigvectsort=[0 0 1]; end
aut1(i,j,k)=eigvectsort(1);aut2(i,j,k)=eigvectsort(2);aut3(i,j,k)=eigvectsort(3);
avec1(i,j,k)=eigvect(1,3);avec2(i,j,k)=eigvect(2,3);avec3(i,j,k)=eigvect(3,3);
R1(i,j,k)=eigvectsort(1)/(eigvectsort(2)+eps);
R2(i,j,k)=eigvectsort(3)/(sqrt(abs(eigvectsort(1)*eigvectsort(2)))+eps);

end
end
end
s=sqrt(aut1.^2+aut2.^2+aut3.^2);
end