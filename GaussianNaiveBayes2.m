close all;
clear;
clc;

data = readtable('diabetes.csv'); %reading 
%corrplot(data);
[m n]=size(data);
predictions=zeros(m,1);
compMat=zeros(m,n+1);
data=table2array(data);
w = data(:,end);
h_w=length(w);
out0=0;
out1=0;
for i=1:h_w
    if w(i)==0
        out0=out0+1;
    else
        out1=out1+1;
    end
end
pw0 = numel(find(w==0))/numel(w); %The probability that one person have diabetes in our dataset
pw1 = numel(find(w==1))/numel(w);%The probability that one person have not diabetes in our dataset
trueresult=0;
[m n]=size(data);
%test=data(:,1:end-1);
test=input("Enter test data (ex:[6	148	72	35	0	33.6	0.627	50]):")
[a b]=size(test);
acc=0;
for j=1:a
    w0_normal_pdf = 1;
    w1_normal_pdf = 1;
    for i=1:b
    C = data(:,i); %all rows ith column
    w = data(:,end); %outcome column
    w0_average = mean(C(w==0)); %average of "0" outcome
    w0_sigma = std(C(w==0)); %standart deviation
    w1_average = mean(C(w==1));
    w1_sigma = std(C(w==1));
    w0_normal_pdf = w0_normal_pdf*normpdf(test(j,i), w0_average, w0_sigma);
    w1_normal_pdf = w1_normal_pdf*normpdf(test(j,i), w1_average, w1_sigma);
    end
    w0_normal_pdf = w0_normal_pdf*pw0;
    w1_normal_pdf = w1_normal_pdf*pw1;
    if w1_normal_pdf > w0_normal_pdf
        expectedvalue=1;
     else
        expectedvalue=0;
    end
    if expectedvalue==data(j,end)
        trueresult=trueresult+1;
    end
    predictions(j,1)=expectedvalue;
    
end
acc=trueresult/m*100;
compMat=[data predictions];
w0_normal_pdf = w0_normal_pdf*pw0;
w1_normal_pdf = w1_normal_pdf*pw1;

if w1_normal_pdf > w0_normal_pdf
	disp('Outcome is=1')
else
    disp('Outcome is=0')
end
fprintf("Accuracy of the Gaussian Naive Bayes method is:%.2f",acc);