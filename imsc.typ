#import "templ.typ": *

#show: template.with(
  title: [Merevtest- és árnyékszimuláció],
  subtitle: [Önálló laboratórium\ bővített összefoglaló],
  author: [Szarkowicz Dániel],
  consulent: [Fridvalszky András],
  showoutline: false
)

#set heading(numbering: none)

#chapter[Merevtest-szimuláció]

A merevtest-szimulációnak a célja a mindennapi fizikai objektumok egymásra
hatásának szimulációja. A merevtestek fizikai modellje @baraff1 @baraff2 által
megfogalmazottaknak felel meg. A testek ütközésének érzékelésére eleinte egy
egyszerű gömb ütközés, később a Gilbert-Johnson-Keerthi algoritmus @gjk és az
Expanding Polytope Algorithm került implementálásra; ezeknek az implentációja a
@dyn4j-gjk @dyn4j-epa 2 dimenziós algoritmusoknak a 3 dimenziós generalizációja.
Az előbb említett ütközés detekciós algoritmusok lassúak és az esetek
többségében a testekről egyszerűen belátható, ha nem ütköznek, ehhez általában
AABB-ket használnak. A sort and sweep algoritmus @baraff2 az egyik tengely
szerint rendezi az AABB-ket, majd így intervallum átfedéseket keres.
Az R-Tree egy fa struktúrában tárolja az AABB-ket, a potenciális ütközések
összegyűjtéséhez a fában hatékonyan lehet keresni a metsző AABB-ket. Az R-Tree
nek számos bővítménye van, az R\*-Tree @rstar hatékonyabb keresőfát épít fel
kicsit lassabb algoritmusokkal, az OMT @omt és az STR @str a teljes adathalmazon
egyszerre dolgozva épít fel szinte tökéletes fákat. Jelenleg több mint 1000
kocka ütközése szimulálható valós időben, de a szimuláció felvételével és
visszajátszásával komplexebb esetek is futtathatók.

#chapter[Árnyékszimuláció]

A számítógépes grafikában egy elterjedt árnyékszimulációs metódus a Shadow
Mapping. A szimuláció @shadow-mapping alapjaira épít és további módszerekke
próbálja javítani az árnyékok minőségét. A Percentage Closer Filtering @pcf
egy területen átlagolja az árnyékokat, így szép átmeneteket ad az árnyékok
széleinél. A Cascaded Shadow Maps @cascaded több részre vágja a látható teret és
ezekre külön textúrákban tárolja az adatokat, így közel nagyob lesz a textúra
pixelsűrűsége, távol nagyob lesz az árnyékolható terület (akár a teljes látható
tér). Az Exponencial Shadow Maps @esm más formátumban tárolja az
mélységadatokat, így az átlagolás az árnyékok kirajzolása előtt elvégezhető és
a rajzoláskor csak egyszer kell olvasni a textúrát.

#bibliography("references.yml")
