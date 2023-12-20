import numpy as np
import scipy.stats as stats
import matplotlib.pyplot as plt

wartosci = np.array([1, 2, 3, 4, 5, 6])
prawdopodobienstwa = np.array([1 / 6, 1 / 6, 1 / 6, 1 / 6, 1 / 6, 1 / 6])

n = 100

bernoulli = np.random.choice(wartosci, n, p=prawdopodobienstwa)
mean_bernoulli = np.mean(bernoulli)
var_bernoulli = np.var(bernoulli)
kurt_bernoulli = stats.kurtosis(bernoulli)
skew_bernoulli = stats.skew(bernoulli)

binomial_val = np.random.binomial(20, 0.4, n)
mean_binomial = np.mean(binomial_val)
var_binomial = np.var(binomial_val)
kurt_binomial = stats.kurtosis(binomial_val)
skew_binomial = stats.skew(binomial_val)

poisson_val = np.random.poisson(3, n)
mean_poisson = np.mean(poisson_val)
var_poisson = np.var(poisson_val)
kurt_poisson = stats.kurtosis(poisson_val)
skew_poisson = stats.skew(poisson_val)

binomial_pmf = stats.binom.pmf(np.arange(21), 20, 0.4)
sum_prawdopodobienstwa = np.sum(binomial_pmf)

normal_val = np.random.normal(0, 2, 100)
mean_normal = np.mean(normal_val)
var_normal = np.var(normal_val)
kurt_normal = stats.kurtosis(normal_val)
skew_normal = stats.skew(normal_val)

more_normal_val = np.random.normal(0, 2, 1000)
mean_more_normal = np.mean(more_normal_val)
var_more_normal = np.var(more_normal_val)
kurt_more_normal = stats.kurtosis(more_normal_val)
skew_more_normal = stats.skew(more_normal_val)

plt.hist(normal_val, bins=20, alpha=0.5, label="N(0, 2)")
plt.hist(more_normal_val, bins=20, alpha=0.5, label="N(0, 2) - more data")
plt.hist(np.random.normal(-1, 0.5, 100), bins=20, alpha=0.5, label="N(-1, 0.5)")
plt.legend()
plt.show()

fig, axs = plt.subplots(3, 1, figsize=(8, 12))

axs[0].bar(wartosci, prawdopodobienstwa, alpha=0.5, label="Bernoulli")
axs[0].set_title("Bernoulli")
axs[0].legend()

axs[1].bar(np.arange(21), binomial_pmf, alpha=0.5, label="Binomial")
axs[1].set_title("Binomial")
axs[1].legend()

axs[2].bar(
    np.arange(11), stats.poisson.pmf(np.arange(11), 3), alpha=0.5, label="Poisson"
)
axs[2].set_title("Poisson")
axs[2].legend()

plt.show()

print("Statystyki dla rozkładu Bernoulliego:")
print(f"Średnia: {mean_bernoulli}")
print(f"Wariancja: {var_bernoulli}")
print(f"Kurtoza: {kurt_bernoulli}")
print(f"Skośność: {skew_bernoulli}\n")

print("Statystyki dla rozkładu Dwumianowego:")
print(f"Średnia: {mean_binomial}")
print(f"Wariancja: {var_binomial}")
print(f"Kurtoza: {kurt_binomial}")
print(f"Skośność: {skew_binomial}")
print(f"Suma prawdopodobieństw dla rozkładu dwumianowego: {sum_prawdopodobienstwa}\n")

print("Statystyki dla rozkładu Poissona:")
print(f"Średnia: {mean_poisson}")
print(f"Wariancja: {var_poisson}")
print(f"Kurtoza: {kurt_poisson}")
print(f"Skośność: {skew_poisson}\n")

print("Statystyki dla rozkładu normalnego (n=100):")
print(f"Średnia: {mean_normal}")
print(f"Wariancja: {var_normal}")
print(f"Kurtoza: {kurt_normal}")
print(f"Skośność: {skew_normal}\n")

print("Statystyki dla rozkładu normalnego (n=1000):")
print(f"Średnia: {mean_more_normal}")
print(f"Wariancja: {var_more_normal}")
print(f"Kurtoza: {kurt_more_normal}")
print(f"Skośność: {skew_more_normal}")
