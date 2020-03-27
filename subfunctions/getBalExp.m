function BalExp = getBalExp

cwd = pwd;
cd([pwd filesep 'stimuli'])
list = dir; list=list(3:end);

n=0;
for k=1:length(list)
    tn = list(k).name;
    eval(['run ' pwd filesep tn filesep tn '.m'])
    if ans.active;
        n=n+1;
        BalExp(n) = ans;
    end
end

cd(cwd)