**************************
* Replicacao dissertação *
*			 *
*      1/2/2015		 *
*			 *
**************************


set more off
use "C:\Users\User\Desktop\bd3.dta", clear


***********************
* TABELA 1
***********************

* Modelo 1
logit surplusDummy negretto_leg1 pres_seats range1 distance1 cicle h_polcon3 t t2 t3 infl enp, vce(cluster presid)

* Modelo 2
logit surplusDummy veto cda presdom pres_seats range1 distance1 cicle h_polcon3 t t2 t3 infl enp, vce(cluster presid)

* Modelo 3
logit surplusDummy eff_leg veto cda presdom pres_seats range1 distance1 cicle h_polcon3 t t2 t3 infl enp, vce(cluster presid)

* Modelo 4
nbreg surplus negretto_leg1 pres_seats range1 distance1 cicle h_polcon3 infl enp, vce(cluster presid)

* Modelo 5
nbreg surplus veto cda presdom eff_leg pres_seats range1 distance1 cicle h_polcon3 infl enp, vce(cluster presid)


***********************
* TABELA 2
***********************

* Modelo6
logit surplusDummy country negretto_leg1 pres_seats range1 distance1 cicle h_polcon3 infl enp, vce(cluster presid)

* Modelo 7:
logit surplusDummy country cda veto presdom pres_seats range1 distance1 cicle h_polcon3 infl enp, vce(cluster presid)

* Modelo 8:
nbreg surplus country negretto_leg1 pres_seats range1 distance1 cicle h_polcon3 infl enp, vce(cluster presid)

* Mode 9
logit surplusDummy presid veto cda presdom pres_seats range1 distance1 cicle h_polcon3 infl enp, vce(cluster presid)


***********************
* Apêndices
***********************

* Tabela 4
* Modelo A
logit surplusDummy negretto_leg1 pres_seats range2 distance2 cicle h_polcon3 t t2 t3 infl enp, vce(cluster presid)

* Modelo B
logit surplusDummy negretto_leg1 pres_seats range2 distance2 cicle h_polcon3 t t2 t3 infl enp eff_leg, vce(cluster presid)

* Modelo C
logit surplusDummy negretto_leg1 pres_seats range3 distance3 cicle h_polcon3 t t2 t3 infl enp, vce(cluster presid)

* Modelo D
logit surplusDummy negretto_leg1 pres_seats range3 distance3 cicle h_polcon3 t t2 t3 infl enp eff_leg, vce(cluster presid)


* TABELA 5
* Modelo E
logit surplusDummy prespow2 pres_seats range1 distance1 cicle h_polcon3 t t2 t3 infl enp, vce(cluster presid)

* Modelo F
logit surplusDummy prespow2 pres_seats range1 distance1 cicle h_polcon3 t t2 t3 infl enp jw_avgballot, vce(cluster presid)

* Modelo G
logit surplusDummy prespow2 pres_seats range1 distance1 cicle h_polcon3 t t2 t3 infl enp jw_avgballot fh_status al_ethnic, vce(cluster presid)

* Modelo H
logit surplusDummy negretto_leg1 pres_seats range1 distance1 cicle h_polcon3 t t2 t3 infl enp jw_avgballot, vce(cluster presid)

* Modelo I
logit surplusDummy negretto_leg1 pres_seats range1 distance1 cicle h_polcon3 t t2 t3 infl enp jw_avgballot fh_status al_ethnic, vce(cluster presid)

* TABELA 6
* Modelo - Bolívia
logit surplusDummy negretto_leg1 pres_seats range1 distance1 cicle h_polcon3 t t2 t3 infl enp, vce(cluster presid)

* Modelo - Brasil
logit surplusDummy negretto_leg1 pres_seats range1 distance1 cicle h_polcon3 t t2 t3 infl enp, vce(cluster presid)

* Modelo - Colômbia
logit surplusDummy negretto_leg1 pres_seats range1 distance1 cicle h_polcon3 t t2 t3 infl enp, vce(cluster presid)

* Modelo - Peru
logit surplusDummy negretto_leg1 pres_seats range1 distance1 cicle h_polcon3 t t2 t3 infl enp, vce(cluster presid)


***********************
* GRAFICOS
***********************

* Grafico (dependência temporal)
logit surplusDummy negretto_leg1 pres_seats range1 distance1 cicle h_polcon3 t t2 t3 infl enp, vce(cluster presid)

egen mnegretto_leg1=mean(negretto_leg1)
egen mpres_seats=mean(pres_seats)
egen mrange1=mean(range1)
egen mdistance1=mean(distance1)
egen mcicle=mean(cicle)
egen mh_polcon3=mean(h_polcon3)
egen minfl=mean(infl)
egen menp=mean(enp)

duplicates drop t, force

keep t t2 t3 mnegretto_leg1 mpres_seats mrange1 mdistance1 mcicle mh_polcon3 minfl menp

rename mnegretto_leg1 negretto_leg1
rename mpres_seats pres_seats
rename mrange1 range1
rename mdistance1 distance1
rename mcicle cicle
rename mh_polcon3 h_polcon3
rename minfl infl
rename menp enp

predict p

twoway line p t







