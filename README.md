# DiskTowerBackup

This set of scripts is intended to be run directly from the DiskTower computer. The main file to be run is copyScancoDataToDataTower; it will run continuously, checking for new files on the N drive (XRM data), uCT40, and VivaCT40. Ideally, it will skip already existing files and only grab new ones. Occasionally VMS messes up file reporting and it will re-copy some files, but that's no big deal really, just a little extra network traffic. 

mapNetworkDrives will automatically map ortho network drives if they aren't already. The username and password must be set with currently active credentials.

TODO: Add a file restore template
