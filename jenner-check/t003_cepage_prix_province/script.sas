/* ---------------------------------------------------------------------------
   Bundle derived from: prog_cepage_prix_province.sas
   The upstream script reads work.wine_clean (built from the `wine` import of
   wine.csv). A small representative sample of wine.csv is inlined below and
   the wine_clean preparation step is included so the bundle runs on its own;
   the France cépage/price analysis that follows is the repo's own logic
   (PROC FREQ out=, PROC MEANS class/output, long-format restructure).
   --------------------------------------------------------------------------- */
data wine;
    length country $12 province $20 taster_name $20 variety $22 winery $28;
    input country $ points price province $ taster_name $ variety $ winery $;
    price_num = price;
    datalines;
US 87 44 Oregon Paul_Gregutt Pinot_Noir Sweet_Cheeks
US 87 51 California Virginie_Boone Pinot_Noir Castello_di_Amorosa
US 86 41 Oregon Paul_Gregutt Pinot_Noir Erath
France 87 25 Alsace Roger_Voss Pinot_Gris Jean_Baptiste_Adam
France 86 15 Beaujolais Roger_Voss Gamay Henry_Fessy
France 86 18 Beaujolais Roger_Voss Gamay Vignerons_Bel_Air
France 85 17 Bordeaux Roger_Voss White_Blend Chateau_de_Sours
France 86 91 Champagne Roger_Voss Champagne_Blend Roland_Champion
France 86 87 Champagne Roger_Voss Champagne_Blend Collet
France 87 19 Beaujolais Roger_Voss Gamay Pardon_et_Fils
Spain 87 20 Northern_Spain Michael_Schachner Tempranillo Tandem
Italy 87 19 Sicily Kerin_OKeefe Frappato Terre_di_Giurfo
;
run;

/* Préparation : wine_clean (comme dans le programme d'influenceurs) */
data wine_clean;
    set wine;
    variety_up  = upcase(variety);
    country_up  = upcase(country);
    taster_up   = upcase(taster_name);
    province_up = upcase(province);
run;

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
proc freq data=wine_france;
    tables province / out=work.count_province_fr;
    title "Nombre de cépages (variety) par province — France";
run;

/* ============================================================
   3. Calcul des prix min et max par province
   ============================================================ */
proc means data=wine_france noprint;
    class province;
    var price_num;
    output out=stats_province_fr (drop=_type_ _freq_)
        min=min_price
        max=max_price;
run;

/* ============================================================
   4. Restructurer en format long pour barres groupées
   ============================================================ */
data stats_long;
    set stats_province_fr;
    metric = "Min";
    price = min_price;
    output;
    metric = "Max";
    price = max_price;
    output;
run;

proc print data=stats_long label;
    label province = "Province" metric = "Mesure" price = "Prix";
    title "Prix minimum et maximum par province — France (format long)";
run;
