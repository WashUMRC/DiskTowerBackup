function cleanBadFile(fileName,theDir,f)

file = fullfile(theDir,fileName);
existVal = exist(file);
switch(existVal)
    case 0
        return
    case 2
       %means it's there
       info = dir(file);
       infof = dir(f,fileName);
       tf = info.bytes == infof.bytes;
       if tf == 1
       else
           delete(file);
       end
    case 7
        try
            rmdir(file);
        catch
            ['unable to remove folder']
            return
        end
end
       
       