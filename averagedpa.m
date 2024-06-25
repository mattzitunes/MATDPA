function average_dpa = averagedpa(VacsPerIon,CountsPerSec,Thickness,AlloyAtomDensity,Alloy,time)
    % define time 1h = 3600 s
%     time = 1:(3600*2-1)/100:3600;
%     %time = 16*time';
%     time = 9; % in seconds
    
    Dose_step = 6.25E9; % ions/cm2
    Dose_rate = CountsPerSec;% counts/sec

    Flux = (Dose_step)*Dose_rate; %counts per second
    Fluence = Flux.*time(length(time)) 
    Thickness_cm = 1e-8*Thickness;

    average_dpa = ((Fluence*VacsPerIon)/(Thickness_cm*AlloyAtomDensity));

%     figure(1)
%     plot(Fluence,average_dpa,'r.','MarkerSize',10)
%     xlabel('Fluence [ions/cm2]','FontSize',18)
%     ylabel('Displacements-per-Atom [dpa]','FontSize',18)
%     grid on
%     ax = gca;
%     ax.FontSize = 18; 
%     
%     figure(2)
%     plot((time/60),average_dpa,'b.','MarkerSize',10)
%     xlabel('Time [min]','FontSize',18)
%     ylabel('Displacements-per-Atom [dpa]','FontSize',18)
%     grid on
%     ax = gca;
%     ax.FontSize = 18; 
    
    fprintf('The average dose for the ')
    
    for i=1:length(Alloy(:,1))
        fprintf('%s-%.1f ',Alloy(i,1),str2num(Alloy(i,2)))
    end
    
    fprintf('alloy for a fluence of %.2e of irradiation is: %.3f dpa. \n',Fluence,max(average_dpa))
