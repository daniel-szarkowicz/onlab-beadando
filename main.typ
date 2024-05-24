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
=== 3 axis sort and sweep
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
