/* ============================================================
   1. Filtrer uniquement les vins de France
   ============================================================ */

data wine_france;
    set work.wine_clean;
    if upcase(country) = "FRANCE";
run;


/* ============================================================
   2. Compter le nombre de cépages (variety) par province
   ============================================================ */

proc freq data=wine_france noprint;
    tables province / out=work.count_province_fr;
run;


/* ============================================================
   3. Histogramme : X = province, Y = nombre de cépages
   ============================================================ */

proc sgplot data=work.count_province_fr;
    vbar province / response=count datalabel;
    xaxis label="Province (France)";
    yaxis label="Nombre de cépages (variety)";
    title "Nombre de cépages par province — France uniquement";
run;


/* ============================================================
   1. Filtrer uniquement les vins de France
   ============================================================ */

data wine_france;
    set work.wine_clean;
    if upcase(country) = "FRANCE";
run;


/* ============================================================
   2. Calcul des prix min et max par province
   ============================================================ */

proc means data=wine_france noprint;
    class province;
    var price_num;
    output out=stats_province_fr (drop=_type_ _freq_)
        min=min_price
        max=max_price;
run;


/* ============================================================
   3. Restructurer en format long pour barres groupées
   ============================================================ */

data stats_long;
    set stats_province_fr;
    /* Ligne pour prix minimum */
    metric = "Min"; 
    price = min_price; 
    output;

    /* Ligne pour prix maximum */
    metric = "Max"; 
    price = max_price; 
    output;
run;


/* ============================================================
   4. Histogramme groupé : bleu = min, rouge = max
   ============================================================ */

proc sgplot data=stats_long;
    vbar province /
        response=price
        group=metric
        datalabel
        groupdisplay=cluster   /* indispensable pour éviter la superposition */
        fillattrs=(color=steelblue)
        attrid=mycolors;

    /* Définition des couleurs */
    styleattrs datacolors=(steelblue darkred);

    xaxis label="Province (France)";
    yaxis label="Prix (min et max)";
    title "Prix minimum (bleu) et maximum (rouge) par province — France";
run;