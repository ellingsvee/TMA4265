"""
PageRank as a Markov chain using real Wikipedia pages.

Each webpage is a state.
A hyperlink from page i to page j creates a possible transition i -> j.

The script:
1. Downloads a curated collection of real webpages.
2. Extracts links between those webpages.
3. Builds a directed graph.
4. Constructs the Google transition matrix.
5. Computes its stationary distribution.
6. Compares the result with networkx.pagerank.
7. Draws the hyperlink graph.
"""

from __future__ import annotations

import time
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

# A curated set keeps the graph small enough to explain in class.
PAGES = {
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
    """Map canonical URLs to their short classroom labels."""
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

    S[i, j] = probability of going from node i to node j by following
    one hyperlink.

    Dangling pages, meaning pages with no outgoing links in our selected
    subgraph, are treated as linking uniformly to every page.
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
    Construct the PageRank/Google transition matrix.

    With probability alpha, follow a link.
    With probability 1-alpha, teleport to a uniformly chosen page.
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

        if difference < tolerance:
            return distribution, iteration

    raise RuntimeError(
        f"Power iteration did not converge after {max_iterations} iterations."
    )


def print_transition_matrix(
    matrix: np.ndarray,
    node_order: Iterable[str],
) -> None:
    nodes = list(node_order)

    print("\nNode numbering:")
    for i, node in enumerate(nodes):
        print(f"  {i}: {node}")

    print("\nGoogle transition matrix P:")
    print(
        np.array2string(
            matrix,
            precision=3,
            suppress_small=True,
            max_line_width=160,
        )
    )

    print("\nRow sums:")
    print(matrix.sum(axis=1))


def compare_pagerank_methods(
    graph: nx.DiGraph,
    node_order: list[str],
    alpha: float,
) -> dict[str, float]:
    """Compute PageRank manually and with NetworkX."""
    matrix = google_matrix(graph, node_order, alpha)

    manual_vector, iterations = stationary_distribution(matrix)
    manual_scores = dict(zip(node_order, manual_vector, strict=True))

    networkx_scores = nx.pagerank(
        graph,
        alpha=alpha,
        max_iter=1_000,
        tol=1e-12,
    )

    print_transition_matrix(matrix, node_order)

    print("\nPageRank comparison:")
    print(f"{'Page':25s} {'Manual':>12s} {'NetworkX':>12s} {'Difference':>12s}")
    print("-" * 66)

    ranking = sorted(
        node_order,
        key=lambda node: manual_scores[node],
        reverse=True,
    )

    for node in ranking:
        manual = manual_scores[node]
        library = networkx_scores[node]

        print(
            f"{node:25s} {manual:12.8f} {library:12.8f} {abs(manual - library):12.2e}"
        )

    return manual_scores


def visualize_graph(
    graph: nx.DiGraph,
    pagerank_scores: dict[str, float],
) -> None:
    plt.figure(figsize=(14, 10))

    positions = nx.spring_layout(
        graph,
        seed=12,
        k=1.4,
        iterations=200,
    )

    # Larger PageRank -> larger node.
    node_sizes = [5_000 + 50_000 * pagerank_scores[node] for node in graph.nodes]

    nx.draw_networkx_nodes(
        graph,
        positions,
        node_size=node_sizes,
        alpha=0.85,
    )

    nx.draw_networkx_edges(
        graph,
        positions,
        arrows=True,
        arrowstyle="-|>",
        arrowsize=18,
        connectionstyle="arc3,rad=0.08",
        width=1.3,
        alpha=0.55,
        node_size=node_sizes,
    )

    nx.draw_networkx_labels(
        graph,
        positions,
        font_size=9,
        font_weight="bold",
    )

    plt.title(
        "PageRank as a Markov Chain\n"
        "Node area is proportional to stationary probability",
        fontsize=15,
    )
    plt.axis("off")
    plt.tight_layout()
    plt.show()


def visualize_ranking(pagerank_scores: dict[str, float]) -> None:
    """Draw a second, easier-to-read ranking chart."""
    ranking = sorted(
        pagerank_scores.items(),
        key=lambda item: item[1],
    )

    labels = [label for label, _score in ranking]
    scores = [score for _label, score in ranking]

    plt.figure(figsize=(10, 6))
    plt.barh(labels, scores)
    plt.xlabel("Stationary probability")
    plt.title("PageRank scores")
    plt.tight_layout()
    plt.show()


def main() -> None:
    graph = build_web_graph(PAGES)

    print(
        f"\nGraph contains {graph.number_of_nodes()} pages "
        f"and {graph.number_of_edges()} directed links."
    )

    if graph.number_of_edges() == 0:
        raise RuntimeError(
            "No links were detected. The websites may have changed, "
            "blocked the request, or redirected to unexpected URLs."
        )

    node_order = list(PAGES.keys())

    scores = compare_pagerank_methods(
        graph,
        node_order=node_order,
        alpha=ALPHA,
    )

    visualize_graph(graph, scores)
    visualize_ranking(scores)


if __name__ == "__main__":
    main()
