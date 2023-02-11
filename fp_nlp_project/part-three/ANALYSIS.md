## Analysis of Naïve Bayes Sentiment Polarity Classifier predictions

Overall, the Naïve Bayes model's performance was not great in this sentiment analysis task, with an accuracy just over 50%, suggesting that it the sentiment predictions are close to the level of random guessing. I kept this in mind when analysing the following predictions. Also, although the correct and incorrect prediction samples were chosen randomly, the sample consists of 9 negative reviews, and 1 positive review.

All the unigram probabilities used in this analysis were calculated in Section 3.2 of my [testing_notebook](../testing_notebook.ipynb).

### Correct predictions

**1. Suicide Kings (Negative review):**

To me, this review was unambiguously negative, with several words which often imply negative sentiment towards the independent movie "Suicide Kings". These include the words:  "desperate, terrible, issue, bizarre, tangents, unrelated, mess, wrong"  and "riffing", among others. 

I thought that these words probably contributed to the negative prediction. To check this, I compared the probabilities of the first few words occurring with both positive and negative sentiment using their respective unigram language  models. The result showed that of the four words we looked at, three of them had a higher probability of occurring in negative reviews. Surprisingly enough, "bizarre" was slightly more likely to occur in positive reviews.

![image-20230210171504095](../../images/suicide_kings.png)



**2. Denise Calls Up (negative review):**

This review was more ambiguous than the first, with moments where the movie "Denise Calls Up" are praised and others where it is criticised. There is even a segment at the end quoting another rating, which contains several words that are usually associated with positive sentiment. E.g., amazing, potent, perfection

As with the previous review, I will check the unigram probabilities of the following words, present in the review, that intuitively would occur more in negative reviews than positive ones. Words I thought would contribute to negative prediction include: "settles, dysfunctional, too, satire, problem, and predict".

Comparing the probabilities of the first four, I saw that "settles", and "too" are more likely to occur in negative reviews, but "dysfunctional" and "satire" actually occurred more in positive reviews.

![image-20230210174637209](../../images/denise_calls_up.png)



**3. The Opposite Sex and How to Live with Them (negative review):**

This review contains a mix of positive and negative sentiment, but leans more towards the negative than Example 2 in my opinion. Words that I think would've led to a negative prediction here include  "goofy, waste, stereotypical, bad, point" and "frequent". Words like "love" and "good" are are featured in the review. but are outnumbered by the negative words.

In this case, all of the four words I tested were more likely to occur in negative reviews. The probabilities can be viewed below.

![image-20230210180143528](../../images/the_opposite_sex.png)



**4. Where The Heart Is (negative review):**

This review, like Example 1, is unquestionably negative and contains many words of negative sentiment towards the 2000 movie "Where The Heart Is". I think the negative prediction is attributed towards words such as "terrible, awful, pathetic, ugly, tragic, disjointed, confusing" and "junk". 

The first line of the review outlines positive characteristics which the reviewer believes to be absent from the movie, including "strong, original, memorable" and "solid". But the impact of these on the prediction was less than the list of negative words above.  As expected, all of the tested words were more likely to occur in negative reviews. Most of them were more than x10 more more likely to occur in negative reviews in fact.

![image-20230210182119771](../../images/where_the_heart_is.png)



**5. John Carpenter's Vampires (negative review):**

This is another definite negative review, with several negative words in common with Example 4 including "terrible" and "junk". The movie being reviewed is "John Carpenter's Vampires". Other words notable words in the review with negative sentiment include "lost, unscary, stylelessly" and "disheartening". The word stylelessly didn't occur in the training data, so was ignored by the Naïve Bayes classifier, and the remaining words that I tested were more likely to appear in negative reviews.

![image-20230210183909419](../../images/vampires.png)



### Incorrect predictions

**6. Trees Lounge (positive review):**

This review of the movie "Trees Lounge" is fairly mixed, which is what lead the model to incorrectly predict negative sentiment, even though the review is positive. I would expect that words such as "awfully, slow, pestering, loser, dies", and "expectation" lead to the negative prediction. As there are less positively sentimental words used in the review, some of which include "good" and "memorable". This remark by the reviewer, which summarises their opinion, helps to understand this incorrect prediction:

"I liked this movie alot even though it did not reach my expectation". Of the words I checked, they were all more likely to occur in a negative review than a positive except for "slow". Although the difference between the probabilities of "slow" is so small that it would have very little impact on the prediction.

![image-20230211182645237](../../images/trees_lounge.png)



**7. Barb Wire (negative review):**

This review doesn't use any words that are strongly negative in sentiment. The movie is described in a mocking, satirical manner by the reviewer. Many words in the review when taken out of context would appear positively sentimental, such as "talent, notable, freedom", and "attracts". This contributes to the  incorrect prediction.

Of these words, only "talent" is more likely to occur in a negative review.

![image-20230211184329355](../../images/barb_wire.png)

 

**8. Color of Night (negative review):**

Out of all the reviews analysed so far, this was the hardest to understand misclassification. The probabilities of both positive and negative sentiment were closest together here in comparison to the rest of the sample, which shows that the classifier was less confident in it's prediction than with the other classifications. There was only a log probability difference of about 4 between the negative and positive labels. 

![image-20230211191816578](../../images/incorrect_sample.png)

When we compare these log probability differences (log_p_diff) to that of the correct predictions, we see that in the random samples, the Naïve classifier was less confident in it's incorrect predictions than in it's correct ones.

![image-20230211202827430](../../images/correct_sample.png)



Words with negative sentiment in this review include "abruptly, worst, awful, laughable, wreck" and "pointless". While words with positive sentiment include "good, love, heaven", and "realistic". Of the negative words listed, checking their probabilities verified that these words occur more in negative reviews.

The words "realistic, heaven" and "love" were more likely to occur in positive reviews, with the word "good" occurring at almost the same rate in positive and negative reviews. "realistic" was much more likely to occur in positive reviews.

![color](../../images/color_of_night.png)



**9. Extraordinary Visitor (negative review):**

As can be seen in the example above, this was not a confident prediction either, as reflected in the closeness of log probabilities. Several words in the review are have clear negative sentiment, such as  "watchable" and "holes". While words of positive sentiment include "miracle" and "extraordinary".

![extraordinary_visitor](../../images/extraordinary_visitor.png)



**10.  Four Rooms (negative review):**

This review contained words which when taken out of context, would imply positive sentiment, such as "great", and "funny". But this is a sentence in which funny was used, for example: "It was not funny, I didn't hear one laugh in the theatre throughout the whole film". Although, the word funny was more likely to occur in negative reviews actually, while "great" appeared much more in positive reviews. 

"Tarantino" is mentioned several times in this review, as he is part of the cast, and his name is over 5x more likely to occur in positive reviews than in negative ones. This definitely contributed to the incorrect prediction of positive rather than negative.

![four_rooms](../../images/four_rooms.png)





