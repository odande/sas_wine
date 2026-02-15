/* Affichage Top 10 Taster */
proc print data=taster_top10 label;
    title "Top 10 dégustateurs (influenceurs) Pinot Noir US";
run;

/* Affichage Top 10 Provinces */
proc print data=province_top10 label;
    title "Top 10 provinces Pinot Noir US";
run;

/* Affichage Top 10 Wineries */
proc print data=winery_top10 label;
    title "Top 10 producteurs Pinot Noir US";
run;