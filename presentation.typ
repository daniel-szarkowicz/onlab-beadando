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

  Tetszőleges konvex alakoknál: GJK és EPA.

  Optimalizálni kell, mert az összes párosítást tesztelni lassú.
]

#slide[
  = Árnyékok
  Árnyék: fény hiánya

  Akkor látunk árnyékot, ha a megfigyelt felület és a fény között
  van valami.

  #alternatives-cases(position: top, ("2", "3", "4", "5", "6-"), case => {
    [
      #show: it => if case >= 3 {
        strike(it)
      } else {
        it
      }
      Ray tracing]
    if case >= 1 [ (lassú#if case >= 2 [, nehéz implementálni])]
    if case == 4 [

      Shadow mapping
    ]
  })
]

#slide[
  == Shadow mapping
  #grid(columns: (2fr, 1fr), gutter: 1em)[
    Amit a fény "lát", az meg van világítva.

    Először kirajzoljuk a világ távolságát a fény szemszögéből.

    Amikor a kamera szemszögéből rajzolunk, akkor minden pixelnél megnézzük,
    hogy a fény látja-e.

    Problémák: pixeles, hirtelen átmenet.
  ][
    #image("pixelated_edges_cropped.png")
  ]
]

#slide[
 == PCF
  #grid(columns: (2fr, 1fr), gutter: 1em)[
    Számoljuk ki az árnyékoltságot a környező pixelekre is.

    Az árnyék intenzitása ezeknek az átlaga lesz.

    Eredmény: az árnyék szélén szép átmenet van.
  ][
    #image("pcf_cropped.png")
  ]
]

#slide[
  == CSM
  #grid(columns: (3fr, 2fr), gutter: 1em)[
    Használjunk több depth buffert.

    Közelre jobb pixel sűrűség, távolra nagyobb lefedettség.

    Használható a legtöbb shadow mapping technikával.
  ][
    #image("csm_cropped.png")
  ]
]

#slide[
  = Implementáció és eredmények

  Rust + OpenGL

  1000+ kocka valós időben

  10000+ kocka nem valós időben, de előre lehet számolni és a visszajátszás
  "valós idejű"

  Demó?
]

#page(margin: 0pt)[
  #image("wrecking_ball.png")
  #image("carpet_bomb.png")
]

#slide[
  == Bővítési lehetőségek

  Fizika és rajzolás külön szálakon

  Ütközés detektálás több szálon

  R-Tree optimalizálás (R\*-Tree, bulk loading)

  Több részből álló testek, jointok
]

#slide[
  #align(horizon + center)[= Köszönöm a figyelmet!]

  #align(bottom)[
    #set text(size: 0.5em)
    #let truncurl(url) = {
      layout(size => {
        let maxwidth = size.width
        if measure(url).width > maxwidth {
          let len = url.len()
          while measure[#url.slice(0, len)...].width > maxwidth {
            len -= 1
          }
          link(url)[#url.slice(0, len)...]
        } else {
          link(url)
        }
      })
    }
    Források:
    - #truncurl("https://www.cs.cmu.edu/~baraff/sigcourse/notesd1.pdf")
    - #truncurl("https://www.cs.cmu.edu/~baraff/sigcourse/notesd2.pdf")
    - #truncurl("https://learnopengl.com/Advanced-Lighting/Shadows/Shadow-Mapping")
    - #truncurl("https://developer.nvidia.com/gpugems/gpugems2/part-ii-shading-lighting-and-shadows/chapter-17-efficient-soft-edged-shadows-using")
    - #truncurl("https://developer.download.nvidia.com/SDK/10.5/opengl/src/cascaded_shadow_maps/doc/cascaded_shadow_maps.pdf")
  ]
]

