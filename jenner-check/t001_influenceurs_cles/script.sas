/* ---------------------------------------------------------------------------
   Bundle derived from: prog influenceurs cles.sas
   The upstream script reads the `wine` dataset (imported from wine.csv). To
   keep this bundle self-contained, a small representative sample of wine.csv
   is inlined below as the `wine` table; the analysis that follows is the
   repo's own logic (Pinot Noir US influencer analysis).
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
    where variety_up = "PINOT_NOIR"
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

proc print data=taster_key label;
    label taster_name = "Dégustateur"
          n_wines     = "Nb vins"
          avg_points  = "Note moyenne"
          avg_price   = "Prix moyen";
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

proc print data=province_by_volume label;
    title "Provinces clés pour le Pinot Noir aux USA (volume)";
run;

/*===========================================================
= 5. Facteurs explicatifs : prix vs qualité
===========================================================*/
proc corr data=pinot_usa;
    var price points;
    title "Corrélation prix ↔ note (Pinot Noir USA)";
run;

proc reg data=pinot_usa;
    model price = points;
    title "Modèle explicatif du prix du Pinot Noir aux USA";
run;
quit;
