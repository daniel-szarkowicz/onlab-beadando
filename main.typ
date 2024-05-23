#import "templ.typ": template

#show: template.with(
  title: [Rigidbody és árnyék szimuláció],
  subtitle: [Önálló laboratórium],
  author: [Szarkowicz Dániel],
  consulent: [Fridvalszky András],
)

#heading(level: 1)[Rigid body szimuláció]
= Fizikai modell
== Mozgás
== Forgás
== Ütközés

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
= Exponential shadow maps
