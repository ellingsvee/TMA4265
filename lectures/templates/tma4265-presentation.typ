/**
 * ICML-inspired presentation template.
 *
 * This keeps the existing local `presentation` template's Touying/simple
 * layout and helpers, while sharing the font, theorem environments, and
 * author conventions of the accompanying TMA4265 notes template.
 *
 * A presentation is initialized in one place:
 *
 *   #show: icml-presentation.with(
 *     font-size: 20pt,
 *   )
 *
 *   #title-slide[
 *     #text(size: 1.55em, weight: "bold")[A title]
 *   ]
 */

// Presentation machinery retained from the previous local template.
#import "@preview/touying:0.6.1": *
#import "@preview/subpar:0.2.2"
#import "@preview/muchpdf:0.1.2": muchpdf
#import "@preview/showybox:2.0.4": showybox
#import "@preview/herodot:0.4.0": *

// Shared conveniences (`tc`, `cmd`, colors, and subpar) used by the notes.
#import "tma4265-shared.typ": *

// Reuse the actual ICML definitions instead of maintaining a second,
// presentation-only copy that could drift from the lecture notes.
#import "tma4265-notes.typ" as icml-notes

// Re-export the theorem interface of the notes template. This makes
// `#definition`, `#theorem`, `#problem`, `#solution`, ... work identically in
// notes and slides.
#let corollary = icml-notes.corollary
#let proposition = icml-notes.proposition
#let lemma = icml-notes.lemma
#let theorem = icml-notes.theorem
#let definition = icml-notes.definition
#let remark = icml-notes.remark
#let proof = icml-notes.proof
#let assumption = icml-notes.assumption
#let problem = icml-notes.problem
#let solution = icml-notes.solution

#let thm-styling = icml-notes.thm-styling
#let thm-rule = icml-notes.thm-rule
#let thm-rule-aux = icml-notes.thm-rule-aux
#let problem-rule = icml-notes.problem-rule
#let solution-rule = icml-notes.solution-rule
#let problem-numbering = icml-notes.problem-numbering
#let lemmify = icml-notes.lemmify
#let eq = icml-notes.eq

// Expose the shared font stack explicitly for local customization. The local
// installation contains its primary face, so using that face by default also
// avoids warnings about unavailable fallback fonts.
#let font-family = icml-notes.font-family

// The blue already used by the previous presentation template.
#let icml-blue = rgb("#00509e")

// Re-export the simple-theme interface. The local `title-slide` wrapper also
// resets the heading counter after the opening slide, so authors can use the
// convenient `#title-slide[= Title]` syntax without shifting theorem numbers.
#let simple-theme = themes.simple.simple-theme
#let slide = themes.simple.slide
#let centered-slide = themes.simple.centered-slide
#let new-section-slide = themes.simple.new-section-slide
#let focus-slide = themes.simple.focus-slide
#let title-slide(config: (:), body) = themes.simple.title-slide(
  config: config,
  [
    // Touying turns a heading used here into a link target. Keep the opening
    // title neutral instead of inheriting the document's blue link color.
    #show link: set text(fill: black)
    #body
    #counter(heading).update(0)
  ],
)

/// Scale content down only when it is too tall for the normal slide body.
#let fit(body) = {
  utils.fit-to-height(18em)[
    #body
  ]
}

/// A lightly colored box retained from the previous presentation template.
/// Its accent may now be kept in sync with a custom presentation color.
#let contentbox(title: none, primary: icml-blue, body) = {
  context {
    showybox(
      frame: (
        border-color: primary,
        title-color: primary.lighten(82%),
        body-color: primary.lighten(95%),
      ),
      ..(
        if title != none {
          (
            title: title,
            title-style: (
              color: black,
              weight: "bold",
              align: left,
            ),
          )
        } else {
          ()
        }
      ),
      shadow: (offset: 0pt),
      body,
    )
  }
}

// The ICML theorem counters still use numbered heading data internally. These
// two renderers deliberately omit those numbers from section and slide titles.
#let _unnumbered-section-slide(config: (:), body) = centered-slide(config: config, [
  #text(
    size: 1.2em,
    weight: "bold",
    utils.display-current-heading(level: 1, numbered: false),
  )

  #body
])

#let _unnumbered-subslide-preamble = block(
  below: 1.5em,
  text(
    size: 1.2em,
    weight: "bold",
    utils.display-current-heading(level: 2, numbered: false),
  ),
)

/**
 * Initialize an ICML-inspired presentation.
 *
 * This function applies the common styling and environments. Title slides are
 * intentionally written explicitly with `#title-slide[...]`, just as in the
 * previous presentation template.
 */
#let icml-presentation(
  bibliography: none,
  bibliography-title: [References],
  primary: icml-blue,
  header: none,
  header-right: none,
  footer: none,
  footer-right: auto,
  font: font-family.first(),
  font-size: 20pt,
  language: "en",
  raw-lang: "bash",
  link-color: rgb(0%, 8%, 45%),
  cover-alpha: 75%,
  aspect-ratio: "16-9",
  body,
) = {
  // `auto` keeps Touying's slide-number footer. Any explicit value replaces
  // it, matching how the rest of the theme arguments behave.
  let footer-right-arg = if footer-right == auto {
    (:)
  } else {
    (footer-right: footer-right)
  }

  show: simple-theme.with(
    aspect-ratio: aspect-ratio,
    header: header,
    header-right: header-right,
    footer: footer,
    primary: primary,
    subslide-preamble: _unnumbered-subslide-preamble,
    ..footer-right-arg,
    config-page(
      margin: (x: 3em, y: 1.5em),
    ),
    config-common(
      breakable: false,
      clip: true,
      new-section-slide-fn: _unnumbered-section-slide,
    ),
    config-methods(cover: utils.semi-transparent-cover.with(alpha: cover-alpha)),
  )

  // Typography and small conventions shared with the notes.
  set text(font: font, size: font-size, lang: language)
  // Lemmify needs numbered heading data to derive theorem numbers. The show
  // rule and Touying renderers suppress those numbers in the visible output.
  set heading(numbering: "1.")
  show heading: it => text(fill: black, weight: "bold", it.body)
  set raw(lang: raw-lang)
  show link: set text(fill: link-color)
  set align(horizon)

  // Number only equations that have labels, as in the notes template.
  set math.equation(numbering: "(1)")
  show math.equation: it => {
    if it.block and not it.has("label") and it.numbering != none {
      counter(math.equation).update(value => value - 1)
      math.equation(it.body, block: true, numbering: none)
    } else {
      it
    }
  }

  // Keep the previous presentation template's block-code treatment.
  show raw.where(block: true): block.with(
    fill: fill-color.darken(5%),
    inset: (x: 3pt, y: 2pt),
    outset: (x: 0pt, y: 3pt),
    radius: 2pt,
    width: 100%,
  )

  // Activate precisely the same theorem/problem rules as `icml.with(...)`.
  show: thm-rule
  show: thm-rule-aux
  show: icml-notes.thm-reset-counter-heading.with("problem-group", 1)
  show: problem-rule
  show: solution-rule

  body

  if bibliography != none {
    // Touying splits slides by heading depth; setting `depth` explicitly is
    // required for a heading created programmatically inside this wrapper.
    heading(depth: 2, bibliography-title)
    {
      show std.bibliography: set text(size: 0.62em)
      set std.bibliography(title: none)
      bibliography
    }
  }
}

// Familiar short name for users of the previous presentation template.
#let presentation = icml-presentation
