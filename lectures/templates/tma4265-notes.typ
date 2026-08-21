/**
 * lib.typ
 *
 * International Conference on Machine Learning (ICML) template.
 *
 * Based on the `lucky-icml` template by Daniel Bershatsky
 * (https://github.com/daskol/typst-templates), consolidated into a single
 * `icml` styling rule and extended with a few conveniences:
 *
 *   - `n_columns`    : 2 (standard ICML) or 1 (single full-width column).
 *   - `paper-size`   : "us-letter" (default) or "a4".
 *   - `line-numbers` : render the review-style line numbers in the left
 *                      margin. Off by default; set to `true` to opt in.
 *
 * Everything (title, authors, abstract, settings, ...) is initialized in one
 * place with `#show: icml.with(...)`.
 */

#import "tma4265-shared.typ": *
#import "tma4265-icml-logo.typ": LaTeX, TeX

// ---------------------------------------------------------------------------
// Constants and definitions.
// ---------------------------------------------------------------------------

// Metrical size of the page body. ICML mandates a 6.75in x 9.0in text block.
#let body-size = (
  width: 6.75in,
  height: 9.0in,
)

// Default font sizes from the original LaTeX style file.
#let font-defaults = (
  tiny: 6pt,
  scriptsize: 7pt,
  footnotesize: 9pt,
  small: 9pt,
  normalsize: 10pt,
  large: 12pt,
  Large: 14pt,
  LARGE: 17pt,
  huge: 20pt,
  Huge: 25pt,
)

// We prefer to use Times New Roman whenever it is possible.
#let font-family = ("Times New Roman", "Nimbus Roman", "TeX Gyre Termes")

#let font = (
  Large: font-defaults.Large + 0.4pt, // Actual font size.
  footnote: font-defaults.footnotesize,
  large: font-defaults.large,
  small: font-defaults.small,
  normal: font-defaults.normalsize,
  script: font-defaults.scriptsize,
)

// Table rulers (thicknesses taken from booktabs).
#let toprule = table.hline(stroke: (thickness: 0.08em))
#let bottomrule = toprule
#let midrule = table.hline(stroke: (thickness: 0.05em))

// Default public notice. Override via `aux.public-notice` if needed.
#let public-notice = [
  _Proceedings of the 42#super[nd] International Conference on Machine
    Learning_, Vancouver, Canada. PMLR 267, 2025. Copyright 2025 by the
  author(s).
]

#let arxiv-notice = []

#let anonymous-notice = [
  Preliminary work. Under review by the International Conference on Machine
  Learning (ICML). Do not distribute.
]

#let anonymous-author = (
  name: "Anonymous Author",
  email: "anon.email@example.org",
  affl: ("anonymous-affl",),
)

#let anonymous-affl = (
  department: none,
  institution: "Anonymous Institution",
  location: "Anonymous City, Anonymous Region",
  country: "Anonymous Country",
)

// ---------------------------------------------------------------------------
// Helper routines.
// ---------------------------------------------------------------------------

#let make_figure_caption(it) = {
  set text(size: font.small)
  set par(justify: true)
  layout(size => {
    let caption-body = {
      emph({
        it.supplement
        if it.numbering != none {
          [ ]
          it.counter.display(it.numbering)
        }
        it.separator
      })
      [ ]
      it.body
    }
    // Center short captions (e.g. the main caption of a `subpar` grid, which
    // otherwise sits flush-left under the plots) but keep long, multi-line
    // captions left-aligned and justified as ICML expects.
    let fits = measure(caption-body).width < size.width
    block(width: 100%, align(if fits { center } else { left }, caption-body))
  })
}

#let make_figure(caption_above: false, it) = {
  place(center + top, float: true, block(breakable: false, width: 100%, {
    // Sub-captions produced by `subpar` bypass `make_figure_caption` and would
    // otherwise inherit the 10pt body size, rendering *larger* than the main
    // caption. Drop the figure body to the caption size so sub-captions match.
    set text(size: font.small) if it.kind == image
    if caption_above {
      it.caption
    }
    v(0.1in, weak: true)
    it.body
    v(0.1in, weak: true)
    if not caption_above {
      it.caption
    }
  }))
}

#let make-author(author, affl2idx) = {
  // Sanitize author affiliations (they are optional).
  let affl = author.at("affl", default: ())
  if type(affl) == str {
    affl = (affl,)
  }

  // Make a list of superscript indices.
  let indices = affl.map(it => str(affl2idx.at(it)))
  let has-equal-contrib = author.at("equal", default: false)
  if has-equal-contrib {
    indices.insert(0, "*")
  }

  // Render author and affiliation references to content. Authors without any
  // affiliation/equal mark get no (empty) superscript.
  set text(size: font.normal, weight: "regular")
  if indices.len() == 0 {
    strong(author.name)
  } else {
    strong(author.name) + super(typographic: false, indices.join(" "))
  }
}

#let make-affilations-and-notice(authors, affls) = {
  let info = ()

  // Add equal contribution notice.
  let has-equal-contrib = authors.fold(false, (acc, it) => {
    let equal-contrib = it.at("equal", default: false)
    return acc or equal-contrib
  })
  if has-equal-contrib {
    info.push(super[\*] + [Equal contribution])
  }

  // Prepare list of affiliations.
  let ordered-affls = authors.map(it => it.at("affl", default: ())).flatten().dedup()
  let affilations = ordered-affls
    .enumerate(start: 1)
    .map(pair => {
      let (ix, it) = pair
      let affl = affls.at(it, default: none)
      assert(affl != none, message: "unknown affilation: " + it)

      // Convert structured affiliation representation to plain one (array).
      if type(affl) == dictionary {
        let keys = ("department", "institution", "location", "country")
        let parts = ()
        for key in keys {
          let val = affl.at(key, default: none)
          if val != none {
            parts.push(val)
          }
        }
        affl = parts
      }

      // Validate affiliation representation.
      assert(type(affl) == array, message: "wrong affilation type: " + str(type(affl)))
      assert(affl.len() > 0, message: "empty affilation: " + it + " :" + repr(affl))

      // Finally, join parts of affiliation.
      return super(str(ix)) + affl.join(", ")
    })
  if affilations != () {
    info.push(affilations.join([ ]) + [.])
  }

  // Prepare list of corresponding authors (those with an email).
  let correspondents = authors.fold((), (acc, it) => {
    let email = it.at("email", default: none)
    if email != none {
      let mailto = link("mailto:" + it.email, it.email)
      acc.push([#it.name \<#mailto\>])
    }
    return acc
  })
  if correspondents != () {
    info.push([Correspondence to: ] + correspondents.join(", ") + [.])
  }

  return info
}

// ---------------------------------------------------------------------------
// Line numbers (review style).
// ---------------------------------------------------------------------------

// Zero-pad a line number to (at least) three digits, matching the original
// template's appearance (001, 002, ..., 010, ..., 100, ...).
#let itoa(val) = {
  if val > 99 {
    return str(val)
  } else if val > 9 {
    return "0" + str(val)
  } else {
    return "00" + str(val)
  }
}

// Standalone vertical ruler for the left margin. Kept for manual control; the
// `line-numbers` flag of `icml` uses the automatic variant below.
#let vruler(page: 0, offset: 0pt, fill: none) = {
  let count = 55
  let numbers = range(page * count, (page + 1) * count)
  let content = numbers.map(it => itoa(it)).join([ \ ])
  let sidebar = block(width: 15pt, height: 9in, fill: fill)[
    #set text(fill: rgb(70%, 70%, 70%))
    #set par(leading: 5.2pt)
    #align(right, content)
  ]
  return place(
    top,
    sidebar,
    dx: -30pt,
    dy: offset,
    float: false,
  )
}

// Automatic line numbers drawn into the page background. Each page shows
// `count` evenly-spaced numbers down the left margin, continuing across pages.
#let line-number-background = context {
  let count = 55
  let p = here().page() - 1
  let step = body-size.height / count
  let numbers = ()
  for i in range(count) {
    let n = p * count + i + 1
    numbers.push(place(
      top + left,
      dx: 0pt,
      dy: 1.0in + i * step,
      box(
        width: 0.65in,
        align(right, text(size: font.script, fill: rgb(60%, 60%, 60%), itoa(n))),
      ),
    ))
  }
  numbers.join()
}

// ---------------------------------------------------------------------------
// Theorem environments (lemmify), styled the ICML way.
//
// Defined before `icml` so the styling rule can activate them itself (Typst
// has no forward references for module-level bindings).
// ---------------------------------------------------------------------------

#import "@preview/lemmify:0.1.7": default-theorems, new-theorems, thm-numbering-heading, thm-reset-counter-heading

#let thm-styling(
  thm-type,
  name,
  number,
  body,
) = block(width: 100%, breakable: true, {
  set align(left)
  let thm-label = if type(thm-type) == str {
    thm-type
  } else {
    thm-type.text
  }.trim()
  let has-number = number != none and number != []
  let label = if has-number {
    thm-label + " " + number + "."
  } else {
    thm-label + "."
  }
  if thm-label == "Solution" and not has-number {
    emph("Solution.") + " "
  } else if thm-type in ("Remark", "Solution") {
    emph(label) + " "
  } else {
    strong(label) + " "
  }
  if name != none {
    emph[(#name)] + " "
  }
  if thm-type in ("Corollary", "Proposition", "Lemma", "Theorem", "Solution") {
    emph(body)
  } else {
    body
  }
})

#let (
  corollary,
  proposition,
  lemma,
  theorem, // strong + emph
  definition, // strong + plain
  remark, // emph + plain
  proof,
  example,
  rules: thm-rule,
) = default-theorems(
  "thm-group",
  thm-styling: thm-styling,
  thm-numbering: thm-numbering-heading.with(max-heading-level: 1),
)

#let (assumption, rules: thm-rule-aux) = new-theorems(
  "thm-group",
  ("assumption": "Assumption"),
  thm-styling: thm-styling,
  thm-numbering: thm-numbering-heading.with(max-heading-level: 1),
)

#let problem-numbering = thm-numbering-heading.with(max-heading-level: 1)

#let unnumbered-numbering(fig) = none

#let (problem, rules: problem-rule) = new-theorems(
  "problem-group",
  ("problem": "Problem"),
  thm-styling: thm-styling,
  thm-numbering: problem-numbering,
)

#let (solution, rules: solution-rule) = new-theorems(
  "solution-group",
  ("solution": "Solution"),
  thm-styling: thm-styling,
  thm-numbering: unnumbered-numbering,
)

// Manual activator, kept for completeness. `icml` already activates these
// rules, so authors normally do NOT need `#show: lemmify`.
#let lemmify(body) = {
  show: thm-rule
  show: thm-rule-aux
  show: thm-reset-counter-heading.with("problem-group", 1)
  show: problem-rule
  show: solution-rule
  body
}

// ---------------------------------------------------------------------------
// The `icml` styling rule.
// ---------------------------------------------------------------------------

/**
 * icml
 *
 * Args:
 *   title: The paper's title as content.
 *   authors: A pair `(authors, affls)` where `authors` is an array of author
 *     dictionaries (keys: name, affl, email, equal) and `affls` is a
 *     dictionary mapping affiliation keys to their description.
 *   abstract: The content of a brief summary of the paper, or none.
 *   bibliography: The result of a call to the `bibliography` function or none.
 *   accepted: Controls the author block and bottom notice. The default `none`
 *     produces a plain preprint/personal version: real authors are shown and
 *     no notice is printed. Set `false` for an anonymized double-blind ICML
 *     submission ("Preliminary work. Under review..."), or `true` for the
 *     camera-ready version (with the PMLR copyright notice).
 *   n_columns: Number of text columns: 2 (standard ICML) or 1 (single column).
 *   paper-size: "us-letter" (default) or "a4".
 *   line-numbers: Render review-style line numbers in the left margin.
 *   aux: Knobs for adjustments, e.g. `public-notice` or `font-family`.
 */
#let icml(
  title: [],
  authors: (),
  keywords: (),
  date: auto,
  abstract: none,
  bibliography: none,
  header: none,
  appendix: none,
  accepted: none,
  n_columns: 2,
  paper-size: "us-letter",
  line-numbers: false,
  aux: (:),
  body,
) = {
  assert(
    n_columns in (1, 2),
    message: "n_columns must be 1 or 2",
  )
  assert(
    paper-size in ("us-letter", "a4"),
    message: "paper-size must be \"us-letter\" or \"a4\"",
  )

  if header == none {
    header = title
  }

  // Allow customization of public notice.
  let public-notice = if "public-notice" in aux {
    aux.public-notice
  } else {
    public-notice
  }

  // Sanitize authors and affiliations arguments.
  //
  // `authors` may be supplied either in the full ICML form -- a pair
  // `(array-of-authors, affls-dict)` -- or as a plain array of author
  // dictionaries with no affiliations (e.g. `((name: "Jane Doe"),)`).
  // For an anonymous submission (`accepted: false`) the authors are replaced
  // by an anonymous placeholder regardless of what was passed.
  let (authors, affls) = if accepted != none and not accepted {
    ((anonymous-author,), (anonymous-affl: anonymous-affl))
  } else if authors.len() == 2 and type(authors.at(0)) == array {
    authors
  } else {
    (authors, (:))
  }

  // Configure document metadata.
  set document(
    title: title,
    author: authors.map(it => it.name),
    keywords: keywords,
    date: date,
  )

  // Prepare affiliation and notice footnote.
  let contrib-info = make-affilations-and-notice(authors, affls)
  let notice = if accepted == none {
    arxiv-notice
  } else if accepted {
    public-notice
  } else {
    anonymous-notice
  }
  // Only emit the footnote if there is something to show; otherwise we would
  // be left with a stray horizontal rule (e.g. a preprint with no affiliations).
  let has-footnote = contrib-info != () or notice != []
  let make-contribs() = {
    set text(size: font.small)
    set par(leading: 0.5em, justify: true)
    line(length: 0.8in, stroke: (thickness: 0.05em))
    block(spacing: 0.45em, width: 100%, {
      // Footnote line.
      h(1.2em) // BUG: https://github.com/typst/typst/issues/311
      if contrib-info != () {
        contrib-info.join([ ])
        parbreak()
      }
      notice
    })
  }

  // Prepare authors and footnote anchors.
  let ordered-affls = authors.map(it => it.at("affl", default: ())).flatten().dedup()
  let affl2idx = ordered-affls
    .enumerate(start: 1)
    .fold((:), (acc, it) => {
      let (ix, affl) = it
      acc.insert(affl, ix)
      return acc
    })
  let make-authors() = authors.map(it => make-author(it, affl2idx))

  // Page geometry. The text block is fixed at 6.75in x 9.0in with a 0.75in
  // left and 1.0in top margin; the remaining margins follow from the paper.
  let page-width = if paper-size == "a4" { 210mm } else { 8.5in }
  let page-height = if paper-size == "a4" { 297mm } else { 11in }
  set page(
    paper: paper-size,
    margin: (
      left: 0.75in,
      right: page-width - (0.75in + body-size.width),
      top: 1.0in,
      bottom: page-height - (1.0in + body-size.height),
    ),
    columns: n_columns,
    background: if line-numbers { line-number-background } else { none },
    header-ascent: 10pt,
    header: context {
      // The first page is a title page. It does not have a running header.
      let pageno = counter(page).get().first()
      if pageno == 1 {
        return
      }

      // Render running title since the second page.
      set align(center)
      set text(size: font.footnote, weight: "bold")
      block(spacing: 0pt, fill: none, {
        set block(spacing: 0em)
        text(size: font.small, header)
        v(3.5pt) // By default, fancyhdr spaces 4pt.
        line(length: 100%, stroke: (thickness: 1pt))
      })
    },
    footer-descent: 25pt - font.normal,
    footer: context {
      let i = counter(page).get().first()
      align(center, text(size: font.normal, [#i]))
    },
  )
  set columns(gutter: 0.25in)

  // Main body font is Times (Type-1) font.
  let font-family = if "font-family" in aux {
    aux.font-family
  } else {
    font-family
  }
  set par(justify: true, leading: 0.58em)
  set text(font: font-family, size: font.normal)

  set heading(numbering: "1.")
  show heading: it => {
    // Create the heading numbering.
    let number = if it.numbering != none {
      counter(heading).display(it.numbering)
    }

    set align(left)
    if it.level == 1 {
      text(size: font.large, weight: "bold")[
        #v(0.25in, weak: true)
        #number
        *#it.body*
        #v(0.15in, weak: true)
      ]
    } else if it.level == 2 {
      text(size: font.normal, weight: "bold")[
        #v(0.2in, weak: true)
        #number
        *#it.body*
        #v(0.13in, weak: true)
      ]
    } else if it.level == 3 {
      text(size: font.normal, weight: "regular")[
        #v(0.18in, weak: true)
        #number
        #smallcaps(it.body)
        #v(0.1in, weak: true)
      ]
    }
  }

  set figure.caption(separator: [.])
  show figure: set block(breakable: false)
  show figure.caption.where(kind: table): it => make_figure_caption(it)
  show figure.caption.where(kind: image): it => make_figure_caption(it)
  show figure.where(kind: image): it => make_figure(it)
  show figure.where(kind: table): it => make_figure(it, caption_above: true)

  // Configure numbered lists.
  set enum(indent: 1.4em, spacing: 0.9em)
  show enum: set block(above: 1.63em)

  // Configure bullet lists.
  set list(indent: 1.4em, spacing: 0.9em, marker: ([•], [‣], [⁃]))
  show list: set block(above: 1.63em)

  // Math equation numbering and referencing.
  set math.equation(numbering: "(1)")
  // Only number block equations that carry a label (i.e. ones that can be
  // referenced). Unlabelled equations are rendered without a number, and the
  // equation counter is rolled back so labelled equations stay sequential.
  show math.equation: it => {
    if it.block and not it.has("label") and it.numbering != none {
      counter(math.equation).update(v => v - 1)
      math.equation(it.body, block: true, numbering: none)
    } else {
      it
    }
  }
  show ref: it => {
    let eq = math.equation
    let el = it.element
    if el != none and el.func() == eq {
      let numb = numbering(
        "1",
        ..counter(eq).at(el.location()),
      )
      let color = rgb(0%, 8%, 45%) // Originally `mydarkblue`. :D
      let content = link(el.location(), text(fill: color, numb))
      [(#content)]
    } else if el != none and el.func() == heading {
      let numb = numbering(
        el.numbering,
        ..counter(el.func()).at(el.location()),
      )
      if numb.at(-1) == "." {
        numb = numb.slice(0, -1)
      }
      let color = rgb(0%, 8%, 45%) // Originally `mydarkblue`. :D
      let content = text(fill: color, numb)
      // If numbering starts with a letter then the heading is an appendix.
      let supplement = el.supplement
      if numb.at(0) not in ("0", "1", "2", "3", "4", "5", "6", "7", "8", "9") {
        supplement = [Appendix]
      }
      link(el.location())[#supplement~#content]
    } else if el != none and el.func() == figure {
      let numb = numbering(
        el.numbering,
        ..counter(figure.where(kind: el.kind)).at(el.location()),
      )
      if numb.at(-1) == "." {
        numb = numb.slice(0, -1)
      }
      let color = rgb(0%, 8%, 45%) // Originally `mydarkblue`. :D
      let content = text(fill: color, numb)
      link(el.location())[#el.supplement~#content]
    } else {
      // Citations and any other references render as usual.
      it
    }
  }

  // Configure algorithm rendering.
  counter(figure.where(kind: "algorithm")).update(0)
  show figure.caption.where(kind: "algorithm"): it => block(width: 100%, {
    set align(left)
    context { strong[#it.supplement #it.counter.display(it.numbering)] }
    [ ]
    it.body
  })
  show figure.where(kind: "algorithm"): it => {
    let render() = block(breakable: false, width: 100%, {
      set block(spacing: 0em)
      line(length: 100%, stroke: (thickness: 0.08em))
      block(spacing: 0.4em, it.caption) // NOTE: No idea why we need it.
      line(length: 100%, stroke: (thickness: 0.05em))
      it.body
      line(length: 100%, stroke: (thickness: 0.08em))
    })
    if it.placement == none {
      render()
    } else {
      place(it.placement, float: true, render())
    }
  }

  place(top + center, float: true, scope: "parent", {
    // Render title.
    {
      set align(center)
      set par(spacing: 18pt)
      set text(size: font.Large, weight: "bold")
      v(0.5pt)
      line(length: 100%)
      v(1pt)
      title
      v(1pt)
      line(length: 100%)
    }

    v(0.1in - 1pt)

    // Render authors.
    {
      set align(center)
      make-authors()
        .map(it => {
          box(inset: (left: 0.5em, right: 0.5em), it)
        })
        .join()
    }
  })

  v(0.2in)

  {
    set text(size: font.normal)
    set par(spacing: 11pt)
    // Render abstract (only when one is provided).
    // ICML instruction tells that font size of `Abstract` must equal 11 but
    // it does not look like so.
    if abstract != none {
      align(center, text(size: font.large, [*Abstract*]))
      pad(left: 2em, right: 2em, abstract)
      v(0.12in)
    }

    // Place contribution and notice at the bottom of the first column.
    if has-footnote {
      place(bottom, float: true, clearance: 0.5em, {
        set block(spacing: 0pt)
        make-contribs()
      })
    }

    // Display body. Activate the theorem environments (lemmify) so that
    // `#theorem`, `#problem`, ... render their labels automatically, with no
    // need for the author to add `#show: lemmify` themselves.
    show: thm-rule
    show: thm-rule-aux
    show: thm-reset-counter-heading.with("problem-group", 1)
    show: problem-rule
    show: solution-rule
    set text(size: font.normal)
    body

    // Display the bibliography, if any is given.
    if bibliography != none {
      show std.bibliography: set text(size: font.normal)
      set std.bibliography(title: "References", style: "icml.csl")
      bibliography
    }
  }

  if appendix != none {
    set page(columns: 1)
    pagebreak(weak: true)
    counter(heading).update(0)
    counter("appendices").update(1)
    set heading(
      numbering: (..nums) => {
        let vals = nums.pos()
        let value = "ABCDEFGHIJ".at(vals.at(0) - 1)
        return value + "." + nums.pos().slice(1).map(str).join(".")
      },
    )
    appendix
  }
}

// Helper routine for turning off equation numbering.
#let eq = it => {
  set math.equation(numbering: none)
  it
}

// ---------------------------------------------------------------------------
// Citation helpers.
// ---------------------------------------------------------------------------

#let cite-color = rgb(0%, 8%, 45%)

/**
 * Alternative citing routine.
 */
#let refer(..keys, color: cite-color) = {
  let citations = keys.pos().map(key => cite(key)).join([ ])
  return [(] + text(fill: color, citations) + [)]
}
