/* ---------------------------------------------------------------------------
   Bundle derived from: histogramme prix max.sas
   The upstream script reads the `wine` dataset (imported from wine.csv). A
   small representative sample of wine.csv is inlined below as `wine`; the
   PROC SQL / PROC SORT / PROC PRINT logic that follows is the repo's own
   (top countries, max price per country, price sum per taster).
   --------------------------------------------------------------------------- */
data wine;
    length country $12 province $20 taster_name $20 variety $22 winery $28;
    input country $ points price province $ taster_name $ variety $ winery $;
    price_num = price;
    datalines;
US 87 44 Oregon Paul_Gregutt Pinot_Noir Sweet_Cheeks
US 87 51 California Virginie_Boone Pinot_Noir Castello_di_Amorosa
US 86 41 Oregon Paul_Gregutt Pinot_Noir Erath
US 86 18 Oregon Paul_Gregutt Pinot_Noir ZIVO
US 91 47 California Matt_Kettmann Pinot_Noir Testarossa
US 91 46 California Matt_Kettmann Pinot_Noir Albatross_Ridge
US 91 35 California Virginie_Boone Pinot_Noir Dutton_Goldfield
US 85 33 Oregon Paul_Gregutt Pinot_Noir Silvan_Ridge
US 85 48 Oregon Paul_Gregutt Pinot_Noir Amity
US 85 28 Oregon Paul_Gregutt Pinot_Noir Cherry_Hill
US 89 53 California Virginie_Boone Pinot_Noir Esterlina
US 89 43 Oregon Paul_Gregutt Pinot_Noir Willamette_Valley
US 87 18 Michigan Alexander_Peartree Riesling St_Julian
France 87 25 Alsace Roger_Voss Pinot_Gris Jean_Baptiste_Adam
France 86 15 Beaujolais Roger_Voss Gamay Henry_Fessy
France 86 18 Beaujolais Roger_Voss Gamay Vignerons_Bel_Air
France 85 17 Bordeaux Roger_Voss White_Blend Chateau_de_Sours
France 86 91 Champagne Roger_Voss Champagne_Blend Roland_Champion
France 86 87 Champagne Roger_Voss Champagne_Blend Collet
France 87 19 Beaujolais Roger_Voss Gamay Pardon_et_Fils
Spain 87 20 Northern_Spain Michael_Schachner Tempranillo Tandem
Italy 87 19 Sicily Kerin_OKeefe Frappato Terre_di_Giurfo
Argentina 87 31 Other Michael_Schachner Malbec Felix_Lavaque
Argentina 87 19 Mendoza Michael_Schachner Malbec Gaucho_Andino
Spain 87 29 Northern_Spain Michael_Schachner Tempranillo Pradorey
Italy 87 27 Sicily Kerin_OKeefe White_Blend Baglio_di_Pianetto
;
run;

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

/* Calcul du prix maximum par pays */
proc sql;
    create table max_price_country as
    select country,
           max(price) as max_price
    from wine
    group by country;
quit;

/* Tri décroissant sur le prix maximum */
proc sort data=max_price_country;
    by descending max_price;
run;

proc print data=max_price_country label;
    label country = "Pays" max_price = "Prix maximum";
    title "Prix maximum par pays (tri décroissant)";
run;

/* Somme des prix par taster_name */
proc sql;
    create table sum_price_taster as
    select taster_name,
           sum(price) as total_price
    from wine
    where taster_name is not null
    group by taster_name;
quit;

/* Tri décroissant sur la somme des prix */
proc sort data=sum_price_taster;
    by descending total_price;
run;

proc print data=sum_price_taster label;
    label taster_name = "Dégustateur"
          total_price = "Somme des prix";
    title "Somme des prix par taster_name (ordre décroissant)";
run;
