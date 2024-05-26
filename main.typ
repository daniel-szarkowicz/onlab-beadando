#import "templ.typ": template, todo, todo_image, chapter

#show: template.with(
  title: [Merevtest- és árnyékszimuláció],
  subtitle: [Önálló laboratórium],
  author: [Szarkowicz Dániel],
  consulent: [Fridvalszky András],
)

// #chapter(numbering: none)[Bevezető]
// A realisztikus, valós idejű szimulációknak egyre fontosabb szerepe van a
// videójátékok terén. Az élethű szimulációk növelik a játékok immerzióját és 

#chapter[Merevtest-szimuláció]
= Fizikai modell
A merevtest-szimulációnak a newtoni mechanika szabályai szerint kell működnie.

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
módszerek is, például a Runge-Kutta metódus.

A szimuláció a test sebessége helyett a test lendületét tárolja, ez a következő
módon áll kapcsolatban a sebességgel:
$
  p(t) = m dot v(t)
$
Ennek az előnyeiről bővebben az @ütközés fejezetben fogok írni.

== Forgás
A testek forgása a test mozgásához hasonlóan kezelhető. A testnek van egy
elfordulása, amit egy forgatásmátrixban tárolunk és egy szögsebessége, amit
egy tengellyel és egy nagysággal jellemzünk, ez egy vektorban tárolható. 

A testnek az új elfordulása a következő módon számolható ki a régi elfordulásból
és a szögsebességből:
$
  R(t + Delta t) = (Delta t dot omega(t)^*) dot R(t),\
  #[ahol @baraff1 szerint] quad omega(t)^* = mat(
    0, -omega(t)_z, omega(t)_y;
    omega(t)_z, 0, -omega(t)_x;
    -omega(t)_y, omega(t)_x, 0
  )
$

Míg a mozgásnál a lendületmegmaradás általában megegyezik a
sebességmegmaradással, a forgásnál a perdületmegmaradás nem egyezik meg a
szögsebesség-megmaradással, mert a tehetetlenségi nyomaték nem konstans. A 
newtoni mechanika szerint perdületmegmaradás van, ezért a szimulációban érdemes
a szögsebesség helyett a perdületet tárolni. A perdület a következő képpen áll
kapcsolatban a szögsebességgel:
$
  L(t) = Theta(t) dot omega(t),\
  #[ahol @baraff1 szerint] quad Theta(t) = R(t) dot Theta dot R(t)^(-1)
$
Egy testnek az alap tehetetlenségi nyomatéka az alakjától és a súlyeloszlásától
függ. A szimulációban használt testek tehetetlenségi nyomatéka a következő:
$
  Theta_"gömb" &= 2/3 m dot r^2\
  Theta_"téglatest" &= m/12 dot mat(
    h^2 + d^2, 0, 0;
    0, d^2 + w^2, 0;
    0, 0, w^2 + h^2
  )
$
A szimulációban a tehetetlenségi nyomatéknak csak az inverzét használjuk, mert
mindig perdületből konvertálunk szögsebességbe, ezért a tehetetlenségi
nyomatéknak az inverzét tárolja.

== Ütközés <ütközés>

=== Impulzus és szögimpulzus
A szimulációban a testek nem deformálódhatnak és nem metszhetik egymást, ezért
az ütközésnek egy pillanatnyi eseménynek kell lennie. Mivel az erő és a
forgatónyomaték $0$ idő alatt nem tudnak változást elérni, ezért helyettük
impulzusokat és szögimpulzusokat kell használni.

A impulzus kifejezhető úgy, mint egy erő, ami egy kicsi idő alatt hat:
$
  J = F dot Delta t
$
Ha az impulzus egy $x_J$ pontban hat a testre, akkor a szögimpulzus:
$
  M = (x_J - x(t)) times F, quad "a forgatónyomaték"\
  Delta L = M dot Delta t = (x_F - x(t)) times F dot Delta t
    = (x_J - x(t)) times J
$

Tehát, ha egy testre egy $J$ impulzus hat egy $x_J$ pontban, akkor a test
lendülete és perdülete a következő módon változik meg:
$
  p'(t) = p(t) + J\
  L'(t) = L(t) + (x_J - x(t)) times J
$

=== Lokális sebesség és lokális tehetetlenség
Az ütközési számításokhoz szükséges lesz a testek lokális sebességére egy adott
$x_J$ pontban. Ez a sebességből és a szögsebességből származó kerületi sebesség
összege:
$
  v_l = v(t) + omega(t) times (x_J - x(t)) =
    p(t) / m + (I^(-1)(t) dot L(t)) times (x_J - x(t))
$

Szükség lesz még a testek lokális tehetetlenségére. Ez a test tömegéből és
tehetetlenségi nyomatékából származó ellenállás a lokális sebesség adott irányú
változására. Ennek az inverzét így számoljuk ki @baraff2 egy adott irányban az
$x_J$ pontban:

#let big(x) = $lr(size: #150%, #x)$

$
  T^(-1)(hat(u)) = hat(u) dot big([
    hat(u) / m +
    big((I^(-1)(t) dot big([(x_J - x(t)) times hat(u)])))
    times (x_J - x(t))
  ])
$

=== Normál irányú impulzus
#let vlr = $v_(l r)$
#let vlr2 = $v'_(l r)$
#let dvlrn = $Delta v_(l r,n)$

Két test ütközésekor a testek lokális relatív sebességével (#vlr) kell számolni.
$
  vlr = v_(1,l) - v_(2,l)
$
Jelölje az ütközés utáni lokális relatív sebességet #vlr2.

Ha két test tökéletesen rugalmasan ütközik, akkor #vlr2 normál irányú
komponense #vlr normál irányú komponensének a negáltja lesz:
$
  vlr2 = vlr - 2 hat(n) dot (hat(n) dot vlr)
$
Ha két test tökéletesen rugalmatlanul ütközik, akkor #vlr2 normál irányú
komponense $0$ lesz:
$
  vlr2 = vlr - hat(n) dot (hat(n) dot vlr)
$
Jelölje $epsilon$ az ütközés rugalmasságát. Ha $epsilon = 1$, akkor az ütközés
töléletesen rugalmas, ha $0$ akkor tökéletesen rugalmatlan. Így a normál irányú
sebességnek a változása a következő:
$
  dvlrn = -(1 + epsilon) dot (hat(n) dot vlr)
$
Ezt a sebességváltozást a lendületmegmaradás törvénye értelmében egy azonos
nagyságú, ellentétes irányú impulzus fogja kiváltani a két testen. Az impulzus
nagysága a testek normál irányú lokális tehetetlenségéből jön ki @baraff2:
$
  |J_n| = dvlrn / (T_1^(-1)(hat(n)) + T_2^(-1)(hat(n)))
$

=== Nem normál irányú (súrlódási) impulzus
Két test ütközése során nem csak normál irányú erők (impulzusok) hatnak a
testekre, mert a testek súrlódnak is egymáson. A súrlódás "célja" az, hogy a
testek $vlr$-ének a nem normál irányú komponenseit $0$ felé közelítse.

A súrlódási impulzus nagyságának maximuma a normál irányú impulzus nagyságától
és a súrlódási együtthatótól függ:
$
  |J_s| <= |J_n| dot mu
$
A súrlódási impulzus irányához és nagyságához kelleni fog a $vlr$ nem normál
irányú komponense:
$
  v_(l r, s) = vlr - hat(n) dot (hat(n) dot vlr)
$
A sebesség $0$-ra állításához szükséges impulzus nagyságát a következő módon
kaphatjuk meg:
$
  |J_s^*| = (-|v_(l r, s)|)/(T_1^(-1)(hat(v)_(l r, s)) + T_2^(-1)(hat(v)_(l r, s)))
$
Tehát a súrlódási impulzus:
$
  J_s = min(|J_s^*|, |J_n| dot mu) dot hat(v)_(l r, s)
$

A súrlódást külön lehet bontani tapadási és csúszási súrlódásra. Ilyenkor ha
$|J_s^*|$ nagyobb, mint a tapadási súrlódás maximális nagysága, akkor a csúszási
súrlódás nagyságát használjuk a súrlódási impulzus nagyságaként.

= Ütközés detektálás
Most már kész van a fizikai modell, de még nem tudnak egymással ütközni a
testek, ehhez egy ütközés detektáló algoritmus fog kelleni.

== Narrow phase
A Narrow phase algoritmusok feladata megvizsgálni, hogy két test ütközik-e, és
ha ütköznek, akkor visszaadni az ütközés paramétereit, két ütközési pontot és
egy ütközési normált, hogy a @ütközés fejezetben leírt módon frissíthessük a
sebességeiket.

=== Egyszerű gömb ütközés <sphere-collision>
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

=== Gilbert-Johnson-Keerthi (GJK)
Egy elterjedt ütközés detektálási algoritmus a Gilbert-Johnson-Keerthi @gjk
algoritmus, ami tetszőleges convex testek távolságát tudja meghatározni, ha a
testekre definiálva van a support function. A support functionnek egy adott
irányban kell a test legtávolabbi pontját visszaadni.

Az algoritmus két test Minkowski különbségéről vizsgálja meg, hogy benne van-e
az origó. Ha a különbségben benne van az origó, akkor ütközést talált, ha a
különbségben nincs benne az origó, akkor Minkowski különbség és az origó
távolsága a két test távolsága. A Minkowski különbség legközelebbi pontjából
ki lehet fejteni a két test legközelebbi pontját is.
#figure(
  grid(columns: 2, gutter: 10pt,
    todo_image[Minkowski különbség],
    todo_image[Minkowski különbség],
  ),
  caption: [
    Egy #todo[TODO] és egy #todo[TODO] minkowski különbsége. Az első képen a két
    test ütközik, a Minkowski különbségük tartalmazza az origót. A második képen
    a két test nem ütközik, a távolságuk megegyezik a Minkowski különbség és az
    origó távolságával.
  ]
)
A Minkowski különbség összes pontján egy kicsit sok időbe telne végig iterálni,
de a különbséget felépítő szimplexeken (2 dimenzióban háromszög, 3 dimenzióban
tetraéder) már lehetséges. Ehhez a Minkowski különbség support functionjére lesz
szükség, amit a következő módon számíthatunk ki egy $A$ és egy $B$ test support
functionjéből:
$
  s(bold(d)) = s_A (bold(d)) - s_B (-bold(d))
$
Tehát az algoritmus a Minkowski különbség szimplexein iterál végig. Ezekkel a
szimplexekkel egyre közelíteni szeretnénk az origót, míg vagy a szimplex
tartalmazza az origót, vagy nem sikerült közelebb jutnunk az origóhoz. Az
origóhoz úgy lehet közelíteni, hogy a szimplexnek vesszük az origóhoz a
legközelebbi részszimplexét és a legközelebbi pontját, és a legközelebbi
ponttal ellentétes irányba kérünk a support functiontől egy új pontot, amit
hozzáadunk a szimplexhez.

Az algoritmus két féle képpen került implementációra.

Az első implementáció baricentrikus koordinátákkal kereste meg a legközelebbi
részszimplexet és a legközelebbi pontot. Sajnos a legközelebbi részszimplex
keresésnél néha nem egyértelmű, hogy melyik részszimplex van közelebb és többet
is meg kell vizsgálni, ami nem csak azért probléma, mert több számítást végez,
de azért is, mert így másolni kell a szimplex adatait, amit nem lehet
kioptimalizálni.

A második implementáció a teret részszimplexenként két részre osztja és
megnézi, hogy a részszimplexen belül vagy kívül esik-e az origó. Előbb vagy
utóbb egy néhány részszimplex vagy körbe fogja az origót, és akkor tudjuk, hogy
a részszimplexek által alkotott szimplex tartalmazza az origóhoz a legközelebbi
pontot, vagy egy ponton (0 dimenziós szimplex) kívül esik az origó, és akkor
tudjuk, hogy a pont a legközelebbi pont (és részszimplex) az origóhoz. A
szimuláció @dyn4j-gjk által bemutatott 2 dimenziós algoritmusnak egy 3 dimenziós
generalizációját használja.

A GJK könnyen használható gömbileg kiterjesztett testekre, például egy gömbre
vagy kapszulára, hiszen a két test legközelebbi pojtna adott és sugara adott,
innentől a @sphere-collision fejezetben írt módon lehet kiszámolni, hogy a két
test ütközik-e, és ha igen, akkor mik az ütközési paramétereik.

=== Expanding Polytope Algorithm (EPA)
A GJK egyik hiányossága, hogy ha két test ütközik, akkor csak annyit mond, hogy
ütköznek, nem ad nekünk használható ütközési paramétereket. Az EPA úgy segít,
hogy a GJK-ból kapott szimplexet iteratívan bővíti újabb pontokkal, amíg
megtalálja az átfedő terület szélességét. Az EPA a GJK-ban használt legközelebbi
pont algoritmust használja, de nem az egész politópon futtatja, hanem csak a
politóp oldalait alkotó szimplexeken.

Az EPA a Minkowski különbségnek az origóhoz legközelebbi felszíni pontját keresi
meg. Ezt úgy éri el, hogy a politóp legközelebbi pontjának irányában kér egy új
pontotk a különbség support functionjétől, ha talált távolabbi pontot, akkor
kiegészíti a politópot az új ponttal, ha nem talált távolabbi pontot, akkor
megtaláltuk a Minkowski különbség legközelebbi felszíni pontját.

#figure(
  todo_image[EPA],
  caption: [
    Az EPA felfedte a Minkowski különbség egy részét, amíg megtalálta a
    legközelebbi felszíni pontot.
  ]
)

A politóp bővítése nem egy könnyű feladat, ugyanis ha hozzáadunk egy új pontot
a politóphoz, akkor ki kell számolni, hogy milyen régi oldalakat kell kitörölni,
és hogy milyen új oldalakat kell felvenni. Azokat a régi oldalakat kell törölni,
amelyek az új pont "alatt" vannak, azaz az egyik oldalukon az új pont van, a
másik oldalukon pedig az origó. Az új oldalakat úgy kell hozzáadni, hogy a régi
oldalak azon széleit, amelyeket csak az egyik oldalról határolt kitörölt oldal
összekötjük az új ponttal. Ez a bővítés elképzelhető egy konvex burok iteratív
felépítéseként is.

A szimuláció @dyn4j-epa által bemutatott 2 dimenziós algoritmusnak egy 3
dimenziós generalizációját használja.

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

#chapter[Árnyékszimuláció]
A számítógépes grafikában az egyik legelterjedtebb valós idejű árnyékszimulációs
módszer a shadow mapping.

A shadow mapping alapja nagyon egyszerű: először kirajzoljuk a világot a fény
szemszögéből, majd kirajzoljuk a világot a kamera szemszögéből és minden pixelre
megnézzük, hogy a fényforrás látja-e az adott pixelt. Ehhez a fény
mélységbufferére és kamera mátrixára lesz szükség. A pixel világkoordinátáját
transzformáljuk a fény kamera mátrixával, az eredményül kapott $x, y$
koordinátákon található mélységet lekérdezzük a fény mélységbufferéből és
összehasonlítjuk a $z$ koordinátával; ha a mélység kisebb, mint a $z$
koordináta, akkor árnyékban van a pixel, különben nem.

Ezzel az egyszerű implementációval számos probléma van, közülük a
legrosszabbakra @shadow-mapping egyszerű megoldásokat ad. Viszont van egy
probléma, amire nincsen egyszerű megoldás: az árnyékok szélei csúnyák. Ennek
a problémának a megoldására számos trükk született, de mindegyiknek megvan a
saját problémája. A szimulációban ezek közül három lett kipróbálva.
#figure(
  todo_image[Pixelated hard edges],
  caption: [
    Az árnyékok szélei pixelesek, az átmenet az árnyékos és a fényes rész
    között hirtelen, ez nem túl realisztikus.
  ]
)

= Percentage Closer Filtering (PCF)
Az egyik elterjedt megoldás a PCF. Egy pixel árnyalásakor nem csak egy értéket
olvas ki a mélységbufferből, hanem a környékről többet. Ezeket az értékeket
mind összehasonlítja a pixel ménységével és kiszámolja, hogy milyen erős
árnyékban van a pont.

#figure(
  todo_image[PCF],
  caption: [A PCF szebb árnyékokat ad.]
)

A PCF egyik hátránya, hogy nagyon sok textúraolvasási műveletet kell végeznie.
Erre ad megoldást @pcf, ahol egy néhány olvasásról megnézzük, hogy árnyékban
van-e, és ha az összes olvasás igent vagy nemet válaszol, akkor visszaadja az
eredményt.

= Cascaded Shadow Maps (CSM)
Egy textúrával nem tudjuk lefedni a megfigyelő látóterét úgy, hogy a közel lévő
részeknek jó legyen a felbontása. Ezt a CSM @cascaded úgy oldja meg, hogy
felvágja a látóteret kisebb részekre, és minden részen külön textúrába dolgozik.
Így a közeli dolgokra sűrűbb a textúra, a távoliakra ritka, de ez nem probléma,
mert a távoli árnyék kevésbé látható. A CSM sok shadow mapping technikával
együtt használható, a PCF-el és az ESM-el is.

#figure(
  todo_image[CSM],
  caption: [
    A CSM-el több részre lett osztva a látótér. A #todo[TODO] az egyes textúrák
    által lefedett terület, a #todo[TODO] a látótér.
  ]
)

= Exponential Shadow Maps (ESM)
Az ESM @esm úgy szeretne javítani az árnyékok minőségén, hogy a filterezési
lépést a PCF-el ellentétben a kirajzolás előtt végzi el a teljes textúrára.
Ehhez a mélységadatot nem lineárisan, hanem exponenciálisan tárolja és
az összehasonlítás helyett egy másik exponenciális számmal szorozza össze
a textúrából olvasott értéket. Ha a szorzás eredménye $0$-hoz közeli, akkor
árnyék van, ha $1$-hez közeli, akkor nincs árnyék.

Sajnos előfordulhat, hogy az exponenciálisban szakadás van és az árnyék hibásan
jelenik meg. Ez a probléma úgy orvosolható, hogy ha a szorzás eredménye $1$-nél
nagyobb, akkor PCF-et használunk az árnyék kiszámolására. A szimulációban nem
sikerült ezt a hibajavítási lépést helyesen implementálni.

#figure(
  grid(columns: 2, gutter: 10pt,
    todo_image[Szép ESM egy sík felületen],
    todo_image[Hibás ESM egy zajos felülelen],
  ),
  caption: [
    Az ESM ad mindig szép árnyékokat, ilyenkor még a programban implementált
    javítás sem segít.
  ]
)

#chapter(numbering: none)[Implementáció]

A szimuláció Rust-ban és OpenGL-ben lett implementálva.

A program jelenleg egy szálon fut, de az ütközés detektálás (a program leglassab
része) könnyen átírható több szálra, illetve tervben van a rajzolás és a fizika
szálainak szétválasztása, hogy a kettő ne befolyásolja egymást.

Amennyiben a fizika nem képes valós időben futni, lehetőség van a testek
állapotának felvételére és visszajátszására. A rajzolásnál erre nincs lehetőség.

A szimuláció jelenleg csak gömböket és téglatesteket támogat, de a GJK-nak és az
EPA-nak köszönhetően könnyű lesz egyéb konvex alakzatok támogatása is. Tervben
van több részből álló testek szimulálása is, először csak statikusan elhelyezett
résztestekkel (ez szükséges a konkáv testek szimulációjához), de később akár
joint-okkal is.

A programban használt külső könyvtárak:
- *`anyhow`:* hibakezelést segítő dinamikus hiba típus
- *`bytemuck`:* byte szintű castolás a GPU-val való kommunikációhoz
- *`egui, egui_glow`:* egy immediate mode GUI keretrendszer
- *`glow`:* OpenGL absztrakció különböző implementációk felett
- *`glutin, glutin_winit`:* OpenGL betöltő
- *`nalgebra`:* lineáris algebra könyvtár
- *`rand`:* véletlen szám generálás
- *`raw-window-handle`:* absztrakciós réteg az ablakkészítő és a grafikus
  könyvtárak közé
- *`smallvec`:* stack allokált vektor implementáció
- *`winit`:* multiplatform ablakkészítő könyvtár

#chapter(numbering: none)[Eredmények]

A program több, mint 1000 kockát képes valós időben szimulálni egy
_AMD Ryzen 5 4500U_ processzoron.

#figure(
  image("wrecking_ball.png", width: 90%),
  caption: [
    A nagy kocka nekiütközik egy 1125 kis kockából álló falnak. A program még az
    ütközés pillanatában sem esik 60 fps alá.
  ]
)

#figure(
  image("carpet_bomb.png", width: 90%),
  caption: [
    Egy több, mint 10000 kockából álló színtér. Jelenleg esélytelen valós időben
    futtatni, de remélhetőleg további optimalizációval és több szálon való
    futtatással a 30 fps elérhető lesz. Amíg ez nem történik meg, addig a
    program felvétel funkcióját lehet használni.
  ]
)

#bibliography("references.yml")
