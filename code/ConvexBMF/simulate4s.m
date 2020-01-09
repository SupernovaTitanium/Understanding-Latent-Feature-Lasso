function [W0,Z0,R] = simulate4(name,N,marg,sc,NOISE)

D = sc*sc*(3+marg*2)^2*4
K = 4; 
W0 = zeros(K,D);
D1 =[0,1,0,1,1,1,0,1,0];
D2 =[1,1,1,1,0,0,1,0,0];
D3 =[1,1,0,1,0,0,1,1,0];
D4 =[1,1,0,0,1,0,0,1,1];
D0 =[D1;D2;D3;D4];

for k = 1:K
	
	img = reshape(D0(k,:),3,3)
	img = addmarg(img,marg)
	wid = 3+marg*2;
	img = imgcomb(k,wid,2,2,img)
	%place into W
	img = imgscale(sc,sc,img)
	size(img)
	W0(k,:) = reshape(img,[1,D]);
	imwrite(img, [name '/W' num2str(k) '.png']);
end



Z0 = binornd(1,0.5,N,K)

R =  Z0*W0+NOISE*randn(N,D);

for i = 1:N
	imwrite( reshape(R(i,:),[sqrt(D),sqrt(D)]), [name '/R' num2str(i) '.png']);
end
save([name '/Z0.mat'],'Z0');
save([name '/R.mat'],'R');
save([name '/W0.mat'],'W0');
end
function [img]=addmarg(img,marg)
	if marg < 1
		return;
	end
	[e1,e2]=size(img);
	mark1 = zeros(e1,marg);
    img = [mark1,img,mark1];
    mark2 = zeros(1,e2+marg*2);
    img = [mark2;img;mark2];
end
function [img]=imgcomb(k,wid,k1,k2,img)
	row = ceil(k/k2)
	col = k-(row-1)*k2
	img_add = zeros(wid*k1,wid*k2)
	img_add((row-1)*wid+1:row*wid,(col-1)*wid+1:col*wid)=1
	img = repmat(img,k1,k2).*img_add
end
function [img]=imgscale(sc1,sc2,img)
	[e1,e2]=size(img);
	c3 = 1:e1*sc1
	c3 = reshape(c3,e1,sc1);
	c3 = c3';
	c3 = c3(:);
	c4 = 1:e2*sc2
	c4 = reshape(c4,e2,sc2);
	c4 = c4';
	c4 = c4(:);
	img  = repmat(img,sc1,sc2);
	img  = img(c3,c4);
end