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

#figure(
  grid(columns: 2, gutter: 10pt,
    image("sphere_aabb.png"),
    image("rtree.png"),
  ),
  caption: [
    A bal oldalon egy gömb AABB-je, a jobb oldalon egy R-Tree látható.
    Az R-Tree-ben néhány téglatest átfedi egymást, ezen komplexebb
    algoritmusokkal lehet segíteni.
  ]
)

#figure(
  grid(columns: 2, gutter: 10pt,
    image("wrecking_ball.png"),
    image("carpet_bomb.png"),
  ),
  caption: [
    A bal oldalon egy valós időben szimulálható ($~1000$ kocka), a jobb oldalon
    egy valós időben nem szimulálható ($~10000$ kocka) látható.
  ]
)

#chapter[Árnyékszimuláció]

Az árnyékszimuláció célja a program realizmusának növelése, az árnyékok
növelhetik egy térnek a mélységérzetét is.
A számítógépes grafikában egy elterjedt árnyékszimulációs metódus a Shadow
Mapping. A szimuláció @shadow-mapping alapjaira épít és további módszerekke
próbálja javítani az árnyékok minőségét. A Percentage Closer Filtering @pcf
egy területen átlagolja az árnyékokat, így szép átmeneteket ad az árnyékok
széleinél. Az Exponencial Shadow Maps @esm más formátumban tárolja az
mélységadatokat, így az átlagolás az árnyékok kirajzolása előtt elvégezhető és
a rajzoláskor csak egyszer kell olvasni a textúrát. Az ESM néha nem ad jó
árnyékokat, és nem sikerült rendesen kijavítani a hibákat, ezért a végső program
nem használ ESM-et. A Cascaded Shadow Maps @cascaded több részre vágja a látható
teret és ezekre külön textúrákban tárolja az adatokat, így közel nagyob lesz a
textúra pixelsűrűsége, távol nagyob lesz az árnyékolható terület (akár a teljes
látható tér).
#figure(
  grid(columns: 2, gutter: 10pt,
    image("pixelated_edges.png"),
    image("pcf.png"),
  ),
  caption: [
    A bal oldalon az egyszerű Shadow Mapping, a jobb oldalon a PCM látható.
    A Shadow Mapping durva árnyék határokat ad, a PCF segít ezen, de még mindig
    nem tökéletesek az árnyékok, ezen tovább lehet segíteni jitterrel @pcf.
  ]
)

#figure(
  grid(columns: 2, gutter: 10pt,
    image("esm_good.png"),
    image("esm_bad.png"),
  ),
  caption: [
    A bal oldalon az ESM jó minőségű árnyékai láthatók. A jobb oldalon egy
    komplexebb eset található, amit az ESM nem tud rendesen kezelni.
  ]
)

#figure(
  image("csm.png", width: 90%),
  caption: [
    A CSM-el több részre lett osztva a látótér. A zöld csonka gúlák a látótér
    egyre távolodó részei, a piros téglatestek a látótér részeihez tartozó
    textúrák által lefedett területek.
  ]
)

#bibliography("references.yml")
