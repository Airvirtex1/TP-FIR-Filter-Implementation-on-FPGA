from scipy.signal import firwin
import numpy as np

coeffs = firwin(31, 0.3)  # 31 coefficients, coupure à 0.3
coeffs_int = np.round(coeffs * 64).astype(int)  # échelle sur 7 bits
print(coeffs_int)
print(f"Min: {coeffs_int.min()}, Max: {coeffs_int.max()}")