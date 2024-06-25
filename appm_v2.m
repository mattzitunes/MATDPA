function [appm  appm_dpa_rate] = appm_v2(average_dpa,vacancies,CountsPerSec,Thickness,AlloyAtomDensity,IonSymbol);

        Thickness_lamellae = 1000; %set appm to 100 nm for in situ TEM 

        Thickness_cm = 1e-8*Thickness_lamellae;

        time = 1:(3600*2-1)/100:3600;
        time = time';

        Dose_step = 6.25E9; % ions/cm2
        Dose_rate = CountsPerSec;% counts/sec

        Flux = (Dose_step)*Dose_rate; %counts per second

        Fluence = Flux.*time(length(time));

        Fluence_per_thickness = Fluence/Thickness_cm; %implanted ions/cm3
        
        appm = (((Fluence_per_thickness)./(AlloyAtomDensity))*1e6);
%         appm_noloss = (((Fluence_per_thickness)./(Fluence_per_thickness+AlloyAtomDensity))*1e6);

%         figure(4)
%         plot(time/60,appm,'m--','LineWidth',3)
%         xlabel('Time [min]','FontSize',18)
%         ylabel(['appm of ',IonSymbol])
%         grid on
%         ax = gca;
%         ax.FontSize = 18; 
%         hold on
%         
%         figure(4)
%         plot(time/60,appm_noloss,'m-','LineWidth',3)
%         legend('With losses','No losses')

       
        appm_dpa_rate = appm/max(average_dpa);
             
        fprintf('The calculated %s appm per dpa is (assuming 100 nm thick lamellae): %.2e \n',IonSymbol,appm_dpa_rate)
        
    