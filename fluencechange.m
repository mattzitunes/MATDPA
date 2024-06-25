function [Flux  stringlegend] = fluencechange(CountsPerSec,Thickness,VacsPerIon,AlloyAtomDensity,time,kk,average_dpa)

        time2 = 1:1:time;
        time = time2';
%       time = time';
%       time = 4*time;

        Dose_step = 6.25E9; % ions/cm2
        Dose_rate = CountsPerSec;% counts/sec

        Flux = (Dose_step)*Dose_rate; %counts per second

        Fluence_vector = Flux.*time;
        Thickness_cm = 1e-8*Thickness;

        average_dpa_plot = ((Fluence_vector.*VacsPerIon)/(Thickness_cm*AlloyAtomDensity));

        figure(3)
        plot(Fluence_vector,average_dpa_plot,'o-','LineWidth',3)
        xlabel('Fluence [ions/cm2/s]','FontSize',18)
        ylabel('Average Irradiation Dose [dpa]','FontSize',18)
        hold on
        grid on
        ax = gca;
        ax.FontSize = 18; 
        title('Plot for Maximum Dose Rate','FontSize',12)

        T = table(Fluence_vector, average_dpa_plot, 'VariableNames',{'Fluence [ions/cm2]','Average dpa'});
        writetable(T, 'Figure3_Data_FluencevsAverageDPA.txt','Delimiter','tab');

        %legend(legendArray,'Location','northwest')
        %legend("Flux = %d",Flux)

        figure(4)
        plot(time/60,average_dpa_plot,'o-','LineWidth',3)
        xlabel('Time [min]','FontSize',18)
        ylabel('Average Irradiation Dose [dpa]','FontSize',18)
        grid on
        hold on
        ax = gca;
        ax.FontSize = 18; 
        %stringlegend = strcat(num2str(Flux,'%.2e'));
        stringlegend = strcat(num2str(Flux,'%.2e')," | ",num2str(average_dpa./max(time),'%.3f'), ' dpa\cdots^{-1}', " | ",num2str(max(time/60),'%d'),' min');  
       
        T = table(time/60, average_dpa_plot, 'VariableNames',{'Time [min]','Average dpa'});
        writetable(T, 'Figure4_Data_TimevsAverageDPA.txt','Delimiter','tab');
%         figure(4)
%         plot(time,average_dpa_plot,'r-','LineWidth',3)
%         xlabel('Time [s]','FontSize',18)
%         ylabel('Displacements-per-Atom [dpa]','FontSize,',18)
%         grid on
%         ax = gca;
%         ax.FontSize = 18; 
%         stringlegend = sprintf('Flux [ions/cm2/s] = %.2e',Flux);
%         legend(stringlegend,'Location','northwest')

        final_dpa(:,1) = time;
        final_dpa(:,2) = Fluence_vector;
        final_dpa(:,3) = average_dpa_plot;
end