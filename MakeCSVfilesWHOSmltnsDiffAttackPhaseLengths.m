function MakeCSVfilesWHOSmltnsDiffAttackPhaseLengths(t,models,incdnces,attack_dur,cvrgs,OTs,varargin)
%MAKECSVFILESWHOSMLTNSDIFFATTACKPHASELENGTHS Make csv files of simulation
%results for different WHO attack phase lengths.
incdnce=[];
for i=1:nargin-6
    load(varargin{i})
    incdnce=[incdnce,incdnce1(t,1:size(cvrgs,1)*size(OTs,1):end)];
end

filename='Predictions_W0_W1_Diff_Attack_Phase_Lengths_WHO.csv';
fid=fopen(filename,'w');
str='';
for i=1:numel(models)
    for j=1:numel(attack_dur)
        for k=1:numel(incdnces)
            str=[str,['W' num2str(models(i)) '_' num2str(incdnces(k)) '_' num2str(attack_dur(j))],','];
        end
    end
end
str=[str(1:end-1) '\n'];
fprintf(fid,str);
fclose(fid);
dlmwrite(filename,incdnce,'-append')













