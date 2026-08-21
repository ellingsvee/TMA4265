// Import dependencies.
// #import "@preview/rich-counters:0.2.1": *
// #import "@preview/algorithmic:1.0.7"
// #import algorithmic: algorithm-figure, style-algorithm
// The former `mathblocks` import is intentionally disabled.
#import "@preview/subpar:0.2.2"


// Needed to get live preview working
// Typst should now support this natively, but for some reason it doesn't work without this import.
// #import "@preview/muchpdf:0.1.2": muchpdf
// #let pdfimage(path, ..kwargs) = muchpdf(read(path, encoding: none), ..kwargs)

// Colors used across packages.
#let stroke-color = luma(200)
#let fill-color = luma(250)


// // Theorem environment.
// #let mathcounter = rich-counter(
//   identifier: "mathblocks",
//   inherited_levels: 2,
// )
//
// #let definition = mathblock(
//   blocktitle: "Definition",
//   counter: mathcounter,
// )
//
//
// #let proof = proofblock()
//
// #let theorem = mathblock(
//   blocktitle: "Theorem",
//   counter: mathcounter,
//   proof: proof,
// )
//
// #let exercise = mathblock(
//   blocktitle: "Exercise",
//   // counter: mathcounter,
// )
//
// #let lemma = mathblock(
//   blocktitle: "Lemma",
//   counter: mathcounter,
//   proof: proof,
// )
//
// #let corollary = mathblock(
//   blocktitle: "Corollary",
//   counter: mathcounter,
//   proof: proof,
// )
//
// #let remark = mathblock(
//   blocktitle: "Remark",
//   prefix: [_Remark._],
// )
//
// #let proposition = mathblock(
//   blocktitle: "Proposition",
//   counter: mathcounter,
//   proof: proof,
// )
//
// #let example = mathblock(
//   blocktitle: "Example",
//   counter: mathcounter,
// )
//

// Utility functions.
// #let py(body) = raw(body, lang: "python")
#let cmd(body) = raw(body, lang: "bash")

// Prose citation.
#let tc(body) = cite(body, form: "prose")

// // Configure equation numbering (only number labeled equations).
// #show math.equation: it => {
//   if it.block and not it.has("label") and it.numbering != none [
//     #counter(math.equation).update(v => v - 1)
//     #math.equation(it.body, block: true, numbering: none)
//   ] else {
//     it
//   }
// }
// //
