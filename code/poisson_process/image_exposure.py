from PIL import Image
import numpy as np
import matplotlib.pyplot as plt
from pathlib import Path
from scipy.stats import poisson

PATH = Path(__file__).parent


def take_picture(
    img: np.ndarray, exposure_time: float, light_sensitivity: float
) -> np.ndarray:
    """
    Simulate taking a picture with a camera using a Poisson process.
    """
    # Calculate the expected number of photons for each pixel
    expected_photons = img * exposure_time * light_sensitivity

    # Apply the Poisson process to simulate photon arrival
    noisy_img = poisson.rvs(expected_photons)

    # Clip values to be in the valid range [0, 255] for image representation
    noisy_img = np.clip(noisy_img, 0, 255).astype(np.uint8)

    return noisy_img


def main():
    img = np.asarray(Image.open(PATH / "dog.jpg"))

    exposure_time = 10.0  # seconds
    light_sensitivity = 0.5  # ISO

    noisy_img = take_picture(img, exposure_time, light_sensitivity)

    plt.figure(figsize=(10, 5))
    plt.subplot(1, 2, 1)
    plt.title("Original Image")
    plt.imshow(img)
    plt.axis("off")
    plt.subplot(1, 2, 2)
    plt.title("Noisy Image")
    plt.imshow(noisy_img)
    plt.axis("off")
    plt.tight_layout()
    plt.show()


if __name__ == "__main__":
    main()
