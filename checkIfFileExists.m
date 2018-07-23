function [tf] = checkIfFileExists(fileName,theDir,f)
%%info to see if file is on disk
tf = 0;

file = fullfile(theDir,fileName);
if exist(file) == 2
    info = dir(file);
    infof = dir(f,fileName);
    if info.isDir == 0
        try
            tf = info.bytes == infof.bytes;
        catch
        end
    else
        tf = 0;
    end
else
end
            


%%info from ftp