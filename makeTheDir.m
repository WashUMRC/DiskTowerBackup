function [theDir] = makeTheDir(targetBaseDir,dir1,dir2)

    theDir = [targetBaseDir '\' dir1 '\' dir2];
    system(['md ' targetBaseDir '\' dir1 '\' dir2]);