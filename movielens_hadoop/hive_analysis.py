import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from scipy.stats import norm

# import data

# user average reviews
user_df = pd.read_csv('local_data/user_ratings.tsv', sep='\t', header=None)

# rating counts for each star level separated by genre
gr_df = pd.read_csv('local_data/genre_ratings.tsv', sep='\t', header=None)

user_df.columns = ['userId', 'avg_rating']
gr_df.columns = ['genre', 'rating', 'count']
gr_df = gr_df.dropna(subset=['rating'])

gr_df['rating'] = gr_df['rating'].astype(int)

gr_df.sort_values(['count'], ascending=False).to_csv('local_data/gr_sorted.csv')


# parameters for the normal distribution pdf
x_axis = np.linspace(np.min(user_df.avg_rating), np.max(user_df.avg_rating), 100)
s_mean = user_df.avg_rating.mean()
s_stderr = user_df.avg_rating.std()


# plot the average rating distribution
sns.histplot(x='avg_rating', data=user_df, stat='density', color='#5fb0ff')
plt.plot(x_axis, norm.pdf(x_axis, s_mean, s_stderr), color='darkred')
plt.savefig('rating_hist.png')


fig, ax = plt.subplots(figsize=(15, 10))
sns.lineplot(x='rating', y='count', hue='genre', data=gr_df, palette='Paired')

plt.legend(bbox_to_anchor=(1.0, 1.05))
plt.savefig('rating_genre.png')