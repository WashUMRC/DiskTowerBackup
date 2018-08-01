function ReturnISQToScancoDiskTower()

answer = inputdlg('Please select the sample number of interest');
sampleNumber = cell2mat(answer);

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

if length(answer{1}) == 3
    sampleNumber = ['00000' sampleNumber];
    f = ftp('10.21.24.203','microct','mousebone4','System','OpenVMS');
else
    sampleNumber = ['0000' sampleNumber];
    f = ftp('10.21.24.204','microct','mousebone4','System','OpenVMS');
end
cd(f,'dk0:');
cd(f,'data');



samp = str2num(sampleNumber);
st = str2num(startMeasurement);
lt = str2num(lastMeasurement);

template = importdata(fullfile(pwd,'IMPORT_FOREIGN_MEASUREMENT.COM'),'\t',7);
fileOut = fullfile(pwd,'microctcomfile.com');

if length(num2str(samp)) == 3
    localpath = 'd:\VivaCT\';
else
    localpath = 'd:\uCT40\';
end

for i = st:lt
    clc;
    i
    out = template;
    pth = fullfile(localpath,sampleNumber);
    pth = fullfile(pth,['000',num2str(i)]);
    isq = dir([pth '\*.isq*']);
    if length(isq) > 0
        fid = fopen(fileOut,'w');
        binary(f);
        mput(f,fullfile(pth,isq.name));
        out{1} = strrep(out{1},'ISQFILENAME',fullfile(pth,isq.name));
        out{2} = strrep(out{2},'SAMPLENUMBER',num2str(samp));
        out{1} = strrep(out{7},'ISQFILENAME',fullfile(pth,isq.name));
        
        for j = 1:length(out)
            fprintf(fid,'%s\n',out{j});
        end
        %     fclose(fileOut);
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

