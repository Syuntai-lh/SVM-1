function [out,a,b,fcache]= update(a,k,l,e1,Ker,x,tr,label,b,C,tol,fcache)
          out=0;
          %e1
          if(l==k)
              return;
          end
          a1=a(k);
          a2=a(l);
          
          if ((a2<tol) || (a2>C-tol))
              e2=sum(a.*label'.*Ker(l,:))+b-label(l);
          else
              e2=fcache(l);
          end
          
          %e1
          %e2
          
          if(label(k)==label(l))
              L=max(0,a1+a2-C);
              H=min(C,a1+a2);
          end
          if(label(k)~=label(l))
              L=max(0,a1-a2);
              H=min(C+a1-a2,C);
          end
          
          if(H==L)
              return;
          end
          
          %size(Ker)
          k12=Ker(k,l);
          k11=Ker(k,k);
          k22=Ker(l,l);
          %size(k12)
          n=2*k12-k11-k22;
          if(n==0)
              if(label(k)*(e2-e1)*L)>(label(k)*(e2-e1)*H+tol)
                  a(k)=L;
              elseif(label(k)*(e2-e1)*L)<(label(k)*(e2-e1)*H-tol)
                  a(k)=H;
              else a(k)=a1;
              end
          elseif(n<0)
               a(k)=a(k)-(label(k)*(e2-e1)/n);
              %a(k)
              if(a(k)<L)
                  a(k)=L;
              end
              if(a(k)>H)
                  a(k)=H;
              end
              %a(l)
          end
          %a(l)
          if(a(k)<1e-8)
              a(k)=0;
          elseif (a(k) > C-1e-8)
              a(k)=C;
          end
          %a(l)
          if (abs(a(k)-a1) < tol*(tol+a(k)+a1))
              return;
          end
          %}
          
          a(l)= a2+label(k)*label(l)*(a1-a(k));
          
          b1=b-e1-label(k)*(a(k)-a1)*Ker(k,k)-label(l)*(a(l)-a2)*Ker(k,l);
          b2=b-e2-label(k)*(a(k)-a1)*Ker(l,k)-label(l)*(a(l)-a2)*Ker(l,l);
          %a(l)
          %{
          if((a(k)>0)&&(a(k)<C))
              b=b1;
          elseif((a(l)>0)&&(a(l)<C))
              b=b2;
          %}
          b=(b1+b2)/2;
          %b
          fcache(k)=0;
          fcache(l)=0;
          %end
          %{
          fcache(k)=e1+label(k)*(a(k)-a1)*Ker(k,k)+label(l)*(a(l)-a2)*Ker(k,l);
          fcache(l)=e2+label(k)*(a(k)-a1)*Ker(l,k)+label(l)*(a(l)-a2)*Ker(l,l);
          I_u =find (((a == C) & (label == -1)') | ((a == 0) &  (label == 1)') | (a>0|a<C));
          I_l = find(((a ==0) & (label == -1)') | ((a ==C) &  (label == 1)') | (a>0|a<C));
          [b_low, i_low]= max(fcache(I_l));
          [b_up, i_up]= min(fcache(I_u));
          %}
          %change_a=change_a+1;
          
          out=1;  
      end

