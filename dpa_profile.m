function dpaprofile = dpa_profile(vacancies,VacPerIonA,CountsPerSec,Thickness,AlloyAtomDensity,time)
        
%     time = 1:(3600*2-1)/100:3600;
%     %time = time';
%     time = 9; %seconds

    Dose_step = 6.25E9; % ions/cm2
    Dose_rate = CountsPerSec;% counts/sec

    Flux = (Dose_step)*Dose_rate; %counts per second

    Fluence = Flux.*time(length(time));
    
    Depth = vacancies(:,1);
    vacancies_sum = vacancies(:,2)+vacancies(:,3);
    
    dpaprofile = (vacancies_sum.*Fluence)/(1e-8*AlloyAtomDensity);
    dpaprofile(length(Depth),1) = dpaprofile(length(Depth)-1,1);
    sum(dpaprofile);
    
    figure(1)
    plot(Depth,dpaprofile,'-','LineWidth',2)
    xlabel('Depth [Angstrom]','FontSize',18)
    ylabel('Irradiation Dose [dpa]','FontSize',18)
    grid on
    ax = gca;
    hold on
    ax.FontSize = 18; 


    T = table(Depth, dpaprofile, 'VariableNames',{'Depth [A]','dpa'});
    writetable(T, 'Figure1_Data_DPAProfile_SRIM.txt','Delimiter','tab');
