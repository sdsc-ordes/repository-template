import numpy as np


def numpy_demo_calculation():
    print("--- NumPy Demo Calculation ---")

    random_array = np.random.randint(0, 101, size=10)
    print(f"Original array: {random_array}")

    array_mean = np.mean(random_array)
    print(f"Mean of the array: {array_mean:.2f}")  # Format to 2 decimal places

    array_std_dev = np.std(random_array)
    print(
        f"Standard deviation of the array: {array_std_dev:.2f}"
    )  # Format to 2 decimal places

    random_array = np.random.randint(0, 101, size=10)
    print(f"Original array: {random_array}")

    array_mean = np.mean(random_array)
    print(f"Mean of the array: {array_mean:.2f}")  # Format to 2 decimal places

    array_std_dev = np.std(random_array)
    print(
        f"Standard deviation of the array: {array_std_dev:.2f}"
    )  # Format to 2 decimal places

    print("--- End of Demo ---")


def main():
    numpy_demo_calculation()


if __name__ == "__main__":
    main()
