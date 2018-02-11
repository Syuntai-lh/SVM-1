function [a,b,fcache]=SVMSMO(x,tr,label,a,b,C,tol,fcache,Ker)    
    %{
    I_u =find (((a == C) & (label == -1)') | ((a == 0) &  (label == 1)') | (a>0&a<C));
    I_l = find(((a ==0) & (label == -1)') | ((a ==C) &  (label == 1)') | (a>0&a<C));
    [b_low, i_low]= max(fcache(I_l));
    [b_up, i_up]= min(fcache(I_u));
%}
    %passes=0;
    count=0;
    change_a=0;
    examineAll=1;
    while ((change_a>0) || examineAll)
        
        change_a=0;
        for k=1:tr
          if((a(k)<tol)||(a(k)>C-tol))
              e1=sum(a.*label'.*Ker(k,:))-label(k)+b;
              %b
              %fcache(k)=e1;
          else e1=fcache(k);
          end
          r1=e1*label(k);
          if ((r1< -tol)&&(a(k)<C)) || ((r1>tol) && (a(k) > 0))
              %tmp=find((fcache>tol) & (fcache<C-tol));
              
              if(e1>0)
                  [~,l]=max(fcache);
                  [out,a,b,fcache]= update(a,k,l,e1,Ker,x,tr,label,b,C,tol,fcache);
                   change_a=change_a+out;
                   %out
              %count=count+1;
              elseif(e1<0)
                  [~,l]=min(fcache);
                  [out,a,b,fcache]= update(a,k,l,e1,Ker,x,tr,label,b,C,tol,fcache);
                  change_a=change_a+out;
                  %out
              %count=count+1;
              end
          end
        end
        if (examineAll==1)
            examineAll=0;
        elseif (change_a==0)
            examineAll=1;
        end
        %out
        %change_a
        count=count+1;
        %change_a=0;
        %examineAll=0;
    end
    %b=(b_low+b_up)/2;
end