#import "templ.typ": template, todo, todo_image

#show: template.with(
  title: [Rigid body és árnyék szimuláció],
  subtitle: [Önálló laboratórium],
  author: [Szarkowicz Dániel],
  consulent: [Fridvalszky András],
)


#heading(level: 1)[Rigid body szimuláció]
= Fizikai modell
A rigid body szimulációnak a newtoni mechanika szabályai szerint kell működnie.

== Mozgás
Egy test mozgásának a leírásához a test pozíciójára és sebességére lesz szükség.
A pozícióra és a sebességre a következőt írhatjuk fel:
$
  v(t) = d/(d t) x(t)
$
A szimuláció állapota időben diszkrét módon frissül. Az új állapotot a következő
módon számulhatjuk ki az előző állapotból:
$
  x(t + Delta t) = x(t) + Delta t dot v(t)
$
Ezt a módszert Euler integrációnak hívjuk. Léteznek pontosabb számítási
módszerek is, példáuk a Runge-Kutta metódus.

A szimuláció a test sebessége helyett a test lendületét tárolja, ez a következő
módon áll kapcsolatban a sebességgel:
$
  p = m v
$
Ennek az előnyeiről bővebben az @ütközés fejezetben fogok írni.

== Forgás
== Ütközés <ütközés>

= Ütközés detektálás
Most már kész van a fizikai modell, de még nem tudnak egymással ütközni a
testek, ehhez egy ütközés detektáló algoritmus fog kelleni.

== Narrow phase
A Narrow phase algoritmusok feladata megvizsgálni, hogy két test ütközik-e, és
ha ütköznek, akkor visszaadni az ütközés paramétereit, két ütközési pontot és
egy ütközési normált, hogy a @ütközés fejezetben leírt módon frissíthessük a
sebességeiket.

=== Egyszerű gömb ütközés
A szimuláció eleinte csak gömböket támogatott, mert azokra a legegyszerűbb
kiszámolni, hogy ütköznek-e.

Két gömb akkor ütközik, ha a középpontjaik távolsága kisebb, mint a sugaraik
összege:
$
  |bold(c_1) - bold(c_2)| < r_1 + r_2
$
Ha ütköznek, akkor az ütközési normál:
$
  bold(n) = (bold(c_1) - bold(c_2))/(|bold(c_1) - bold(c_2)|)
$
és az ütközési pontok:
$
  bold(p_1) = bold(c_1) - r_1 bold(n)\
  bold(p_2) = bold(c_2) + r_2 bold(n)
$

=== GJK
=== EPA

== Broad phase
Az összes pár megvizsgálása $O(n^2)$ lenne, ami nagyon lassú. Szerencsére
a legtöbb test nem ütközik, ezért egy megfelelő heurisztikával sokat lehet
spórolni. A szimuláció gyorsításához kell egy algoritmus, ami gyorsan eldobja
a teszteknek egy jelentős részét és így csak a párok egy kis hányadát kell
megvizsgálni. Ezek az algoritmusok általában csak egyszerű alakzatokon tudnak
dolgozni, a következő algoritmusok axis-aligned bounding boxokat (AABB)
használnak. Az AABB-k olyan téglatestek, amik tartalmazzák az az egész testet és
az oldalai párhuzamosak a koordinátarendszer tengelyeivel.

#figure(
  todo_image[AABB kép],
  caption: [Egy #todo[TODO]-nak az AABB-je.]
)

=== Sort and sweep
A sort and sweep @baraff2 egy egyszerű algoritmus az ellenőrzött párok
csökkentésére. Az algoritmus az egyik tengely szerint intervallumokként kezeli
az AABB-ket és átfedő intervallumokat keres. Ezt úgy éri el, hogy egy listába
kigyűjti minden AABB-nek az elejét és a végét a kiválasztott tengely szerint,
rendezi a listát, majd egyszer végig iterál a listán és kigyűjti az átfedő
intervallumokat. Az átfedő intervallumok listája tartalmazza a potenciális
ütközéseket, ezt a listát érdemes szűrni az AABB-k másik két tengelye szerint,
mielőtt a tényletes ütközés detektálás algoritmust futtatnánk. Az algoritmusnál
sokat számíthat a megfelelő tengely kiválasztása, rossz tengely megválasztásakor
lehet, hogy csak a pároknak egy kis részét dobjuk el.
#figure(
  todo_image[Sort and sweep intervallumok],
  caption: [
    A sort and sweep algoritmus intervallumai az egyik tengelyen. Látszik, hogy
    ha rossz tengelyt választunk ki, akkor nem segít sokat az algoritmus.
  ]
)

=== Sort and sweep mindhárom tengely szerint
Ha az előbb említett algoritmust mindhárom tengely mentén futtatnánk, akkor az
AABB-k szerint tökéletes szűrést kapnánk. Az algoritmust háromszor futtatni nem
nehéz, de a három lefutás eredményének kombinációja annál inkább. Egy lefutásból
az eredmény lista sajnos $n^2$-el arányos méretű, ezeknek a kombinációja nagyon
lassú lenne, ezért az algoritmusokat külön futtatni nem érdemes.

Egy másik megoldás lehetne, hogy az algoritmusok eredményeit nem külön helyre
gyűjtük, hanem egy helyre, és akkor nem kell az eredményeket utólag
kombinánlunk. Erre a következő algoritmus használható:
+ Adott egy $n times n$-es mátrix $0$ értékekkel feltöltve.
+ Futtatjuk a sort and sweep-et az első tengely szerint, és az átfedő
  intervallumokhoz $1$ értéket írunk a mátrixba.
+ Futtatjuk a sort and sweep-et a második tengely szerint, és az átfedő
  intervallumoknál ha $1$ van a mátrixban, akkor $2$-t írunk.
+ Futtatjuk a sort and sweep-et a harmadik tengely szerint, és az átfedő
  intervallumoknál ha $2$ van a mátrixban, akkor kimentjük egy listába a párt.
Ez az algoritmus jó is lehetne, de a mátrixot vagy minden futtatáskor újra le
kell foglalni, vagy a futtatás után helyre kell állítani. A helyreállítást úgy
lehet megoldani, hogy az első tengely szerint kimentjük, hogy hova írtunk a
mátrixban és a futás után $0$-t írunk az elmentett helyekre. Sajnos a
helyreállítás költsége megegyezik a sort and sweep költségével, és ehhez még
hozzá jön, hogy a sort and sweep-et háromszor kellett futtatni. Ugyan az
algoritmus megspórolta nekünk az AABB metszet ellenőrzést, de cserébe 4
sort and sweep-nyi (3 a három tegelyhez + 1 a helyreállítás) iterációt kellett
végrehajtani, ami lassabb, mint az egy tengely menti sort and sweep és az AABB
ellenőrzés.

=== R-Tree
A szimulációban használt broad phase algoritmus (adatstruktúra) az R-Tree.
Az R-Tree a B-Tree-nek egy kibővített változata, ami többdimenzió szerint
rendezhető adatokra tud hatékony keresést biztosítani.

A R-Tree minimal bounding box-okból épül fel. Ezek olyan AABB-k, amiknél kisebb
AABB nem lenne képes bentfoglalni a tartalmazott elemeit. Az R-Tree-be
felépítésekor egyesével illesztjük be az AABB-ket. Az R-Tree-nék két fontos
algoritmus van: legjobb csúcs kiválasztása a beillesztéshez, és legjobb vágás
kiszámítása, ha egy csúcs megtelt. A szimuláció a beillesztéshez a legkisebb
térfogat növekedést választna, a vágáshoz a Quadratic splitet @rstar használ.

#figure(
  todo_image[R-Tree],
  caption: [Az R-Tree]
)

Az R-Tree-k felépítéséhez és karbantartásához számos algoritmus jött létre.

Az R\*-Tree @rstar optimálisabb csúcsválasztást és optimálisabb vágást
használ és ha a vágás után egy elem nagyon nem illik be egyik csoportba sem,
akkor újra beilleszti a fába, hátha talál jobb helyet.

Az STR @str és az OMT @omt nem egyesével építi fel a fát, hanem egyszerre
dolgozik az összes adattal, így közel tökéletes fákat tudnak felépíteni.

#heading(level: 1)[Árnyék szimuláció]
= Percentage closer filtering
= Cascaded shadow maps
= Exponential shadow maps

#bibliography("references.yml", full: true)
