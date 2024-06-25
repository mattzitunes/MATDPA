function rangeprofile = range_profile(depth,range,Thickness,AlloyAtomDensity,CountsPerSec,time)
        
    Dose_step = 6.25E9; % ions/cm2
    Dose_rate = CountsPerSec;% counts/sec

    Flux = (Dose_step)*Dose_rate; %counts per second
    Fluence = Flux.*time(length(time)) 
    Thickness_cm = 1e-8*Thickness;

    Implanted_Atoms = (range.*Fluence/AlloyAtomDensity)*100;
    
    figure(2)
    plot(depth,Implanted_Atoms,'+-','LineWidth',2)
    xlabel('Depth [Angstrom]','FontSize',18)
    ylabel('Implanted Ions [at.%]','FontSize',18)
    grid on
    hold on
    ax = gca;
    ax.FontSize = 18; 


        T = table(depth, Implanted_Atoms, 'VariableNames',{'Depth [A]','Implanted Ions [at.%]'});
        writetable(T, 'Figure2_Data_TimevsAverageDPA.txt','Delimiter','tab');