@ECHO OFF
SETLOCAL

SET _source="N:\XRMData"

SET _dest="D:\XRM\XRMDATA"

SET _what=/e
:: /COPYALL :: COPY ALL file info
:: /B :: copy files in Backup mode.
:: /SEC :: copy files with SECurity
:: /e :: copy subdirectories

ROBOCOPY %_source% %_dest% %_what% 