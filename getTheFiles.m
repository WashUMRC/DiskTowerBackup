function getTheFiles(file,f,theDir)

try
    mget(f,file,theDir);
    [file ' has been copied over']
catch
    [file ' copy failed']
end 