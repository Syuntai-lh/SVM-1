clear;
%-----------INPUTS-------------%
%-------------------Datasets----------------%
%{
x1=[50,50;45,50;45,40;43,47;50,51;34,56;31,45;67,34;43,56;41,30];
x2=[1,1;100,1;1,100;100,100;90,2;100,98;1,5;3,45;90,100;45,4];
label1=[1;1;1;1;1;1;1;1;1;1];
label2=[-1;-1;-1;-1;-1;-1;-1;-1;-1;-1];
%}
%x=[1,10;3,8;5,1;6,3];
%label=[1;1;-1;-1];

x1 = random('Normal',50,6,100,2);
label1=ones(100,1);
x2 = random('Normal',10,6,100,2);
label2=(-1)*ones(100,1);
x=[x1;x2];
label=cat(1,label1,label2);
%}
%{
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
%tr=floor(p(1)*((Train_per/100)));%trainning set size
%te=floor(p(1)-tr);%test set size
[test_set,test_label,x,label]=SVMdataselect(x1,x2,label1,label2,Train_per);
p=size(x);
tr=p(1);
%test_label=label(p(1)-te+1:p(1));%test_label
%label=label(1:tr);%training_label
%test_set=x(p(1)-te+1:p(1),:);%test_set
%x=x(1:tr,:);%training_set
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

%[a,b,fcache]=SVMSMO(x,tr,label,a,b,C,tol,fcache,Ker);
%{
func=0;
for i=1:tr
    for j=1:tr
        func=func+a(j).*a(i).*label(i).*label(j)*Ker(i,j);
    end
end
func=(0.5*func-sum(a(:)));
%}
a=a';
f=@(a)func(a,tr,label,Ker);
a=fmincon(f,a,zeros(1,tr),0,label',0,zeros(1,tr),C*ones(1,tr));

%-------------W----------%
for i=1:tr
    for j=1:p(2)
        q(i,j)=a(i).*label(i).*x(i,j);
    end
end
for i=1:p(2)
    w(i)=sum(q(:,i));
end
b = label(1) - w*x(1,:)';


%----------Testing----------%
u=test(test_set,test_label,w,b,char,var);

%-------PLOT-------%

%for i=1:tr
    %if(label(i)==1)
        scatter(x1(:,1),x1(:,2),'MarkerEdgeColor','b');
    %elseif(label(i)==-1)
        scatter(x2(:,1),x2(:,2),'MarkerEdgeColor','r');
    %end
%end

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
    %plot(y1,y2,'Color',[0 0 0]);
end