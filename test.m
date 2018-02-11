function u=test(test_set,test_label,w,b,char,var)
te=size(test_set);
u=0;
if(char=='L')
    for k=1:te(1)
        z=(w*test_set(k,:)'+b);
        if(test_label(k)==1) && (z>=1)
            u=u+1;
        elseif(test_label(k)==-1) && (z<=-1)
            u=u+1;
        end
    end
end
if(char=='G')
   for k=1:te(1)
        z=(exp(-(norm(test_set(k,:)-w)).^2/(2*var))'+b)
        if(test_label(k)==1) && (z<=0)
            u=u+1;
        elseif(test_label(k)==-1) && (z>=0)
            u=u+1;
        end
   end
end 
u=u/te(1);
    