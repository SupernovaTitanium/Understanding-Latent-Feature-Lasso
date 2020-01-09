function [] = transform_scale()
load('data.mat');
% rescaling R_center and R_exc
[R_center] = scaling(R_center);
[R_exc] = scaling(R_exc);
% [R_fac] = scaling(R_fac);
[W0_center] = scaling(W0_center);
[W0_exc] = scaling(W0_exc);
% [W0_fac] = scaling(W0_fac);
[Vc_center] = scaling(Vc_center);
[Vc_exc] = scaling(Vc_exc);
% [Vc_fac] = scaling(Vc_fac);
save('transform.mat');
end

function [Rscale] = scaling(R)
	[n,pix] = size(R);
	Rscale = zeros(n,21*15);
	for i=1:n
		a = R(i,:);
		a= reshape(a,105,75);		
		b = a(1:5:end,1:5:end);		
		b = reshape(b,1,21*15);
		Rscale(i,:) = b;
	end
end

