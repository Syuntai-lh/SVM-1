function [test_set,test_label,x,label]=SVMdataselect(x1,x2,label1,label2,Train_per)
q=size(x1);
tr1=(q(1)*((Train_per/100)));
r=size(x2);
tr2=(r(1)*((Train_per/100)));

test_set1=x1(tr1+1:q(1),:);
test_set2=x2(tr2+1:r(1),:);
test_set=[test_set1;test_set2];
x1=x1(1:tr1,:);
x2=x2(1:tr2,:);
x=[x1;x2];

test_label1=label1(tr1+1:q(1));
test_label2=label2(tr2+1:r(1));
test_label=[test_label1;test_label2];
label1=label1(1:tr1);
label2=label2(1:tr2);
label=[label1;label2];

%plot the test cases before_hand
scatter(test_set1(:,1),test_set1(:,2),'MarkerEdgeColor',[0 0 0],'MarkerFaceColor','b');
hold on;
scatter(test_set2(:,1),test_set2(:,2),'MarkerEdgeColor',[0 0 0],'MarkerFaceColor','r');
hold on;