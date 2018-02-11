function ff=func(a,tr,label,Ker)
ff=0;
for i=1:tr
    for j=1:tr
        ff=ff+a(j).*a(i).*label(i).*label(j)*Ker(i,j);
    end
end
ff=(0.5*ff-sum(a(:)));
end