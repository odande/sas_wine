/*===========================================================
= 0. Préparation des données
===========================================================*/
data wine_clean;
    set wine;
    variety_up  = upcase(variety);
    country_up  = upcase(country);
    taster_up   = upcase(taster_name);
    province_up = upcase(province);
run;

/*===========================================================
= 1. Filtrer le Pinot Noir aux USA (US)
===========================================================*/
data pinot_usa;
    set wine_clean;
    where variety_up = "PINOT NOIR"
      and country_up = "US";
run;

/* Vérification du volume */
proc sql;
    select count(*) as nb_pinot_usa
    from pinot_usa;
quit;

/*===========================================================
= 2. Influenceurs : taster_name
===========================================================*/
proc sql;
    create table taster_stats as
    select taster_name,
           count(*)     as n_wines,
           mean(points) as avg_points,
           mean(price)  as avg_price
    from pinot_usa
    where taster_name is not null
    group by taster_name;
quit;

/* Tri décroissant par note moyenne */
proc sort data=taster_stats out=taster_key;
    by descending avg_points;
run;

/* Graphique : influenceurs clés */
proc sgplot data=taster_key;
    vbar taster_name / response=avg_points datalabel;
    xaxis discreteorder=data label="Taster Name";
    yaxis label="Note moyenne";
    title "Influenceurs clés (taster_name) pour le Pinot Noir aux USA";
run;

/*===========================================================
= 3. Influenceurs géographiques : provinces (équivalent États)
===========================================================*/
proc sql;
    create table province_stats as
    select province,
           count(*)     as n_wines,
           mean(points) as avg_points,
           mean(price)  as avg_price
    from pinot_usa
    where province is not null
    group by province;
quit;

/* Tri par volume */
proc sort data=province_stats out=province_by_volume;
    by descending n_wines;
run;

proc sgplot data=province_by_volume;
    vbar province / response=n_wines datalabel;
    xaxis discreteorder=data label="Province";
    yaxis label="Nombre de vins";
    title "Provinces clés pour le Pinot Noir aux USA (volume)";
run;

/* Tri par qualité */
proc sort data=province_stats out=province_by_quality;
    by descending avg_points;
run;

proc sgplot data=province_by_quality;
    vbar province / response=avg_points datalabel;
    xaxis discreteorder=data label="Province";
    yaxis label="Note moyenne";
    title "Provinces à forte image qualitative";
run;

/*===========================================================
= 4. Influenceurs producteurs : wineries
===========================================================*/
proc sql;
    create table winery_stats as
    select winery,
           count(*)     as n_wines,
           mean(points) as avg_points,
           mean(price)  as avg_price
    from pinot_usa
    where winery is not null
    group by winery;
quit;

/* Tri par note moyenne */
proc sort data=winery_stats out=winery_key;
    by descending avg_points;
run;

proc sgplot data=winery_key;
    vbar winery / response=avg_points datalabel;
    xaxis discreteorder=data label="Winery";
    yaxis label="Note moyenne";
    title "Wineries influentes pour le Pinot Noir aux USA";
run;

/*===========================================================
= 5. Facteurs explicatifs : prix vs qualité
===========================================================*/
proc corr data=pinot_usa plots=matrix(histogram);
    var price points;
    title "Corrélation prix ↔ note (Pinot Noir USA)";
run;

proc reg data=pinot_usa;
    model price = points;
    title "Modèle explicatif du prix du Pinot Noir aux USA";
run;
quit;

/*===========================================================
= 6. Aide à la décision : profil du marché
===========================================================*/

/* Distribution des prix */
proc sgplot data=pinot_usa;
    histogram price / transparency=0.2;
    density price;
    title "Distribution des prix du Pinot Noir aux USA";
run;

/* Positionnement prix vs qualité */
proc sgplot data=pinot_usa;
    scatter x=points y=price / transparency=0.3;
    reg x=points y=price / degree=1;
    title "Relation prix ↔ note pour le Pinot Noir aux USA";
run;
