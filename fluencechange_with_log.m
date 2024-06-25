        time = sample.ElapsedTime;

        Dose_step = 6.25E9; % ions/cm2
        Dose_rate = sample.DoseRate;% counts/sec

        Flux = (Dose_step).*Dose_rate; %counts per second

        Fluence_vector = sample.Dose*6.25E9;
        Thickness_cm = 1e-8*Thickness;

        average_dpa_plot = ((Fluence_vector.*VacsPerIon)/(Thickness_cm*AlloyAtomDensity));

        figure(5)
        plot(Fluence_vector,average_dpa_plot,'b-','LineWidth',3)
        xlabel('Fluence [ions/cm2/s]','FontSize',18)
        ylabel('Displacements-per-Atom [dpa]','FontSize',18)
        grid on
        ax = gca;
        ax.FontSize = 18; 
        stringlegend = sprintf('Flux [ions/cm2/s] = %.2e',mean(Flux));
        legend(stringlegend,'Location','northwest')
        %legend("Flux = %d",Flux)

        figure(6)
        plot(time/60,average_dpa_plot,'m-','LineWidth',3)
        xlabel('Time [min]','FontSize',18)
        ylabel('Displacements-per-Atom [dpa]','FontSize',18)
        grid on
        ax = gca;
        ax.FontSize = 18; 
        stringlegend = sprintf('Flux [ions/cm2/s] = %.2e',mean(Flux));
        legend(stringlegend,'Location','northwest')

        figure(7)
        plot(time,average_dpa_plot,'r-','LineWidth',3)
        xlabel('Time [s]','FontSize',18)
        ylabel('Displacements-per-Atom [dpa]','FontSize',18)
        grid on
        ax = gca;
        ax.FontSize = 18; 
        stringlegend = sprintf('Flux [ions/cm2/s] = %.2e',mean(Flux));
        legend(stringlegend,'Location','northwest')