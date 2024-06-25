function dpaprofile = dpa_profile(vacancies,VacPerIonA,CountsPerSec,Thickness,AlloyAtomDensity)
        
    time = 1:(3600*2-1)/100:3600;
    time = time';

    Dose_step = 6.25E9; % ions/cm2
    Dose_rate = CountsPerSec;% counts/sec

    Flux = (Dose_step)*Dose_rate; %counts per second

    Fluence = Flux.*time(length(time));
    
    Depth = vacancies(:,1);
    vacancies_sum = vacancies(:,2)+vacancies(:,3);
    
    dpaprofile = (vacancies_sum.*Fluence)/(1e-8*AlloyAtomDensity);
    dpaprofile(length(Depth),1) = dpaprofile(length(Depth)-1,1);
    sum(dpaprofile);
    
    figure(3)
    plot(Depth,dpaprofile,'k-')
    xlabel('Depth [Angstrom]','FontSize',18)
    ylabel('Displacements-per-Atom [dpa]','FontSize',18)
    grid on
    ax = gca;
    ax.FontSize = 18; 