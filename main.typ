#import "templ.typ": template

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
== Broad phase
=== Sort and sweep
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
