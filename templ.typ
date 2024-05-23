#let template(
  title: [Cím],
  subtitle: none,
  author: [Mézga Géza],
  consulent: [Gézga Méza],
  body
) = {
  set text(font: "New Computer Modern", lang: "hu")
  set heading(numbering: "1.")
  set page(paper: "a4", margin: 2.5cm, numbering: "1")
  set outline(indent: true)

  show outline.entry.where(level: 1): it => {
    set outline(fill: none)
    strong[
      #link(it.element.location(), it.body)
      #box(width: 1fr, repeat[ ])
      #link(it.element.location(), it.page)
    ]
  }

  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    if it.numbering != none {
      text(size: 1.5em)[
        #counter(heading).display(it.numbering)
        #it.supplement
      ]
      v(0.5em)
    }
    text(size: 1.75em)[#it.body]
    v(0.5em)
  }

  page(numbering: none)[
    #align(center)[
      #image("BMElogo.png", width: 40%)\
      *Budapesti Műszaki és Gazdaságtudományi Egyetem*\
      Villamosmérnöki és Informatikai Kar\
      Irányítástechnika és Informatika Tanszék
      #v(1fr)
      #text(size: 2em, weight: "bold", title)
      #v(1em)
      #if subtitle != none [
        #text(size: 1.5em)[#smallcaps(subtitle)]
      ]
      #v(1fr)
      #grid(columns: (1fr, 1fr),
        [
          _Készítette_\
          #author
        ],
        [
          _Konzulens_\
          #consulent
        ]
      )
      #v(1fr)
      #datetime.today().display()
    ]
  ]
  counter(page).update(1)

  outline()

  body
}
