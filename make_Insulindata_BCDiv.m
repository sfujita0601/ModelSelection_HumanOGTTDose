function [Timecourse, timeStepExp, nutrientlist, timerow] = make_Insulindata_BCDiv(nutrient,save_path)
%%      function to convert the data to mat files
save_dir = [save_path '/matfile/' nutrient ]; 
 if exist(save_dir, 'dir') ==0 
    mkdir(save_dir)
 end
xls_name = '/Users/fujita/Library/Mobile Documents/com~apple~CloudDocs/Temp_human/MATLAB/Insulin/data/';

            xls_data = [
              'exp_Mean_25_B_all   '
              'exp_Mean_50_B_all   '
              'exp_Mean_75_B_all   '
              'exp_Mean_25_R_2h_all'
              'exp_Mean_50_R_2h_all'
              'exp_Mean_75_R_2h_all'
              ]; 

          mat_data = [
              'all_Mean_Glc25g     '
              'all_Mean_Glc50g_try2'
              'all_Mean_Glc75g_try2'
              'all_Mean_Glc25g_2h  '
              'all_Mean_Glc50g_2h  '
             'all_Mean_Glc75g_2h  '

              ];

for j = 1:size(mat_data,1)
    mat_name = strtrim(mat_data(j,:));
    file_name = strtrim(xls_data(j,:));
    [Timecourse,strs,RowData] = xlsread([xls_name,file_name]);
nutrientlist = strs(1,:);
timeStepExp=Timecourse(:,1);
timerow = zeros(1,length(timeStepExp));
for i = 1:length(timeStepExp);
    timerow(i) = i;
end
      indexA = strmatch([nutrient], nutrientlist);
      indexX = strmatch('Insulin(pmol/L)', nutrientlist);
      indexG = strmatch('Glucose(mg/dL)', nutrientlist);
      TimecourseA = zeros(length(timerow),1);
      TimecourseX = zeros(length(timerow),1);
      TimecourseG = zeros(length(timerow),1);      
       
      for i = 1:length(timerow);          
          TimecourseX(i) = Timecourse(timerow(i),indexX);
          if isnan(Timecourse(timerow(i),indexX)) 
          TimecourseX(i) = 0;
          else
          end
          TimecourseA(i) = Timecourse(timerow(i),indexA);
          if isnan(Timecourse(timerow(i),indexA)) 
          TimecourseA(i) = 0;
          else
          end

          TimecourseG(i) = Timecourse(timerow(i),indexG);
          if isnan(Timecourse(timerow(i),indexG)) 
          TimecourseG(i) = 0;
          else 
          end
 
      end
      

save([save_dir, '/', mat_name], 'Timecourse','timeStepExp','nutrientlist','timerow','TimecourseA','TimecourseX','TimecourseG');%,'TimecourseGIP','TimecourseCpep','TimecourseLipid')%,'-append'); %数値行�?を保�?
if exist(save_dir, 'dir') ==0 
    mkdir(save_dir) 
end
end
end