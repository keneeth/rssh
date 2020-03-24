function B= Schmidt(A)
% input:A=[a1,a2,...ap]
% output:Matrix B after orthogonalization

[n,p]=size(A);
B=zeros(n,p);

B(:,1) = A(:,1);
if p>=2
    for i=2:p
        B(:,i)=A(:,i);  
        for j=1:i-1
            B(:,i)=B(:,i)-(B(:,j)'*A(:,i))/(B(:,j)'*B(:,j))*B(:,j);
        end
        B(:,i)=B(:,i)/norm(B(:,i));
    end
end

