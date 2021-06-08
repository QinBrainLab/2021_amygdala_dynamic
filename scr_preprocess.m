% Written by Yimeng Zeng 2021/6/8

% read the file
for i = 1:length(list)
 % filelist{1,i} = strcat('s',list{i},'.mat');
  filelist{1,i} = strcat(list{i},'_RS1.mat');
end

for i=1:length(list)
    load(filelist{i})
    all_data{1,i}=data;
    clear data isi_units labels list start_sample units
end

% choose data that during scanning 
 scan_length=8*60*1000;
    for i=1:length(all_data)
        end_p=max(find(all_data{1,i}(:,2)~=0));
        start_p=min(find(all_data{1,i}(:,2)~=0));
        final_result{1,i}=all_data{1,i}(end_p-scan_length+1:end_p,1);
    end

% lowpass filtering with cut off 10Hz
    for i=1:37
      % signal{1,i}(:,1)=filter(b,1,signal{1,i}(:,1));
      signal{1,i}(:,1)=lowpass(final_result{1,i}(:,1),10,1000);
    %  signal{1,i}(:,1)=highpass(all_data{1,i}(:,1),1,1000);
    %  signal{1,i}(:,1) = bandpass(final_result{1,i}(:,1),[0.008 10],1000);
       F_signal{1,i}=signal{1,i};
    end
    
% detrend  
    for i=1:37
        final_result{1,i}(:,1) = F_signal{1,i};
    end
    
    for i=1:length(signal)
        DF_signal{1,i}(:,1)=detrend(final_result{1,i}(:));
    end
    
% downsample    
    for i=1:length(DF_signal)
        for j=1:240
        final_result{1,i}(1,j)=mean(DF_signal{1,i}(1+2000*(j-1):2000*j,1));
      %  final_result{1,i}(1,j)=median(DF_signal{1,i}(1+2000*(j-1):2000*j,1));
        end
    end
    
% normalize
   final_result_n = final_result;
    for i=1:length(final_result_n)
        final_result_n{1,i}=final_result_n{1,i}/std(final_result_n{1,i});
    end

% match to dyanmic states
total_time_series = 240; 
window_length = 40;
movement_step= 1;
window_number= (total_time_series-window_length)/movement_step+1;
    for n = 1:length(final_result_n)
        for i=1:window_number  
            initial_point = 1+(i-1)*movement_step;
            end_point = (i-1)*movement_step+window_length;
            % window_scr{1,n}(1,i)=median(final_result{1,n}(1,initial_point:end_point));
            window_scr_n{1,n}(1,i)=mean(final_result_n{1,n}(1,initial_point:end_point));
        end
    end   
    