% function copyScancoDataToDataTower()

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%This function copies all data from both Scanco towers to our local data
%%storage system. It is intended to be run nightly from that data storage
%%system as a scheduled Windows task. Still check in on it once in a while
%%though to make sure it's running.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
run = 1;
while run == 1

    sysLine = fullfile(pwd,'XRMDataCopyFromN.cmd');
    system(sysLine);
    
    clear all;clc;
    
    fileExtensions = {'rsq','isq','gobj','scv','aim','rad','txt','com'};%
    
    baseDir = 'd:';
    system(['md ' baseDir]);
    logFile = [baseDir '\' datestr(now,1) '-log.txt'];
    diary(logFile);
    targetBaseDir = [baseDir '\VivaCT'];
    
    %%do the uCT40
    'Doing VivaCT40'
    for outer = 1:length(fileExtensions)
        fileExtensions{outer}
        f = ftp('10.21.24.203','microct','mousebone4','System','OpenVMS');
        if strcmpi(fileExtensions{outer},'txt') == 1 || strcmpi(fileExtensions{outer},'com') == 1
            ascii(f);
        else
            binary(f);
        end
        cDir = cd(f,'dk0:[MICROCT.DATA]');
        dirs = dir(f,'*.dir*');
        for i = 1:length(dirs)
            %         if str2num(dirs(i).name(1:8)) > 5000 || str2num(dirs(i).name(1:8)) < 2500
            try
                cd(f,dirs(i).name(1:length(dirs(i).name)-6));
                mDirs = dir(f,'*.dir*');
                f
                for j = 1:length(mDirs)
                    try
                        clc
                        cd(f,mDirs(j).name(1:length(mDirs(j).name)-6))
                        files = dir(f,['*.' fileExtensions{outer} ';*'])
                        if ~isempty(files)
                            numFiles = str2num(files.name(end));
                            for k = 1:numFiles
                                file = [files.name(1:end-2) ';' num2str(k)];
                                try
                                    theDir = makeTheDir(targetBaseDir,dirs(i).name(1:end-6),mDirs(j).name(1:end-6));
                                    try
                                        cleanBadFile(file,theDir,f);
                                    catch
                                        [targetBaseDir,dirs(i).name(1:end-6),mDirs(j).name(1:end-6) ' cleaning failed']
                                    end
                                    try
                                        getTheFiles(file,f,theDir);
                                    catch
                                        [targetBaseDir,dirs(i).name(1:end-6),mDirs(j).name(1:end-6) ' failed']
                                    end
                                catch
                                end
                            end
                        end
                        cd(f,'..');
                    catch
                    end
                end
                cd(f,'..');
            catch
            end
            %         end
        end
        close(f);
    end
    
    clear all;clc;
    
    fileExtensions = {'rsq','isq','gobj','scv','aim','rad','txt','com'};%
    
    baseDir = 'd:';
    system(['md ' baseDir]);
    logFile = [baseDir '\' datestr(now,1) '-log.txt'];
    diary(logFile);
    targetBaseDir = [baseDir '\uct40'];
    
    %%do the uCT40
    'Doing uCT40'
    for outer = 1:length(fileExtensions)
        fileExtensions{outer}
        f = ftp('10.21.24.204','microct','mousebone4','System','OpenVMS');
        if strcmpi(fileExtensions{outer},'txt') == 1 || strcmpi(fileExtensions{outer},'com') == 1
            ascii(f);
        else
            binary(f);
        end
        cDir = cd(f,'dk0:[MICROCT.DATA]');
        dirs = dir(f,'*.dir*');
        for i = 1:length(dirs)
            if str2num(dirs(i).name(1:8)) > 5000 || str2num(dirs(i).name(1:8)) < 2500
                try
                    cd(f,dirs(i).name(1:length(dirs(i).name)-6));
                    mDirs = dir(f,'*.dir*');
                    f
                    for j = 1:length(mDirs)
                        try
                            clc
                            cd(f,mDirs(j).name(1:length(mDirs(j).name)-6))
                            files = dir(f,['*.' fileExtensions{outer} ';*'])
                            if ~isempty(files)
                                numFiles = str2num(files.name(end));
                                for k = 1:numFiles
                                    file = [files.name(1:end-2) ';' num2str(k)];
                                    try
                                        theDir = makeTheDir(targetBaseDir,dirs(i).name(1:end-6),mDirs(j).name(1:end-6));
                                        try
                                            cleanBadFile(file,theDir,f);
                                        catch
                                            [targetBaseDir,dirs(i).name(1:end-6),mDirs(j).name(1:end-6) ' cleaning failed']
                                        end
                                        try
                                            getTheFiles(file,f,theDir);
                                        catch
                                            [targetBaseDir,dirs(i).name(1:end-6),mDirs(j).name(1:end-6) ' failed']
                                        end
                                    catch
                                    end
                                end
                            end
                            cd(f,'..');
                        catch
                        end
                    end
                    cd(f,'..');
                catch
                end
            end
        end
        close(f);
    end
    
    
    clear all;clc;
    
%     fileExtensions = {'rsq','isq','gobj','scv','aim','rad','txt','com'};%
%     
%     baseDir = 'd:';
%     system(['md ' baseDir]);
%     logFile = [baseDir '\' datestr(now,1) '-log.txt'];
%     diary(logFile);
%     targetBaseDir = [baseDir '\VivaCT'];
%     
%     %%do the uCT40
%     'Doing VivaCT40'
%     for outer = 1:length(fileExtensions)
%         fileExtensions{outer}
%         f = ftp('10.21.24.203','microct','mousebone4','System','OpenVMS');
%         if strcmpi(fileExtensions{outer},'txt') == 1 || strcmpi(fileExtensions{outer},'com') == 1
%             ascii(f);
%         else
%             binary(f);
%         end
%         cDir = cd(f,'dk0:[MICROCT.DATA]');
%         dirs = dir(f,'*.dir*');
%         for i = 1:length(dirs)
%             %         if str2num(dirs(i).name(1:8)) > 5000 || str2num(dirs(i).name(1:8)) < 2500
%             try
%                 cd(f,dirs(i).name(1:length(dirs(i).name)-6));
%                 mDirs = dir(f,'*.dir*');
%                 f
%                 for j = 1:length(mDirs)
%                     try
%                         clc
%                         cd(f,mDirs(j).name(1:length(mDirs(j).name)-6))
%                         files = dir(f,['*.' fileExtensions{outer} ';*'])
%                         if ~isempty(files)
%                             numFiles = str2num(files.name(end));
%                             for k = 1:numFiles
%                                 file = [files.name(1:end-2) ';' num2str(k)];
%                                 try
%                                     theDir = makeTheDir(targetBaseDir,dirs(i).name(1:end-6),mDirs(j).name(1:end-6));
%                                     try
%                                         cleanBadFile(file,theDir,f);
%                                     catch
%                                         [targetBaseDir,dirs(i).name(1:end-6),mDirs(j).name(1:end-6) ' cleaning failed']
%                                     end
%                                     try
%                                         getTheFiles(file,f,theDir);
%                                     catch
%                                         [targetBaseDir,dirs(i).name(1:end-6),mDirs(j).name(1:end-6) ' failed']
%                                     end
%                                 catch
%                                 end
%                             end
%                         end
%                         cd(f,'..');
%                     catch
%                     end
%                 end
%                 cd(f,'..');
%             catch
%             end
%             %         end
%         end
%         close(f);
%     end
    
end
