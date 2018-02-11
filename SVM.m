clear;
%-----------INPUTS-------------%
%-------------------Datasets----------------%

load iris.dat;
xi=iris(51:150,1);
xf=iris(51:150,3);
x=[xi,xf]; %sample set
label=iris(51:150,5); 
count1=1;
count2=1;
for i=1:100
    if (label(i)==2)
        label1(count1)=-1; %negetive label
        x1(count1,:)=x(i,:);
        count1=count1+1;
    else label2(count2)=1; %positive label
        x2(count2,:)=x(i,:);
        count2=count2+1;
    end
end
label1=-label1';
label2=-label2';
%}
%------------END of Datasets------------%

%-------------------Parameters--------------%

Train_per=60;
[test_set,test_label,x,label]=SVMdataselect(x1,x2,label1,label2,Train_per);
p=size(x);
tr=p(1);
a=zeros(1,tr); %initial lagrange Coefficients
b=0; %initial threshold b
C=10; %regularization parameter
tol=0.001; %tolerence parameter
fcache=zeros(tr,1);%cache of errors
var=90;
char='L';
%---------------end of INPUTS-----------------%

for i=1:tr
        for j=1:tr
            Ker(i,j)=SVMkernel(x(i,:),x(j,:),char,var);
        end
end

[a,b,fcache]=SVMSMO(x,tr,label,a,b,C,tol,fcache,Ker);

%-------------W----------%
for i=1:tr
    for j=1:p(2)
        q(i,j)=a(i).*label(i).*x(i,j);
    end
end
for i=1:p(2)
    w(i)=sum(q(:,i));
end

%----------Testing----------%
u=test(test_set,test_label,w,b,char,var);

%-------PLOT-------%

scatter(x1(:,1),x1(:,2),'MarkerEdgeColor','b');
scatter(x2(:,1),x2(:,2),'MarkerEdgeColor','r');

rx=floor(1.5*max(x(:,1)));
rn=floor(0.4*min(x(:,1)));
y1=randi([rn,rx],10,1);

if(char=='L')
    y2=(-y1*w(1)-b)/w(2);
    plot(y1,y2,'Color',[0 0 0]);
    hold on;
    y21=(-y1*w(1)-b-1)/w(2);
    y22=(-y1*w(1)-b+1)/w(2);
    plot(y1,y21,'Color',[0 0 0],'LineStyle',':');
    plot(y1,y22,'Color',[0 0 0],'LineStyle',':');

elseif(char=='G')
    y2=sqrt(-2*var*log(-b))+w(1)+w(2)-y1;
end
