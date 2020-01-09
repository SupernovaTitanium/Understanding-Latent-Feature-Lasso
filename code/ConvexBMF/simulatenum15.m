function [W0,Z0,R] = simulatenum15(name,N,marg,sc,NOISE)

K = 15;
D = (5+marg*2)*(3+marg*2)*9*sc^2; 
W0 = zeros(K,D);
D0 = eye(15);

for k = 1:K	
	img = reshape(D0(k,:),5,3)
	img = addmarg(img,marg)
	hei = 5+marg*2;
	wid = 3+marg*2;
	img = imgcomb(5,hei,wid,3,3,img)
	%place into W
	img = imgscale(sc,sc,img)
	size(img)
	W0(k,:) = reshape(img,[1,D]);
	imwrite(img, [name '/W' num2str(k) '.png']);
end



Z0 = binornd(1,0.5,N,K)

R =  Z0*W0+NOISE*randn(N,D);

for i = 1:N
	imwrite( reshape(R(i,:),[(5+marg*2)*3*sc,(3+marg*2)*3*sc]), [name '/R' num2str(i) '.png']);
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
function [img]=imgcomb(k,hei,wid,k1,k2,img)
	row = ceil(k/k2)
	col = k-(row-1)*k2
	img_add = zeros(hei*k1,wid*k2)
	img_add((row-1)*hei+1:row*hei,(col-1)*wid+1:col*wid)=1
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