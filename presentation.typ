#import "@preview/polylux:0.3.1": *

#import "@preview/cetz:0.2.2"

#import "templ.typ": todo_image, todo

// #set page(paper: "presentation-16-9")
// #set text(size: 25pt)

#import themes.simple: *

#set text(font: "Noto Sans")

#show: simple-theme.with()

#title-slide[
  = Merevtest- és árnyékszimuláció
  #v(2em)

  Készítette: Szarkowicz Dániel

  Konzulens: Fridvalszky András
]

#slide[
  = Merevtest
  Mindennapi testek ideális modellje.

  Nem lehet összenyomni, nem metszhetik egymást.
  
  Ütközéskor egy pillanatban megváltozik a sebességük.
]

#slide[
  == Egyszerű ütközés
  #grid(columns: (1fr, auto))[
  Cél: ha két test ütközik, akkor visszapattannak egymásról.

  Adott: ütközési pont ($x_J$), normál ($hat(n)$), és a testek paraméterei.

  "Visszapattannak": mint ha az ütközés síkjáról pattannának vissza.
  A relatív sebesség normál irányú komponense az ellenkező irányba fog mutatni.
  ][
    #cetz.canvas({
      import cetz.draw: *
      let angle = 45deg
      let radius = 2
      let normal = (calc.cos(angle), calc.sin(angle))
      let tangent = (normal.at(1), -normal.at(0))
      let contact = normal.map(it => radius * it)
      let c1 = (0, 0)
      let c2 = contact.map(it => 2 * it)
      let v1 = (0, 1.5)
      let v2 = (0, -1.5)
      circle(radius: radius, c1)
      circle(radius: radius, c2)
      line(
        contact,
        contact.zip(normal).map(((it1, it2)) => it1 + it2 * radius * 0.9),
        stroke: red,
        mark: (end: ">")
      )
      line(
        contact.zip(tangent).map(((it1, it2)) => it1 + it2 * radius * 1.9),
        contact.zip(tangent).map(((it1, it2)) => it1 - it2 * radius * 1.9),
        stroke: red
      )
      line(
        c1,
        c1.zip(v1).map(((it1, it2)) => it1 + it2),
        stroke: green, mark: (end: ">")
      )
      line(
        c2,
        c2.zip(v2).map(((it1, it2)) => it1 + it2),
        stroke: green, mark: (end: ">")
      )
    })
  ]
]

#slide[
  == Egyszerű ütközés
  A sebességváltozás $Delta v_"rel" = -(1 + epsilon) dot v_("rel", hat(n)) $,
  ezt úgy kell szétosztani a két test között, hogy a lendületmegmaradás teljesüljön.

  // $(v_A - v_B) + Delta v_("rel", hat(n)) = (v'_A - v'_B)$\
  // $m_A dot v_A + m_B dot v_B = m_A dot v'_A + m_B dot v'_B$\
  #v(-1em)
  $
    cases(
      Delta v_"rel" = Delta v_A - Delta v_B,
      m_A dot Delta v_A + m_B dot Delta v_B = 0
    )\
    arrow.b.double\
    m_A dot Delta v_A = (Delta v_"rel")/(m_A^(-1) + m_B^(-1))\
  $
  // $(Delta v_A)/(m_A^(-1)) + (Delta v_B)/(m_B^(-1)) = 0$\
  // \
  // $(Delta v_A dot m_B^(-1) + Delta v_B dot m_A^(-1))/(m_A^(-1) + m_B^(-1)) = 0$\
  // \
  // $(Delta v_A dot m_B^(-1) - (Delta v_"rel" - Delta v_A) dot m_A^(-1))/(m_A^(-1) + m_B^(-1)) = 0$\
  // \
  // $(Delta v_A dot m_B^(-1) + Delta v_A dot m_A^(-1) - Delta v_"rel" dot m_A^(-1))/(m_A^(-1) + m_B^(-1)) = 0$\
  // \
  // $(Delta v_A dot (m_B^(-1) + m_A^(-1)) - Delta v_"rel" dot m_A^(-1))/(m_A^(-1) + m_B^(-1)) = 0$\
  // \
  // $(- Delta v_"rel" dot m_A^(-1))/(m_A^(-1) + m_B^(-1)) = -Delta v_A$\
  // \
  // $m_A dot Delta v_A + m_B dot (Delta v_"rel" - Delta v_A) = 0$\
  // $m_A dot Delta v_A + m_B dot Delta v_"rel" - m_B dot Delta v_A = 0$\
  // $m_A dot Delta v_A + m_B dot Delta v_"rel" - m_B dot Delta v_A = 0$\

  // $Delta p = (Delta v_("rel", hat(n)))/(m_A^(-1) + m_B^(-1))$
]

#slide[
  == Ütközés a szimulációban
  Ugyan az, mint az előbb bemutatott, csak a testek sebessége és tehetetlensége
  helyett a lokális megfelelőikkel számolunk.
  #let big(x) = $lr(size: #150%, #x)$
  #v(-0.5em)
  $
    v_"loc" = v + omega times (x_J - x)\
    T^(-1)(hat(u)) = hat(u) dot big([
      hat(u) / m +
      big((Theta^(-1) dot big([(x_J - x) times hat(u)])))
      times (x_J - x)
    ])
  $
  A normál irányú sebességváltozás mellett súrlódásból adódó sebességváltozás
  is van.
]

#slide[
  == Ütközés detektálás
  Az ütközési ponto(ka)t és normált még ki kell számolni.


  Gömböknél: #box(baseline: 90%)[$
    d = c_1 - c_2\
    cases(
      c_1 - hat(d) dot r_1 "és" c_2 + hat(d) dot r_2 quad &"ha" |d| <= r_1 + r_2,
      "nincs" quad &"különben"
    )
  $]

  Tetszőleges konvex alakoknál: GJK és EPA
]

#slide[
  = Árnyékok
]
