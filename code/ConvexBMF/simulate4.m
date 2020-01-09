function [W0,Z0,R] = simulate3(N,d1,d2,K1,K2,c1,c2,NOISE)

D = d1*d2;
K=K1*K2;
W0 = zeros(K,D*c1*c2*K);
for k = 1:K

	%random pattern
	img = binornd(1,0.5,d1,d2);
	%mult-sampling rate c
	c3 = 1:d1*c1;
	c3 = reshape(c3,d1,c1);
	c3 = c3';
	c3 = c3(:);
	c4 = 1:d2*c2;
	c4 = reshape(c4,d2,c2);
	c4 = c4';
	c4 = c4(:);
	img  = repmat(img,c1,c2);
	img= img(c3,c4);
	img_add = zeros(d1*c1*K1,d2*c2*K2);
	row = ceil(k/K2);
	col = k-(row-1)*K2;
	img_add((row-1)*d1*c1+1:row*d1*c1,(col-1)*d2*c2+1:col*d2*c2)=1;
	img = repmat(img,K1,K2);
	img_add = img.*img_add;

	%place into W
	W0(k,:) = reshape(img_add,[1,D*c1*c2*K]);
	imwrite(img_add, ['img_dir/W' num2str(k) '.png']);
end



Z0 = binornd(1,0.5,N,K)

R =  Z0*W0+NOISE*randn(N,D*c1*c2*K);

for i = 1:N
	imwrite( reshape(R(i,:),[d1*c1*K1,d2*c2*K2]), ['img_dir/R' num2str(i) '.png']);
end
end

