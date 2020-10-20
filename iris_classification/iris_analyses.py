#!/usr/bin/env python3

import pandas as pd
import numpy as np
import matplotlib
import matplotlib.pyplot as plt
from pandas.plotting import table


df = pd.read_csv('Iris.csv', index_col=0)

# first clean up Species columm by getting rid of "Iris-"
df[['Species']] = df['Species'].str.split("-").str.get(1).astype('category')

# get summary statistics
print(df.describe())

# get counts for each species
print("Species counts:\n")
print(df['Species'].value_counts())

# plot distribution of PetalLengthCm
plt.hist(df.PetalLengthCm, bins=20)
plt.xlabel("Petal lengths (cm)")
plt.ylabel("Frequency")
plt.savefig("petal_length_hist.png")


# Plot variables against each other
groups = df.groupby('Species')
# Sepal dimensions
fig1, ax = plt.subplots()

for name, group in groups:
    ax.plot(group.SepalLengthCm, group.SepalWidthCm, marker='.',
            linestyle='', ms=10, label=name)
plt.xlabel("Sepal Length (cm)")
plt.ylabel("Sepal Width (cm)")
ax.legend()
plt.savefig("sepal.png")

# Petal dimensions
fig2, ax = plt.subplots()

for name, group in groups:
    ax.plot(group.PetalLengthCm, group.PetalWidthCm, marker='.',
            linestyle='', ms=10, label=name)
plt.xlabel("Petal Length (cm)")
plt.ylabel("Petal Width (cm)")
ax.legend()
plt.savefig("petal.png")

df.boxplot(df.Species, df.PetalLengthCm)
plt.show()
