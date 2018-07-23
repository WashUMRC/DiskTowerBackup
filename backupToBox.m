
%TODO: also do logs and XRM data
doit = 1;

while doit == 1
    site = 'ftp.box.com';
    user = 'dleib@wustl.edu';
    password = 'B2July04!';

    f = ftp(site,user,password);
    cd(f,'DiskTower');

    root = 'd:\';
    %dirs of interest
    directories = {'uct40','VivaCT','XRM'};
    logs = dir(fullfile(root,'*.txt'));
    listCt = 1;
    cd('c:\users\buffa\Matlab drive');
    try
    %do both Scanco directories
    for i = 1:length(directories)-1
        currDir = fullfile(root,directories{i});
        cd(currDir);
        mkdir(f,directories{i});
        cd(f,directories{i});
        sampleDirs = dir(fullfile(currDir,'*.'));
        for j = 3:length(sampleDirs)
            currSampleDir = fullfile(currDir,sampleDirs(j).name);
            mkdir(f,sampleDirs(j).name)
            cd(f,sampleDirs(j).name);
            cd(currSampleDir)
            measDirs = dir(fullfile(currSampleDir,'*.'));
            for k = 3:length(measDirs)
                currMeasDir = fullfile(currSampleDir,measDirs(k).name);
                cd(measDirs(k).name);
                mkdir(f,measDirs(k).name);
                cd(f,measDirs(k).name);
                files = dir(currMeasDir);
                for l = 3:length(files)
%                     files(l).name
                    if contains(files(l).name,'.txt','IgnoreCase',true) || contains(files(l).name,'.com','IgnoreCase',true)
                        ascii(f);
                    else
                        binary(f);
                    end
                    lst = dir(f,files(1).name);
                    fileHere = 0;
                    for m = 1:length(lst)
                        if strcmpi(lst(m).name,files(l).name) == 1
                            fileHere = 1;
                        end
                    end
                    if fileHere == 0
                        mput(f,files(l).name)
                    end
                end
                cd('..');
                cd(f,'..');
            end
            cd('..');
            cd(f,'..');
        end
        cd('..');
        cd(f,'..');
    end
    catch
    end
end
                    
            
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    