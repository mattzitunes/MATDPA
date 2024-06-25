function ionizprofile = ionizprofile(ioniz,phonons)
    kkk=1;
    figure(5)
    plot(ioniz(:,1),ioniz(:,2)+ioniz(:,3),'m-','LineWidth',2)
    xlabel('Depth [Angstrom]','FontSize',18)
    ylabel('Energy Loss [eV/Angstrom/ion]','FontSize',18)
    grid on
    ax = gca;
    hold on
    plot(ioniz(:,1),phonons(:,2)+phonons(:,3),'c-','LineWidth',2)
    ax.FontSize = 18; 
    legend('Electronic Energy Deposition','Nuclear Energy Deposition')

    Depth = ioniz(:,1);
    IonizationProfile = ioniz(:,2)+ioniz(:,3);
    NuclearProfile = phonons(:,2)+phonons(:,3);
    T = table(Depth, IonizationProfile, NuclearProfile, 'VariableNames',{'Depth [A]','Electronic Energy Deposition [ev/A/Ion]','Nuclear Energy Deposition [ev/A/Ion]'});
    writetable(T, 'Figure5_Data_EnergyDeposition.txt','Delimiter','tab');

end