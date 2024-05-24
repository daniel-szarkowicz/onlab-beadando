#import "templ.typ": template, todo, todoImage

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
  todoImage[AABB kép],
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
  todoImage[Sort and sweep intervallumok],
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

== Narrow phase
=== Egyszerű gömb ütközés
=== GJK
=== EPA

#heading(level: 1)[Árnyék szimuláció]
= Percentage closer filtering
= Cascaded shadow maps
= Exponential shadow maps

#bibliography("references.yml", full: true)
