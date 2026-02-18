proc sgplot data=work.wine_clean;

    /* Boxplot horizontal : prix en X, pays en Y */
    hbox price_num / 
        category=country 
        group=country;

    /* Palette de couleurs variées pour les pays */
    styleattrs datacolors=(
        cx1f77b4 cxff7f0e cx2ca02c cxd62728 cx9467bd
        cx8c564b cxe377c2 c7f7f7f cxbcbd22 cx17becf
    );

    /* Échelle du prix entre 0 et 100 */
    xaxis label="Prix (price_num)" 
          values=(0 to 100 by 10);

    yaxis label="Pays (country)";

    title "Boîte à moustaches des prix par pays (échelle 0–100)";
run;