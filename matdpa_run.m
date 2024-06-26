%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Montanuniversität Leoben             %
%  MATDPA - The DPA calculator          %
%                                       %
%  By Matheus A. Tunes, PhD             %
%  Problems? m.a.tunes@physics.org      %
%  Version Ver_Jul2024                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

diary lastrunLog.txt
tic
clc;clear;
%Load Libraries
load('Libraries/chemistry.mat')

%Initial Message
disp('%%%%% Montanuniversität Leoben - 2024 %%%%%') 
disp('%%%%% The DPA Calculator %%%%%')
disp('Lets set-up the Ion Data!')

% Ion Data
prompt = 'What is the ion element you want? (Type the element symbol):   ';
IonSymbol = input(prompt,'s');
IonZ = find(contains(chemistry.Symbol,IonSymbol));

if length(IonZ) == 1
    IonZ = IonZ;
else
    IonZ = find(chemistry.Symbol(IonZ) == IonSymbol);
end


prompt = 'What is the ion energy? [keV]:    ';
IonEnergy = input(prompt);

prompt = 'What is the incidence angle in degrees? [0 deg = normal incidence]:    ';
IonAngle = input(prompt);

prompt = 'What is the total number of ions for the calculation:    ';
IonTotal = input(prompt);

%prompt = 'What is the mode of calculation: (Type 1 = Quick Damage, 2 = Full Cascades):    ';
IonMode = 1;
% while(IonMode ~= 1 && IonMode ~= 2)   
%     IonMode = input(prompt);
% end

% ask thickness of the layer
prompt = 'What is the thickness of the layer [Angstroms]:   ';
Thickness = input(prompt);

A{1}  = sprintf('==> SRIM-2013.00 This file controls TRIM Calculations.');
A{2}  = sprintf('Ion: Z1 ,  M1,  Energy (keV), Angle,Number,Bragg Corr,AutoSave Number.');
A{3}  = sprintf('%d        %d      %d 	%d   %d    1    10000',IonZ,chemistry.A(IonZ),IonEnergy,IonAngle,IonTotal);
A{4}  = sprintf('Cascades(1=No;2=Full;3=Sputt;4-5=Ions;6-7=Neutrons), Random Number Seed, Reminders');
A{5}  = sprintf('                      %d                                   0       0',IonMode);
A{6}  = sprintf('Diskfiles (0=no,1=yes): Ranges, Backscatt, Transmit, Sputtered, Collisions(1=Ion;2=Ion+Recoils), Special EXYZ.txt file');
A{7}  = sprintf('                          0       0           0       0               2                               0');
A{8}  = sprintf('Target material : Number of Elements & Layers');

% Setting up the target
prompt = 'How many elements your alloy has?:   ';
AlloyElements = input(prompt);

A{9}  = sprintf(' "Osman El-Atwani LANL Group MATDPA          "       %d               1',AlloyElements);
A{10} = sprintf('PlotType (0-5); Plot Depths: Xmin, Xmax(Ang.) [=0 0 for Viewing Full Target]');
A{11} = sprintf('       5                         0            0');
A{12} = sprintf('Target Elements:    Z   Mass(amu)');

% Alloy array = first column is element symbol and second stoichiometry
Alloy = strings(AlloyElements,5);
str15 = "Layer   Layer Name /               Width Density    ";
NumberOfLines = length(A) + 1;
k=1;
kk = 0;
while(k ~= AlloyElements + 1)
    
    prompt = 'Type the element symbol:   ';
    Alloy(k,1) = input(prompt,'s');
        
    prompt = 'Type the element atomic percentage [at.%]:    ';
    Alloy(k,2) = input(prompt);
    
    %Allocate alloy Z number into column 3
    positionZ = find(contains(chemistry.Symbol,Alloy(k,1)));
    
        if strlength(chemistry.Symbol(positionZ,1)) == 2
           Alloy(k,3) = positionZ;
        else
            for ii = 1:length(positionZ)
                test = strlength(chemistry.Symbol(positionZ(ii),1));
                if test == 1
                Alloy(k,3) = positionZ(ii);
                 break
                end
            end
        end
    
    %Allocate alloy A number into column 4
    Alloy(k,4) = chemistry.A(str2num(Alloy(k,3)));
    
    prompt = 'Type the element Displacement Energy [eV, type zero for SRIM values]:    ';
    Alloy(k,5) = input(prompt);
    if str2num(Alloy(k,5)) == 0
        Alloy(k,5) = table2array(chemistry(str2num(Alloy(k,3)),7));
    end
    
    %strcat(Alloy(1,1),"(",Alloy(1,3), ")")
    Alloy(k,6) = strcat(Alloy(k,1),'(',Alloy(k,3), ')',"     ");
    
    Densities(k,1) = chemistry.Density(str2num(Alloy(k,3)));
    Densities(k,2) = Alloy(k,2);
    
    % build line 15
    str15 = strcat(str15,Alloy(k,6));
    
    % build elements lines
    str_elements = strcat("Atom ",num2str(k)," = ",Alloy(k,1)," =       ",Alloy(k,3),"  ",Alloy(k,4));
    A{NumberOfLines+kk} = sprintf('%s',str_elements);

    kk = kk + 1;
    k = k + 1;
end

% build new file
A{NumberOfLines+kk} = sprintf('%s',str15);

prompt = 'What is your alloy density? [g/cm3]: (Type 0 for SRIM weight average density)   ';
AlloyDensity = input(prompt);   
if AlloyDensity == 0
    AlloyDensity = sum(Densities(:,1).*Densities(:,2)/100);
end

% build line stoich and start the layer
lineStoich = "Numb.   Description                (Ang) (g/cm3)    ";
Stoich(1:AlloyElements,1) = "Stoich   ";
for i=1:AlloyElements
    lineStoich = strcat(lineStoich,Stoich(i,1));
end
A{NumberOfLines+kk+1} = sprintf('%s',lineStoich);

%build layer
Layer = strcat('1      "LANL Target Material"',"       ",num2str(Thickness),"  ",num2str(AlloyDensity));
for i=1:AlloyElements
    Layer = strcat(Layer,"      ",num2str(Alloy(i,2)));
end
A{NumberOfLines+kk+2} = sprintf('%s',Layer);
A{NumberOfLines+kk+3} = sprintf('0  Target layer phases (0=Solid, 1=Gas)');
A{NumberOfLines+kk+4} = sprintf('0');
A{NumberOfLines+kk+5} = sprintf('Target Compound Corrections (Bragg)');
A{NumberOfLines+kk+6} = sprintf('1');

%place displacement energies
A{NumberOfLines+kk+7} = sprintf('Individual target atom displacement energies (eV)');
IndividualEd = strings(1);
IndividualEd_latt = strings(1);
IndividualEd_surf = strings(1);
for i=1:AlloyElements
    IndividualEd = strcat("  ",IndividualEd,Alloy(i,5),"       ");
    IndividualEd_latt = strcat(IndividualEd_latt,"       0.0001");
    IndividualEd_surf = strcat(IndividualEd_surf,"       0.0001");
end
A{NumberOfLines+kk+8} = sprintf('%s',IndividualEd);
A{NumberOfLines+kk+9} = sprintf('Individual target atom lattice binding energies (eV)');
A{NumberOfLines+kk+10} = sprintf('%s',IndividualEd_latt);
A{NumberOfLines+kk+11} = sprintf('Individual target atom surface binding energies (eV)');
A{NumberOfLines+kk+12} = sprintf('%s',IndividualEd_surf);
A{NumberOfLines+kk+13} = sprintf('Stopping Power Version (1=2011, 0=2011)');
A{NumberOfLines+kk+14} = sprintf('0');

% Write cell A into txtA
%write up to line 12 into TRIM.IN
fid = fopen('TRIM.IN','wt+');
    for i = 1:numel(A)
             fprintf(fid,'%s\n', A{i});
        
    end
fclose(fid);
disp('File TRIM.IN created with success!!!') 

%phase 02 running SRIM...
fname = 'TRIM.IN'
system(['TRIM.exe < ' fname]); %run executable with content of fname as inputs

%importing_vacancies_data_from_files.txt
%folder = 'SRIM Outputs/';
ss(k) = importdata('VACANCY.txt');
sss(k) = importdata('IONIZ.txt');
ssss(k) = importdata('RANGE.txt');
sssss(k) = importdata('PHONON.txt');

%extract atom density
AlloyAtomDensity = strsplit(char(ss(2+AlloyElements-1).textdata(17)),'=');
AlloyAtomDensity = erase(AlloyAtomDensity(2),"atoms/cm3");
AlloyAtomDensity = strtrim(AlloyAtomDensity);
AlloyAtomDensity = str2double(AlloyAtomDensity);

%extract transmitted ions and backscattered ions
% IonsTransAndBack = strsplit(char(ssss(2+AlloyElements-1).textdata(21+AlloyElements-1)),';');
% IonsTrans = erase(IonsTransAndBack(1)," Transmitted Ions =");
% IonsBack = erase(IonsTransAndBack(2),"  Backscattered Ions =");
% IonsTrans = str2double(strtrim(IonsTrans));
% if isnan(IonsTrans) == 1
%     IonsTrans = 0;
% end
% IonsBack = str2double(strtrim(IonsBack));
% IonsNet = (IonTotal-IonsTrans)/IonTotal;
%calculate total number of vacancies per ion

%%
vacancies = ss(2+AlloyElements-1).data;
[VacsPerIon VacPerIonA] = integralmatt(vacancies(:,1),(vacancies(:,2)+(vacancies(:,3))));

phonons = sssss(2+AlloyElements-1).data;
[PhononsPerIon PhoPerIonA] = integralmatt(phonons(:,1),(phonons(:,2)+(phonons(:,3))));

ioniz = sss(2+AlloyElements-1).data;
[IonizationPerIon IonizPerIonA] = integralmatt(ioniz(:,1),(ioniz(:,2)+(ioniz(:,3))));


Vnrt = (0.8*PhononsPerIon)/(2*str2num(Alloy(1,5)));

% StollerRatio
% If closer to 1  : then phonon calculations are negligible.
% If higher than 1: vNRT lower than SRIM which overestimates DPA.
% If lower than 1 : vNRT higher than SRIM which underestimates DPA.

StollersRatio = VacsPerIon/Vnrt; 
% prompt = 'Type the flux of your accelerator [ions/cm2/s in XXEXX format]:    ';
% Flux = input(prompt);
%%
%CountsPerSec = 1;
kk = 1;

%while CountsPerSec ~= 0
        %kk = kk + 1;
        %prompt = 'Type the dose rate [in cts] (if zero execution will stop`):    ';
        prompt = 'Type the dose rate [in cts, 1 cts = 6.25E9 ions/cm2/s]:    ';
        CountsPerSec = input(prompt);

        %if CountsPerSec == 0
            %break
        %end
        
        prompt = 'Type the irradiation time: [min]:    ';
        time = input(prompt); % seconds
        time = time*60;
        % order of figures
        % 
        % figure(1) DPA vs Depth
        % figure(2) Implantation vs Depth
        % figure(3) DPA vs Fluence
        % figure(4) DPA vs Time [min]
        
        % FIRST FIRST
        % calculates average dpa in the whole thickness
        average_dpa = averagedpa(VacsPerIon,CountsPerSec,Thickness,AlloyAtomDensity,Alloy,time);
        
        % SECOND SECOND
        % calculates the dpa profile in the whole thickness
        dpaprofile = dpa_profile(vacancies,VacPerIonA,CountsPerSec,Thickness,AlloyAtomDensity,time);
        dpa_profileVNRT(phonons,PhoPerIonA,CountsPerSec,Thickness,AlloyAtomDensity,time);
        
        %THIRD THIRD
        % calculates the appm per time
        [appm appm_dpa_rate] = appm_v2(average_dpa,vacancies,CountsPerSec,Thickness,AlloyAtomDensity,IonSymbol);
        [Flux  stringlegend] = fluencechange(CountsPerSec,Thickness,VacsPerIon,AlloyAtomDensity,time,kk,average_dpa);
        legendArray(kk,1) = string(stringlegend); %built legend array

        % plots implantation range
        implantation_yield = ssss(2+AlloyElements-1).data;
        range_profile(implantation_yield(:,1),implantation_yield(:,2),Thickness,AlloyAtomDensity,CountsPerSec,time);
%end

figure(1)
legend(legendArray,'Location','southeast')
figure(4)
legend(legendArray,'Location','southeast')

ionizprofile(ioniz,phonons)
EnergyLoss_TotalIntegration = ((PhononsPerIon+IonizationPerIon)/1e3/IonEnergy)

%save workspace .mat file
name = '';
for i=1:length(Alloy(:,1))
    name = strcat(Alloy(i,2),Alloy(i,1)) + name;
end
filename = strcat(num2str(IonZ),IonSymbol,num2str(IonEnergy),'keV','at',num2str(IonAngle),'deg','into',name)
save(filename)

toc
diary off
