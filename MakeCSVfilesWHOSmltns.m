function MakeCSVfilesWHOSmltns(t,models,incdnces,cvrgs,OTs,rsltsW0,rsltsW1)
%MAKECSVFILESWHOSMLTNS Make csv files of simulation results for WHO guidelines. 
load(rsltsW0)
incdnceW0=incdnce1(t,:);

load(rsltsW1)
incdnceW1=incdnce1(t,:);

filename='Predictions_W0_W1_WHO.csv';
fid=fopen(filename,'w');
str='';
for i=1:numel(models)
    for j=1:numel(incdnces)
        for k=1:size(cvrgs,1)
            for l=1:size(OTs,1)
                str=[str,['W' num2str(models(i)) '_' num2str(incdnces(j)) '_' num2str(100*cvrgs(k,1)) '_' num2str(OTs(l,2))] ','];
            end
        end
    end
end
str=[str(1:end-1) '\n'];
fprintf(fid,str);
fclose(fid);
dlmwrite(filename,[incdnceW0,incdnceW1],'-append')













