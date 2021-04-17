#THIS IS THE CODE USED IN THE VIDEO FROM March 15 2021

# set working directory
setwd("C:/Users/joluw/OneDrive - Dublin City University/Documents/r_projects/ca274")


#### MORE DIGITS APPROACH #############################################################
#this code generates random sevens
#it is an edited version of the code from "random digits.R"
#which generated random ones
#the sevens have three strokes whereas the ones had two strokes
#initially fixed at 10k, tried 100k
m <- 10000
b=matrix(0,256,m)
for(i in c(1:m))
{
#this code generates random values for each argument of stroke
#this is the upper stroke
x1=runif(1,12,16)
y1=runif(1,12,16)
theta1 = runif(1,pi/2,pi*0.65)
len=20
width1=runif(1,0.5,3)

#this is the lower stroke
x2=runif(1,12,16)
y2=runif(1,12,16)
theta2 = runif(1,pi*0.75,pi)
len=20
width2=runif(1,0.5,3)

#this is the cross-stroke
x3=runif(1,13,16)
y3=runif(1,7,9)
theta3 = runif(1,pi*0.45,pi*0.55)
len3=runif(1,8,16)
width3=runif(1,0.5,3)


s1=stroke(x1,y1,theta1,20,width1)
s2=stroke(x2,y2,theta2,20,width2)
s3=stroke(x3,y3,theta3,len3,width3)

im=s1+s2+s3
im[im > 1]=1

#image(c(1:16),c(1:16),im,col=gray(c(0:256)/256),xlab="",ylab="",mar=c(1,1,1,1))

im = im*256
im = im[,16:1] #we have to turn the image upside-down so that it matches the real digits

im=matrix(im,256,1)

#this is where the new random digit is added to matrix b
b[,i]=im

#readline()
}
b7= b #we save b as b7 for later use (see below)
# note: b1 would be b10k or b100k.
#b1= b10k

#we read in the real digits 
d7=scan("data/digits/Zl7d.dat",nlines=1000,n=256000)
d7=matrix(d7,256,1000)

#this is the same code as we used last week to find the 40 nearest neighbours
#however, this time we are searching matrix b rather than d
nbrs7 = matrix(0,40,1000)
for(i in c(1:1000))nbrs7[,i]=findnns(b7,d7[,i])

#this code displays each real digit next to its nearest neighbour in matrix b
#we can see the match between the real digit and the randomly generated digit
dev.new()
par(mfrow=c(2,1))
par(mar=c(1, 1, 1, 1))
for(i in c(1:1000)) 
{
z = matrix(d7[,i],16,16) # the real digit
image(c(1:16),c(1:16),z[,16:1],col=gray(c(0:256)/256),xlab="",ylab="",mar=c(1,1,1,1))
z = matrix(b7[,nbrs7[1,i]],16,16) #the nearest neighbour in matrix b
image(c(1:16),c(1:16),z[,16:1],col=gray(c(0:256)/256),xlab="",ylab="",mar=c(1,1,1,1))
readline()
}

#in the code below, b1 is the matrix of random ones generated using the code from March 31
#we combine the random ones and the random sevens into a single matrix b
#we combine the real ones and the real sevens into a single matrix d
b=cbind(b10k,b7)
d=cbind(d1,d7)

#for each of the real ones and real sevens we find the nearest neigbours
#among the 10000 random ones and 10000 random sevens
start <- proc.time()
nbrs17 = matrix(0,40,2000)
for(i in c(1:2000))nbrs17[,i]=findnns(b,d[,i])
end <- proc.time()

print(paste("Time taken to find nns (10k images of each digit) ", (end-start)[[3]]))
# 10k 7's time: ~185.25
# 100k 7's time: ~1056s = 17.6mins!

#this is an edited version of the classify function from previous weeks
#the labels vector contains only ones and sevens
classify = function(nns,k)
{
labels = c(rep("1",10000),rep("7",10000))  # dependent on number of digits generated
digits= labels[nns[1:k]] #we include the first nearest neighbour in this case.
t=table(digits)
m=which.max(t)
names(m)
}

#we calculate the accuraccy for different values of k from 1 to 40
acc=0
n=2000
labels = c(rep("1",1000),rep("7",1000))
for(k in c(1:40))
{
results = apply(nbrs17,2,function(x) classify(x,k))
t=table(results,labels)
acc[k]=sum(diag(t))/n
}
dev.set(2)
plot(c(1:40),acc, main="Accuracies for k=1 to k=40 using KNN")
lines(c(1:40),acc)


#it is informative to look at one of the confusion matrices t
#here we generate the confusion matrix for k=1
k=1
results = apply(nbrs17,2,function(x) classify(x,k))
table(results,labels)

# with 10k 7's and 10k 1's
#        labels
# results   1   7
#       1 956 223
#       7  44 777

# with 100k 7's 10k 1's
#        labels
# results   1   7
#       1 921  98
#       7  79 902

# let's try to improve accuracy using more data.
# by generating 10x the previous sevens, we increased the accuracy significantly
# while increasing misclassifications of 0. The runtime was horrendous (17m)

#### BOX METHOD ##################################################################
# I will try the box method with PCA (using 40 eigenvectors)

n <- 40
b <- t(b)  # transpose for correct covariance matrix
c <- var(b)
e <- eigen(c)
plot(e$values)
p <- b %*% e$vectors[,1:n]  # project data onto eigenvectors
p <- t(p)

d <- t(d)
d_eigen <- d %*% e$vectors[,1:n]
d_eigen <- t(d_eigen)

nbrsbox = matrix(0,40,2000)
start <- proc.time()
box_size <- 300
for(i in c(1:2000))
{
  # defining boxes on difference between image model PC and real digit PC
  box=which(abs(p[1,]-d_eigen[1,i]) < box_size & abs(p[2,]-d_eigen[2,i]) < box_size)
  nnb=findnns(p[1:n,box],d_eigen[1:n,i])
  nbrsbox[,i]=box[nnb]
}
end <- proc.time()
print(paste("Neighbors found using box method and eigen_n = 40,", (end - start)[[3]], sep=" "))
# Time: 110s

accuracy_box17 <- c()
for (k in 1:40)
{
  results = apply(nbrsbox,2,function(x) classify(x,k))
  (t <- table(results,labels))
  acc <- sum(diag(t))/2000
  #print(paste0("Accuracy for k=", k, ": ",acc))
  accuracy_box17[k] <- acc
}
plot(accuracy_box17)

# k=1 mark
labels <- c(rep("1", 1000), rep("7", 1000))
k=1
results = apply(nbrsbox,2,function(x) classify(x,k))
(t <- table(results,labels))
sum(diag(t))/2000
#       labels
# results   1   7
#       1 821 460
#       7 179 540

# bad result. Let's investigate what went wrong.
# BUG: was finding nns for synthetic digits rather than original digits
# fixed result

#       labels
# results   1   7
#       1 939 143
#       7  61 857
#

#### INVESTIGATING MISCLASSIFICATIONS #########################################################
# misclassified 7's
nearest7 <- b[,nbrsbox[1,]]  # store nearest neighbor for each image
misclass7 <- which(labels == "7" & results == "1")
dev.set(3)
par(mfrow=c(2,1))
par(mar = c(1,1,1,1))
for (i in misclass7)
{
  # print the misclassified 1 and it's neighboring model
  z <- matrix(d[,i], 16, 16)  # misclassified
  image(c(1:16), c(1:16), z[,c(16:1)], col=grey(c(0:255)/255))
  z <- matrix(nearest7[,i], 16, 16)  # neighbor model image
  image(c(1:16), c(1:16), z[,c(16:1)], col=grey(c(0:255)/255))
  
  readline()
}
# these misclassifications are due to lack of good 7 matches and similarity
# in 1 and 7 primary strokes

# misclassified 1's
misclass1 <- which(labels == "1" & results == "7")
dev.set(3)
par(mfrow=c(2,1))
par(mar = c(1,1,1,1))
for (i in misclass1)
{
  # print the misclassified 1 and it's neighboring model
  z <- matrix(d[,i], 16, 16)  # misclassified
  image(c(1:16), c(1:16), z[,c(16:1)], col=grey(c(0:255)/255))
  z <- matrix(nearest7[,i], 16, 16)  # neighbor model image
  image(c(1:16), c(1:16), z[,c(16:1)], col=grey(c(0:255)/255))
  
  readline()
}
# alot of the 7's have small cross strokes which are too high and join with top
# stroke to imitate a thick 1. This occurs often. We need to improve the model
# producing 7's


# CLEANUP
rm(b1)
save.image("environments/image_gen_17box_gen.RData")
rm(list=ls())

