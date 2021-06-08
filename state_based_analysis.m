% Written by Yimeng Zeng 5/7/2020
% E-mail:enoch29067@126.com
% qinlab.BNU

% exclude scr data, details in supplementary materials
exclude_list=[1,7,23,24,25,34,36];   

%% average scr data accoding to window length. p.s. 'final_result_n': loaded preprocessed SCL data
for n = 1:length(final_result_n)
    for i=1:window_number  
        initial_point = 1+(i-1)*movement_step;
        end_point = (i-1)*movement_step+window_length;
      % window_scr{1,n}(1,i)=median(final_result{1,n}(1,initial_point:end_point));
        window_scr_n{1,n}(1,i)=mean(final_result_n{1,n}(1,initial_point:end_point));
    end
end   
       window_scr_n(exclude_list)=[];
% separate state label into individual level

    for i=1:length(final_result_n)
        subj_state{1,i}=clt(1,1+(i-1)*window_number:i*window_number);
    end
     
      subj_state(exclude_list)=[];



%% Preparing FCs as input and corresponding SCL as response variable
for i=1:length(window_scr_n) 
      data_y(1+(i-1)*window_number:i*window_number,1) = window_scr_n{1,i}';
end

 for i=1:length(subj_state)
      data_c(1+(i-1)*window_number:i*window_number,1)=subj_state{1,i};
 end
 
 for i=1:length(subj_state)
    data_x{1,i}=data(1+(i-1)*window_number:i*window_number,:);
end
    data_x(exclude_list)=[];
    
for i=1:length(data_x)
    data_xx(1+(i-1)*window_number:i*window_number,:)=data_x{1,i};
end

data_xx_n = 1/2*log((1+data_xx)./(1-data_xx)); % Fisher-z transformed for input,output already transformed
x_s1=data_xx(find(data_c(:)==1),:);
y_s1=data_y(find(data_c(:)==1),:);
x_s2=data_xx(find(data_c(:)==2),:);
y_s2=data_y(find(data_c(:)==2),:);

%% optimal parameter set (alpha\lambda) for Elastic-net regression model 
con_vec = linspace(0,1,21);
rng(1)
for i=1:20
    [B1,FitInfo1]= lasso(x_s1,y_s1,'Alpha',con_vec(i+1),'CV',10);
    [B2,FitInfo2]= lasso(x_s2,y_s2,'Alpha',con_vec(i+1),'CV',10);
    inte_elastic{i,1}=B1;
    inte_elastic{i,2}=FitInfo1;
    segre_elastic{i,1}=B2;
    segre_elastic{i,2}=FitInfo2;
    clear B1 B2 FitInfo1 FitInfo2
end

% Choosing the parameter set with minimum standard error
for i=1:20
   inte_comp(i) = inte_elastic{i, 2}.MSE(inte_elastic{i, 2}.IndexMinMSE);
   segre_comp(i) = segre_elastic{i, 2}.MSE(segre_elastic{i, 2}.IndexMinMSE);
end

    inte_alpha = find(inte_comp(:) == min(inte_comp));
    segre_alpha = find(segre_comp(:) == min(segre_comp));
    
    B1 = inte_elastic{inte_alpha,1};
    FitInfo1 = inte_elastic{inte_alpha,2}; 
    B2 = segre_elastic{segre_alpha,1};
    FitInfo2 = segre_elastic{segre_alpha,2}; 
    
    plot(inte_comp)
    hold on
    plot(segre_comp)
    
    lassoPlot(B1,FitInfo1,'PlotType','CV');
    lassoPlot(B2,FitInfo2,'PlotType','CV');
    
  % calculate the correlation between predicted and real scl values
    [c1,p1] = corr(x_s1*B1(:,FitInfo1.Index1SE)+FitInfo1.Intercept(1,FitInfo1.Index1SE),y_s1,'Type','Pearson')
    [c2,p2] = corr(x_s2*B2(:,FitInfo2.Index1SE)+FitInfo2.Intercept(1,FitInfo2.Index1SE),y_s2,'Type','Pearson')

% finish