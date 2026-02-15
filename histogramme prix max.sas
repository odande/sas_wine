/* 1. Compter les pays et les trier par fréquence */
proc sql;
    create table country_counts as
    select country,
           count(*) as n
    from wine
    group by country
    order by n desc;
quit;

/* 2. Garder uniquement les 10 premiers pays */
data top10_countries;
    set country_counts;
    if _N_ <= 10;
run;

proc sql;
    create table wine_top10 as
    select w.*
    from wine w
    inner join top10_countries t
        on w.country = t.country;
quit;

/* 1. Calcul du prix maximum par pays */
proc sql;
    create table max_price_country as
    select country,
           max(price) as max_price
    from wine
    group by country;
quit;

/* 1. Calcul du prix maximum par pays */
proc sql;
    create table max_price_country as
    select country,
           max(price) as max_price
    from wine
    group by country;
quit;

/* 2. Tri décroissant sur le prix maximum */
proc sort data=max_price_country;
    by descending max_price;
run;

/* 3. Graphique horizontal trié correctement */
proc sgplot data=max_price_country;
    hbar country / response=max_price datalabel;
    xaxis label="Prix maximum" min=0 max=1000;
    yaxis label="Pays" discreteorder=data;   /* <-- clé pour garder l'ordre décroissant */
    title "Prix maximum par pays (tri décroissant, échelle 0 à 1000)";
run;

/* 1. Calcul de la somme des prix par taster_name */
proc sql;
    create table sum_price_taster as
    select taster_name,
           sum(price) as total_price
    from wine
    where taster_name is not null
    group by taster_name;
quit;

/* 2. Tri décroissant sur la somme des prix */
proc sort data=sum_price_taster;
    by descending total_price;
run;

/* 3. Affichage du résultat */
proc print data=sum_price_taster label;
    label taster_name = "Dégustateur"
          total_price = "Somme des prix";
    title "Somme des prix par taster_name (ordre décroissant)";
run;

//* 1. Calcul de la somme des prix par taster_name */
proc sql;
    create table sum_price_taster as
    select taster_name,
           sum(price) as total_price
    from wine
    where taster_name is not null
    group by taster_name;
quit;

/* 2. Tri décroissant */
proc sort data=sum_price_taster;
    by descending total_price;
run;

/* 3. Histogramme vertical (VBAR) avec taster_name en X */
proc sgplot data=sum_price_taster;
    vbar taster_name / response=total_price datalabel;
    xaxis discreteorder=data label="Taster Name";
    yaxis label="Somme des prix";
    title "Somme des prix par taster_name (ordre décroissant)";
run;











