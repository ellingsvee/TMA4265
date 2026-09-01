"""
PageRank as a Markov chain using real Wikipedia pages.

The script:
1. Downloads a selected collection of real webpages.
2. Extracts links between those webpages.
3. Builds a directed graph.
4. Constructs the Google transition matrix.
5. Computes its stationary distribution.
6. Compares the result with networkx.pagerank.
7. Draws the hyperlink graph.
"""

from __future__ import annotations

import argparse
import time
import textwrap
from collections.abc import Iterable
from urllib.parse import urldefrag, urljoin, urlparse

import matplotlib.pyplot as plt
import networkx as nx
import numpy as np
import requests
from bs4 import BeautifulSoup


ALPHA = 0.85
REQUEST_DELAY_SECONDS = 0.5

HEADERS = {
    "User-Agent": (
        "MarkovChainTeachingDemo"
        "(educational PageRank example, contact: elling.svee@ntnu.no)"
    )
}

MARKOV_CHAIN_PAGES = {
    "Markov chain": "https://en.wikipedia.org/wiki/Markov_chain",
    "PageRank": "https://en.wikipedia.org/wiki/PageRank",
    "Stochastic matrix": "https://en.wikipedia.org/wiki/Stochastic_matrix",
    "Stationary distribution": "https://en.wikipedia.org/wiki/Stationary_distribution",
    "Random walk": "https://en.wikipedia.org/wiki/Random_walk",
    "Eigenvalues": "https://en.wikipedia.org/wiki/Eigenvalues_and_eigenvectors",
    "Google": "https://en.wikipedia.org/wiki/Google",
    "Web search engine": "https://en.wikipedia.org/wiki/Search_engine",
    "Probability theory": "https://en.wikipedia.org/wiki/Probability_theory",
    "Graph theory": "https://en.wikipedia.org/wiki/Graph_theory",
}

NORWEGIAN_ROYALTY_PAGES = {
    "Norwegian monarchy": "https://en.wikipedia.org/wiki/Monarchy_of_Norway",
    "Norwegian royal family": "https://en.wikipedia.org/wiki/Norwegian_royal_family",
    "Haakon VIII": "https://en.wikipedia.org/wiki/Haakon_VIII",
    "Queen Mette-Marit": "https://en.wikipedia.org/wiki/Queen_Mette-Marit_of_Norway",
    "Crown Princess Ingrid Alexandra": (
        "https://en.wikipedia.org/wiki/Ingrid_Alexandra,_Crown_Princess_of_Norway"
    ),
    "Prince Sverre Magnus": (
        "https://en.wikipedia.org/wiki/Prince_Sverre_Magnus_of_Norway"
    ),
    "Princess Märtha Louise": (
        "https://en.wikipedia.org/wiki/Princess_Märtha_Louise_of_Norway"
    ),
    "Durek Verrett": "https://en.wikipedia.org/wiki/Durek_Verrett",
    "Queen Sonja": "https://en.wikipedia.org/wiki/Queen_Sonja_of_Norway",
    "Harald V": "https://en.wikipedia.org/wiki/Harald_V_of_Norway",
    "Olav V": "https://en.wikipedia.org/wiki/Olav_V_of_Norway",
    "Royal Palace": "https://en.wikipedia.org/wiki/Royal_Palace,_Oslo",
}

PAGE_COLLECTIONS = {
    "markov": MARKOV_CHAIN_PAGES,
    "royalty": NORWEGIAN_ROYALTY_PAGES,
}


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Compute PageRank for a curated collection of Wikipedia pages."
    )
    parser.add_argument(
        "--collection",
        choices=PAGE_COLLECTIONS,
        default="markov",
        help="page collection to analyze (default: markov)",
    )
    return parser.parse_args()


def canonicalize_url(url: str) -> str:
    url, _fragment = urldefrag(url)
    parsed = urlparse(url)

    normalized = parsed._replace(
        query="",
        fragment="",
        path=parsed.path.rstrip("/") or "/",
    )

    return normalized.geturl()


def build_url_lookup(pages: dict[str, str]) -> dict[str, str]:
    return {canonicalize_url(url): label for label, url in pages.items()}


def extract_links(
    page_url: str,
    session: requests.Session,
) -> set[str]:
    """Download one HTML page and return its absolute hyperlinks."""
    try:
        response = session.get(
            page_url,
            headers=HEADERS,
            timeout=(5, 15),
        )
        response.raise_for_status()
    except requests.RequestException as exc:
        print(f"Could not download {page_url}: {exc}")
        return set()

    content_type = response.headers.get("Content-Type", "")
    if "text/html" not in content_type:
        print(f"Skipping non-HTML page: {page_url}")
        return set()

    soup = BeautifulSoup(response.text, "html.parser")
    links: set[str] = set()

    for anchor in soup.find_all("a", href=True):
        href = anchor["href"].strip()

        # Ignore mail, JavaScript, telephone links, etc.
        if not href or href.startswith(("mailto:", "javascript:", "tel:")):
            continue

        absolute_url = urljoin(response.url, href)
        parsed = urlparse(absolute_url)

        if parsed.scheme not in {"http", "https"}:
            continue

        links.add(canonicalize_url(absolute_url))

    return links


def build_web_graph(pages: dict[str, str]) -> nx.DiGraph:
    graph = nx.DiGraph()

    for label, url in pages.items():
        graph.add_node(label, url=url)

    url_to_label = build_url_lookup(pages)

    with requests.Session() as session:
        for index, (source_label, source_url) in enumerate(pages.items(), start=1):
            print(f"[{index:2}/{len(pages)}] Reading {source_label}: {source_url}")

            links = extract_links(source_url, session)

            for target_url in links:
                target_label = url_to_label.get(target_url)

                if target_label is not None and target_label != source_label:
                    graph.add_edge(source_label, target_label)

            time.sleep(REQUEST_DELAY_SECONDS)

    return graph


def hyperlink_transition_matrix(
    graph: nx.DiGraph,
    node_order: list[str],
) -> np.ndarray:
    """
    Construct the hyperlink-following matrix S.
    """
    n = len(node_order)
    index = {node: i for i, node in enumerate(node_order)}

    transition = np.zeros((n, n), dtype=float)

    for source in node_order:
        i = index[source]
        targets = list(graph.successors(source))

        if targets:
            probability = 1.0 / len(targets)

            for target in targets:
                j = index[target]
                transition[i, j] = probability
        else:
            # Dangling node correction
            transition[i, :] = 1.0 / n

    return transition


def google_matrix(
    graph: nx.DiGraph,
    node_order: list[str],
    alpha: float = 0.85,
) -> np.ndarray:
    """
    Construct the transition matrix G.
    """
    if not 0.0 < alpha < 1.0:
        raise ValueError("alpha must be strictly between 0 and 1.")

    n = len(node_order)
    hyperlink_matrix = hyperlink_transition_matrix(graph, node_order)
    teleportation_matrix = np.full((n, n), 1.0 / n)

    return alpha * hyperlink_matrix + (1.0 - alpha) * teleportation_matrix


def stationary_distribution(
    transition_matrix: np.ndarray,
    tolerance: float = 1e-12,
    max_iterations: int = 10_000,
) -> tuple[np.ndarray, int]:
    """
    Find pi satisfying pi = pi P.
    """
    n = transition_matrix.shape[0]
    distribution = np.full(n, 1.0 / n)

    for iteration in range(1, max_iterations + 1):
        next_distribution = distribution @ transition_matrix

        # Total variation distance is half the L1 distance.
        difference = 0.5 * np.abs(next_distribution - distribution).sum()

        distribution = next_distribution

        # Check if the distribution has converged.
        if difference < tolerance:
            return distribution, iteration

    raise RuntimeError(f"Iteration did not converge after {max_iterations} iterations.")


def print_transition_matrix(
    matrix: np.ndarray,
    node_order: Iterable[str],
) -> None:
    nodes = list(node_order)

    print("\nNode numbering:")
    for i, node in enumerate(nodes):
        print(f"  {i}: {node}")

    print("\nTransition matrix:")
    print(
        np.array2string(
            matrix,
            precision=3,
            suppress_small=True,
            max_line_width=160,
        )
    )


def compute_pagerank(
    graph: nx.DiGraph,
    node_order: list[str],
    alpha: float,
) -> dict[str, float]:
    """Compute PageRank"""
    matrix = google_matrix(graph, node_order, alpha)
    manual_vector, iterations = stationary_distribution(matrix)
    manual_scores = dict(zip(node_order, manual_vector, strict=True))
    print_transition_matrix(matrix, node_order)
    return manual_scores


def visualize_graph(
    graph: nx.DiGraph,
    pagerank_scores: dict[str, float],
) -> None:
    fig, ax = plt.subplots(figsize=(17, 12))

    positions = nx.spring_layout(
        graph,
        seed=12,
        k=2.2,
        iterations=500,
        scale=3.0,
    )

    scores = np.array([pagerank_scores[node] for node in graph.nodes])
    score_range = np.ptp(scores)
    if score_range > 0:
        relative_scores = (scores - scores.min()) / score_range
    else:
        relative_scores = np.zeros_like(scores)

    node_sizes = 1_300 + 5_200 * relative_scores**1.4

    nx.draw_networkx_nodes(
        graph,
        positions,
        node_size=node_sizes,
        linewidths=1.5,
        ax=ax,
    )

    reciprocal_edges = [
        (source, target)
        for source, target in graph.edges
        if graph.has_edge(target, source)
    ]
    one_way_edges = [
        (source, target)
        for source, target in graph.edges
        if not graph.has_edge(target, source)
    ]

    nx.draw_networkx_edges(
        graph,
        positions,
        edgelist=one_way_edges,
        arrows=True,
        arrowstyle="-|>",
        arrowsize=16,
        connectionstyle="arc3,rad=0.06",
        width=1.1,
        node_size=node_sizes,
        min_source_margin=4,
        min_target_margin=6,
        ax=ax,
    )
    nx.draw_networkx_edges(
        graph,
        positions,
        edgelist=reciprocal_edges,
        arrows=True,
        arrowstyle="-|>",
        arrowsize=16,
        connectionstyle="arc3,rad=0.18",
        width=1.1,
        node_size=node_sizes,
        min_source_margin=4,
        min_target_margin=6,
        ax=ax,
    )

    labels = {node: textwrap.fill(node, width=16) for node in graph.nodes}
    nx.draw_networkx_labels(
        graph,
        positions,
        labels=labels,
        font_size=8,
        font_weight="bold",
        font_color="#17212b",
        ax=ax,
    )

    ax.margins(0.18)
    ax.axis("off")
    fig.tight_layout()
    plt.show()


def print_ranking(pagerank_scores: dict[str, float]) -> None:
    ranking = sorted(
        pagerank_scores.items(),
        key=lambda item: item[1],
    )

    print("\nPageRank ranking (from low to high):")
    for label, score in ranking:
        print(f"{label:30}: {score:.6f}")


def main() -> None:
    args = parse_args()
    pages = PAGE_COLLECTIONS[args.collection]
    graph = build_web_graph(pages)

    print(
        f"\nGraph contains {graph.number_of_nodes()} pages "
        f"and {graph.number_of_edges()} directed links."
    )

    if graph.number_of_edges() == 0:
        raise RuntimeError(
            "No links were detected. The websites may have changed, "
            "blocked the request, or redirected to unexpected URLs."
        )

    node_order = list(pages.keys())

    scores = compute_pagerank(
        graph,
        node_order=node_order,
        alpha=ALPHA,
    )

    print_ranking(scores)
    visualize_graph(graph, scores)


if __name__ == "__main__":
    main()
