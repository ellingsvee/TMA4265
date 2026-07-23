#import "@local/icml:1.0.0": *
#import "@preview/muchpdf:0.1.2": muchpdf

#import "@preview/lemmify:0.1.7": default-theorems, new-theorems, thm-numbering-heading
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#show: icml.with(
  title: [
    Session 1: Markov Chains
  ],

  authors: (
    (
      name: "Elling Svee",
      email: "elling.svee@ntnu.no",
    ),
  ),
  n_columns: 1,
  paper-size: "a4",
  bibliography: bibliography("refs.bib"),
)


= Some relevant theory


For a Markov chain $(X_n)_(n >= 1)$ with state space $(1, dots, m)$, let $bold(pi)_n$ denote the distribution of $X_n$:
$
  bold(pi)_n = mat(
    P(X_n = 1);
    dots.v;
    P(X_n = m);
  ).
$
Thus $X_n$ is the random state at time $n$, while $bold(pi)_n$ is a vector of probabilities.

In these notes we use the convention
$
  P_(i,j) = P(X_(n+1) = j | X_n = i).
$
Hence each row of $bold(upright(P))$ sums to one, and column distribution vectors update by $bold(pi)_(n+1) = bold(upright(P))^top bold(pi)_n$.

#definition(name: "Communicating states")[
  Two states $i$ and $j$ of a Markov chain communicate if they are accessible from each other. If $i$ and $j$ does not communicate, then either
  $
    P_(i j)^((n)) = 0 "for all" n >= 0,
  $
  or
  $
    P_(j i)^((n)) = 0 "for all" n >= 0,
  $
  or both.
]
#definition(name: "Irreducible Markov chain")[
  A Markov chain is irreducible if all states communicate with each other.
]

#definition(name: "Time-homogeneous Markov chain")[
  A Markov chain is time-homogeneous when the one-step transition probabilities do not depend on time. In other words, the transition probability matrix $bold(upright(P))$ is constant over time.
]

#theorem(name: "Unique stationary distribution for finite Markov chains")[
  A finite and irreducible Markov chain has a unique stationary distribution. This means it has a unique probability distribution $bold(pi)$ satisfying
  $
    bold(pi) = bold(upright(P))^top bold(pi)
    quad "with" quad
    sum_i pi_i = 1.
  $
]

#pagebreak()
= Problems


#problem(name: "Exam 2025, Question 1")[
  On any given day Maria is either cheerful (C), so-so (S), or glum (G). If she is cheerful today, then she will be C, S, or G tomorrow with respective probabilities $0.5$, $0.4$, $0.1$. If Maria is feeling so-so today, then she will be C, S, or G tomorrow with probabilities $0.3$, $0.4$, $0.3$. If she is glum today, then she will be C, S, or G tomorrow with probabilities $0.2$, $0.3$, $0.5$. Let $X_n$ denote Maria’s mood on day $n$.
  +
    - Explain that Maria’s mood is a three-state Markov chain.
    - Illustrate with a transition probability graph, and determine the transition probability matrix P.
  +
    - Is the Markov chain irreducible? Are all states communicating with each other?
    - Assume that Maria’s mood at day 27 has a uniform probability distribution. What is the probability that Maria is glum at day 28.
  +
    - Explain that the Markov chain has a unique stationary distribution.
    - How often, on average, is Maria glum?
    - Is it possible that the distribution of $X_1$ equals the distribution of $X_n$ for all $n$?
  + Assume that Maria is cheerful on day 1.
    - What is the probability that Maria is cheerful at day 3?
    - Are $X_1$ and $X_2$ independent random variables?
    - What is the mathematical definition of a stochastic process $X$? Use $X_1, X_2, dots$ to define a stochastic process $X$. What is the probability distribution of $X$ in this particular case?
]
#solution[
  #enum(
    [
      $X_(n+1)$ depends only on $X_n$ by construction, and the probabilities $P_(i,j)$ are constant over time. Thus $(X_n)_(n >= 1)$ is a time-homogeneous Markov chain. With state order $(C, S, G)$, the transition probability matrix becomes
      $
        bold(upright(P)) = mat(
          0.5, 0.4, 0.1;
          0.3, 0.4, 0.3;
          0.2, 0.3, 0.5;
        )
      $
      The rows are today's mood and the columns are tomorrow's mood. The transition graph has directed edges between every pair of states, including self-loops, with these probabilities as edge labels.
    ],
    [
      All entries in $bold(upright(P))$ are positive, so all states communicate with each other and the Markov chain is irreducible. At day 27, the probability distribution is uniform, so $bold(pi)_(27) = (1\/3, 1\/3, 1\/3)^top$. Since distributions are written as column vectors, we multiply by $bold(upright(P))^top$
      $
        bold(pi)_(28) = bold(upright(P))^top bold(pi)_(27) = mat(
          0.5, 0.3, 0.2;
          0.4, 0.4, 0.3;
          0.1, 0.3, 0.5;
        ) mat(
          1\/3;
          1\/3;
          1\/3;
        ) = mat(
          0.3333;
          0.3667;
          0.3;
        )
      $
      Therefore $P(X_(28) = G) = 0.3$.
    ],
    [
      Since the chain is finite and irreducible, it has a unique stationary distribution. This means $bold(pi)$ satisfies $bold(pi) = bold(upright(P))^top bold(pi)$ and $pi_C + pi_S + pi_G = 1$. To find $bold(pi) = (pi_C, pi_S, pi_G)^top$, we solve the system of equations under the normalization constraint. See that
      $
        bold(pi) = bold(upright(P))^top bold(pi) <==> (bold(upright(P))^top - bold(upright(I))) bold(pi) = bold(0),
      $
      and that we have four equations and three unknowns. We can discard one of the equations, and replace it with the normalization constraint. The resulting system is
      $
        mat(
          -0.5, 0.3, 0.2;
          0.4, -0.6, 0.3;
          1, 1, 1;
        ) bold(pi) = mat(
          0;
          0;
          1;
        )
        quad ==> quad
        bold(pi) = mat(
          21\/62;
          23\/62;
          18\/62;
        ).
      $
      Hence Maria is on average glum $18\/62$ of the days. It is possible that the distribution of $X_1$ equals the distribution of $X_n$ for all $n$. This happens when $bold(pi)_1$ equals the stationary distribution $bold(pi)$. Note that this does not neccessarily mean that the realized moods $X_1, X_2, dots$ are all identical.
    ],
    [
      With Maria cheerful on day 1, the probability distribution is $bold(pi)_(1) = (1, 0, 0)^top$. The probability distribution at day 3 is
      $
        bold(pi)_(3) = bold(upright(P))^top bold(pi)_(2) = bold(upright(P))^top bold(upright(P))^top bold(pi)_(1) =bold(upright(P))^top mat(
          0.5;
          0.4;
          0.1;
        )
        = mat(
          0.39;
          0.39;
          0.22
        ).
      $
      Therefore $P(X_(3) = C | X_(1) = C) = 0.39$. Note that we could also have computed this probability by summing over the possible moods at day 2
      $
        P(X_(3) = C | X_(1) = C) = sum_(M in {C, S, G}) P(X_(3) = C | X_(2) = M) P(X_(2) = M | X_(1) = C).
      $
      Consider a mood $M in {C, S, G}$. As $P(X_1 = C) = 1$, we see that
      $
        P(X_2 = M | X_1 = C) = P(X_2 = M , X_1 = C)/ P(X_1 = C) = P(X_2 = M).
      $



    ],
  )]



#pagebreak()
= PageRank as a Markov Chain

== Background

A search engine must decide which web pages are most important, rather than only checking whether they contain a particular search term. PageRank assigns an importance score to each page by using the structure of hyperlinks between pages.

The main idea is to model a person randomly browsing the web. At each step, the person either follows a hyperlink on the current page or jumps to another page. Pages that are visited frequently in the long run receive high PageRank scores.

PageRank was introduced as part of the early Google search engine @brin_anatomy_1998.


== Constructing the Markov Chain

Suppose the web contains $n$ pages. Each page is a state in a Markov chain. Let $d_i$ denote the number of outgoing links from page $i$. The hyperlink transition matrix is

$
  P_(i,j) = cases(
    1 \/ d_i & "if page" i "links to page" j,
    0 & "otherwise",
  ).
$

Thus, when the random surfer is on page $i$, they choose uniformly between its outgoing links.
This is the same row-stochastic convention as above: rows describe the current page and columns describe the next page.

Some pages have no outgoing links. These are called dangling pages. To ensure that every row defines a probability distribution, replace the row of a dangling page by a uniform distribution:

$
  S_(i,j) = cases(
    P_(i,j) & "if" d_i > 0,
    1 \/ n & "if" d_i = 0,
  ).
$

Following hyperlinks alone may produce a reducible or periodic Markov chain. PageRank avoids this by introducing teleportation. Let $alpha in (0, 1)$ be the probability of following a link, and let $v$ be a probability distribution over the pages. Define the PageRank transition matrix by

$
  G_(i,j) = alpha S_(i,j) + (1 - alpha) v_j.
$

Usually, $alpha = 0.85$ and $v_j = 1 \/ n$. Therefore, with probability $alpha$ the surfer follows a link, while with probability $1 - alpha$ they jump to a random page.


== Computing PageRank

The PageRank vector $bold(pi)$ is the stationary distribution of the Markov chain
$
  bold(pi) = bold(upright(G))^top bold(pi)
  quad "with" quad
  sum_(j=1)^n pi_j = 1.
$
Equivalently, each score satisfies
$
  pi_j = sum_(i=1)^n G_(i,j) pi_i .
$

It can be computed using #link("https://piazza.com/class_profile/get_resource/hpgt2g36k9v17k/httjczk11g46od", "power iteration"). Starting from an initial probability distribution $bold(pi)^(0)$, repeatedly calculate

$
  bold(pi)^(t+1) = bold(upright(G))^top bold(pi)^(t).
$

Here the superscript $t$ counts the power-iteration step. The iteration is stopped when the PageRank scores change by less than a chosen tolerance. The value $pi_j$ is then interpreted as the long-run probability of visiting page $j$.


#let nodes = (
  "Markov chain",
  "Stochastic matrix",
  "Random walk",
  "PageRank",
  "Eigenvalues",
  "Stationary distribution",
  "Google",
  // "Web search engine",
  // "Probability theory",
  // "Graph theory",
)
#let edges = (
  (3, 2),
  (4, 1),
  (1, 4),
  (0, 4),
  (3, 0),
  (5, 6),
  (6, 5),
)
#figure(
  diagram({
    for (i, n) in nodes.enumerate() {
      let θ = 90deg - i * 360deg / nodes.len()
      node((θ, 25mm), n, stroke: 0.5pt, name: str(i))
    }
    for (from, to) in edges {
      let bend = if (to, from) in edges { 10deg } else { 0deg }
      edge(label(str(from)), label(str(to)), "-|>", bend: bend)
    }
  }),
  caption: [A small hyperlink graph. Each page is a state in a Markov chain, and each outgoing edge gives the probability of following a link from that page.],
  placement: bottom,
)
