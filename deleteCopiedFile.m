function deleteCopiedFile(theDir)
    system(['del /s ' [theDir '\*.* /F /Q']]);