/* 1) Afficher les top 10 influenceurs (taster, province, winery)
/* Top 10 taster */
proc print data=taster_top10 label;
    label taster_name = "Dégustateur"
          n_wines     = "Nb vins"
          avg_points  = "Note moyenne"
          avg_price   = "Prix moyen";
    title "Top 10 dégustateurs (influenceurs) Pinot Noir US";
run;

/* Top 10 provinces */
proc print data=province_top10 label;
    label province   = "Province"
          n_wines    = "Nb vins"
          avg_points = "Note moyenne"
          avg_price  = "Prix moyen";
    title "Top 10 provinces Pinot Noir US";
run;

/* Top 10 wineries */
proc print data=winery_top10 label;
    label winery    = "Winery"
          n_wines   = "Nb vins"
          avg_points= "Note moyenne"
          avg_price = "Prix moyen";
    title "Top 10 producteurs Pinot Noir US";
run;



2) Analyse marketing synthétique (marché Pinot US)
proc means data=pinot_usa n mean std min p25 median p75 max;
    var price points;
    title "Profil global du marché Pinot Noir US";
run;

proc sgplot data=pinot_usa;
    histogram price / transparency=0.2;
    density price;
    title "Distribution des prix Pinot Noir US";
run;

proc sgplot data=pinot_usa;
    scatter x=points y=price / transparency=0.3;
    reg x=points y=price;
    title "Relation prix ↔ note Pinot Noir US";
run;



3) Rapport final PDF
ods pdf file="C:\temp\rapport_pinot_us.pdf" style=journal;

title "Profil global du marché Pinot Noir US";
proc means data=pinot_usa n mean std min p25 median p75 max;
    var price points;
run;

title "Top 10 dégustateurs (influenceurs)";
proc print data=taster_top10 label; run;

title "Top 10 provinces";
proc print data=province_top10 label; run;

title "Top 10 producteurs (wineries)";
proc print data=winery_top10 label; run;

title "Distribution des prix";
proc sgplot data=pinot_usa;
    histogram price / transparency=0.2;
    density price;
run;

title "Prix vs note";
proc sgplot data=pinot_usa;
    scatter x=points y=price / transparency=0.3;
    reg x=points y=price;
run;

ods pdf close;



4) Mini dashboard HTML
ods html path="C:\temp" file="dashboard_pinot_us.html" style=htmlblue;

title "Profil global du marché Pinot Noir US";
proc means data=pinot_usa n mean std min p25 median p75 max;
    var price points;
run;

title "Top 10 dégustateurs";
proc sgplot data=taster_top10;
    vbar taster_name / response=n_wines datalabel;
    xaxis discreteorder=data label="Taster";
    yaxis label="Nb vins";
run;

title "Top 10 provinces";
proc sgplot data=province_top10;
    vbar province / response=n_wines datalabel;
    xaxis discreteorder=data label="Province";
    yaxis label="Nb vins";
run;

title "Prix vs note";
proc sgplot data=pinot_usa;
    scatter x=points y=price / transparency=0.3;
    reg x=points y=price;
run;

ods html close;


Si tu veux, au prochain tour on peut interpréter ensemble ce que ces sorties racontent sur ta décision de vendre du Pinot Noir aux US.
 */
/* Top 10 taster */
proc print data=taster_top10 label;
    label taster_name = "Dégustateur"
          n_wines     = "Nb vins"
          avg_points  = "Note moyenne"
          avg_price   = "Prix moyen";
    title "Top 10 dégustateurs (influenceurs) Pinot Noir US";
run;

/* Top 10 provinces */
proc print data=province_top10 label;
    label province   = "Province"
          n_wines    = "Nb vins"
          avg_points = "Note moyenne"
          avg_price  = "Prix moyen";
    title "Top 10 provinces Pinot Noir US";
run;

/* Top 10 wineries */
proc print data=winery_top10 label;
    label winery    = "Winery"
          n_wines   = "Nb vins"
          avg_points= "Note moyenne"
          avg_price = "Prix moyen";
    title "Top 10 producteurs Pinot Noir US";
run;


/* 2) Analyse marketing synthétique (marché Pinot US) */
proc means data=pinot_usa n mean std min p25 median p75 max;
    var price points;
    title "Profil global du marché Pinot Noir US";
run;

proc sgplot data=pinot_usa;
    histogram price / transparency=0.2;
    density price;
    title "Distribution des prix Pinot Noir US";
run;

proc sgplot data=pinot_usa;
    scatter x=points y=price / transparency=0.3;
    reg x=points y=price;
    title "Relation prix ↔ note Pinot Noir US";
run;


/* 3) Rapport final PDF */
ods pdf file="C:\Users\olivi\rapport_pinot_us.pdf" style=journal;

title "Profil global du marché Pinot Noir US";
proc means data=pinot_usa n mean std min p25 median p75 max;
    var price points;
run;

title "Top 10 dégustateurs (influenceurs)";
proc print data=taster_top10 label; run;

title "Top 10 provinces";
proc print data=province_top10 label; run;

title "Top 10 producteurs (wineries)";
proc print data=winery_top10 label; run;

title "Distribution des prix";
proc sgplot data=pinot_usa;
    histogram price / transparency=0.2;
    density price;
run;

title "Prix vs note";
proc sgplot data=pinot_usa;
    scatter x=points y=price / transparency=0.3;
    reg x=points y=price;
run;

ods pdf close;