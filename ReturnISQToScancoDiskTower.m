function ReturnISQToScancoDiskTower()

answer = inputdlg('Please select the sample number of interest');
sampleNumber = cell2mat(answer);

if length(answer{1}) == 3
    sampleNumber = ['00000' sampleNumber];
    f = ftp('10.21.24.203','microct','mousebone4','System','OpenVMS');
else
    sampleNumber = ['0000' sampleNumber];
    f = ftp('10.21.24.204','microct','mousebone4','System','OpenVMS');
end
cd(f,'dk0:');
cd(f,'data');

answer = inputdlg('Please enter the first measurement of interest');
startMeasurement = answer{1};
if length(answer{1}) ~= 5
    answer = inputdlg('Please enter the first measurement of interest, with five digits this time');
    startMeasurement = answer{1};
end
startMeasurement = ['000' startMeasurement];

answer = inputdlg('Please enter the last measurement of interest');
lastMeasurement = answer{1};
if length(answer{1}) ~= 5
    answer = inputdlg('Please enter the last measurement of interest, with five digits this time');
    lastMeasurement = answer{1};
end
lastMeasurement = ['000' lastMeasurement];

samp = str2num(sampleNumber);
st = str2num(startMeasurement);
lt = str2num(lastMeasurement);

template = importdata(fullfile(pwd,'IMPORT_FOREIGN_MEASUREMENT.COM'),'\t',6);
fileOut = fullfile(pwd,'microctcomfile.com');
fid = fopen(fileOut,'w');
if length(num2str(samp)) == 3
    localpath = 'd:\VivaCT\';
else
    localpath = 'd:\uCT40\';
end

for i = st:lt
    out = template;
    pth = fullfile(localpath,sampleNumber);
    zers = '00000000';
    pth = fullfile(pth,[zers(1:end-length(num2str(i))) num2str(i)]);
    isq = dir([pth '\*.isq']);
    if length(isq) > 0
        binary(f);
        mput(f,fullfile(pth,isq.name));
        strrep(out{1},'ISQFILENAME',fullfile(pth,isq.name));
        strrep(out{2},'SAMPLENUMBER',num2str(samp));
        for j = 1:length(out)
            fprintf(fileOut,'%s\n',out{j});
        end
        fclose(fileOut);
        ascii(f);
        mput(f,'microctcomfile.com');
        plinkPath = '"C:\Program Files\PuTTY\plink.exe" ';
        if length(num2str(samp)) == 4
            savedSession = 'uCT40 ';
        else
            savedSession = 'VivaCT40';
        end
        userName = 'microct ';
        password = 'mousebone4 ';
        remoteScratch = 'IDISK1:[MICROCT.SCRATCH]';
        sysLine = [plinkPath savedSession '-l ' userName '-pw ' password '@' remoteScratch 'microctcomfile.com'];
        system(sysLine);
    end
    
end

