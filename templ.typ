#let todo = text.with(red)
#let todo_image(content) = rect(width: 5cm, height: 5cm, stroke: red)[
  #v(1fr)
  #todo(content)
  #v(1fr)
]

#let template(
  title: [Cím],
  subtitle: [Alcím],
  author: [Mézga Géza],
  consulent: [Gézga Méza],
  date: [#datetime.today().display()],
  body
) = {
  set text(font: "New Computer Modern", lang: "hu")
  set heading(numbering: "1.")
  set page(paper: "a4", margin: 2.5cm, numbering: "1")
  set outline(indent: auto)
  set ref(supplement: none)

  set outline(fill: repeat[#" . "])

  show outline.entry.where(level: 1): it => strong[
    #v(0.5em)
    #link(it.element.location(), it.body)
    #box(width: 1fr, h(1fr))
    #link(it.element.location(), it.page)
  ]

  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    v(2cm)
    if it.numbering != none {
      text(size: 1.25em)[
        #counter(heading).display(it.numbering)
        #it.supplement
      ]
      v(0.5em)
    }
    text(size: 1.5em)[#it.body]
    v(1.5em)
  }

  show heading: it => {
    it
    v(0.5em)
  }

  page(numbering: none)[
    #align(center)[
      #image("bme_logo_nagy.svg", width: 40%)\
      *Budapesti Műszaki és Gazdaságtudományi Egyetem*\
      Villamosmérnöki és Informatikai Kar\
      Irányítástechnika és Informatika Tanszék
      #v(1fr)
      #text(size: 2em, weight: "bold", title)
      #v(1em)
      #text(size: 1.5em)[#smallcaps(subtitle)]
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
      #date
    ]
  ]
  counter(page).update(1)

  outline()

  set heading(offset: 1)

  set par(justify: true)

  body
}
