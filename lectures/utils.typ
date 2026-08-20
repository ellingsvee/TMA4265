// Shared utilities for the lecture notes.

#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

// Turn a transition probability into Fletcher label content. Supplying Typst
// content (for example `$1/3$`) preserves its formatting; numbers and strings
// are displayed as written.
#let _transition-label(value) = {
  if type(value) == content {
    value
  } else {
    [#value]
  }
}

// A circular layout, with nicer special cases for one and two states.
#let _transition-positions(count, radius) = {
  if count == 1 {
    (((0, 0)),)
  } else if count == 2 {
    ((180deg, radius), (0deg, radius))
  } else {
    let start-angle = if count == 4 { 135deg } else { 90deg }
    range(count).map(i => (start-angle - i * 360deg / count, radius))
  }
}

// Draw the transition diagram of a finite-state, discrete-time Markov chain.
//
// `states` is an array of node labels. `transitions` is a square array of
// rows, with transitions.at(i).at(j) equal to P(i -> j). Numeric zeroes and
// `none` are omitted by default. Probability entries may be numbers, strings,
// or content such as `$1/2$`.
//
// Example:
//   #transition-diagram(
//     ($0$, $1$, $2$),
//     (
//       (0.5, 0.5, 0),
//       ($1/4$, 0.5, $1/4$),
//       (0, 0.5, 0.5),
//     ),
//   )
//
// The layout is automatic. For a diagram needing hand tuning, pass one
// Fletcher coordinate per state through `positions` and, if desired, one
// self-loop direction per state through `loop-angles`.
#let transition-diagram(
  states,
  transitions,
  positions: auto,
  loop-angles: auto,
  radius: auto,
  node-radius: 6.5mm,
  node-fill: white,
  node-stroke: 0.65pt,
  edge-stroke: 0.65pt,
  label-size: 9pt,
  label-sep: 0.45em,
  arrow: "-|>",
  reciprocal-bend: 12deg,
  loop-bend: 125deg,
  show-zero: false,
  probability-format: _transition-label,
) = {
  let count = states.len()

  assert(count > 0, message: "transition-diagram requires at least one state")
  assert(
    transitions.len() == count,
    message: "transition-diagram requires one transition row per state",
  )
  for row in transitions {
    assert(
      row.len() == count,
      message: "each transition row must contain one entry per state",
    )
  }

  let layout-radius = if radius == auto {
    if count <= 2 { 18mm }
    else if count <= 4 { 24mm }
    else { 25mm + (count - 4) * 4mm }
  } else {
    radius
  }

  let node-positions = if positions == auto {
    _transition-positions(count, layout-radius)
  } else {
    assert(
      positions.len() == count,
      message: "positions must contain one coordinate per state",
    )
    positions
  }

  let default-loop-start = if count == 4 { 135deg } else { 90deg }
  let node-loop-angles = if loop-angles == auto {
    if count == 1 {
      (90deg,)
    } else if count == 2 {
      (180deg, 0deg)
    } else {
      range(count).map(i => default-loop-start - i * 360deg / count)
    }
  } else {
    assert(
      loop-angles.len() == count,
      message: "loop-angles must contain one angle per state",
    )
    loop-angles
  }

  diagram(
    node-fill: node-fill,
    node-stroke: node-stroke,
    edge-stroke: edge-stroke,
    label-size: label-size,
    label-sep: label-sep,
    {
      // Stable private names let labels contain arbitrary Typst content.
      for (i, state) in states.enumerate() {
        node(
          node-positions.at(i),
          state,
          name: label("transition-state-" + str(i)),
          shape: "circle",
          radius: node-radius,
        )
      }

      for i in range(count) {
        for j in range(count) {
          let probability = transitions.at(i).at(j)
          let visible = probability != none and (show-zero or probability != 0)

          if visible {
            let from = label("transition-state-" + str(i))
            let to = label("transition-state-" + str(j))
            let edge-label = probability-format(probability)

            if i == j {
              edge(
                from,
                to,
                arrow,
                edge-label,
                bend: loop-bend,
                loop-angle: node-loop-angles.at(i),
              )
            } else {
              let reverse = transitions.at(j).at(i)
              let reverse-visible = reverse != none and (show-zero or reverse != 0)
              edge(
                from,
                to,
                arrow,
                edge-label,
                bend: if reverse-visible { reciprocal-bend } else { 0deg },
              )
            }
          }
        }
      }
    },
  )
}
