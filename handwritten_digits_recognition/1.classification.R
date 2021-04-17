# set working directory
setwd("C:/Users/joluw/OneDrive - Dublin City University/Documents/r_projects/ca274")

d0=scan("data/digits/Zl0d.dat",nlines=1000,n=256000)
d1=scan("data/digits/Zl1d.dat",nlines=1000,n=256000)
d2=scan("data/digits/Zl2d.dat",nlines=1000,n=256000)
d3=scan("data/digits/Zl3d.dat",nlines=1000,n=256000)
d4=scan("data/digits/Zl4d.dat",nlines=1000,n=256000)
d5=scan("data/digits/Zl5d.dat",nlines=1000,n=256000)
d6=scan("data/digits/Zl6d.dat",nlines=1000,n=256000)
d7=scan("data/digits/Zl7d.dat",nlines=1000,n=256000)
d8=scan("data/digits/Zl8d.dat",nlines=1000,n=256000)
d9=scan("data/digits/Zl9d.dat",nlines=1000,n=256000)

d=c(d0,d1,d2,d3,d4,d5,d6,d7,d8,d9)
d <- matrix(d,256,10000)

# classifying the zeroes as a test
proc.time()
cls=0
for(i in c(1:1000))
{
x=d[,i]
dists = apply((x-d)^2,2,sum)
dorder = order(dists)

labels = c(rep("0",1000),rep("1",1000),rep("2",1000),rep("3",1000),rep("4",1000),rep("5",1000),rep("6",1000),rep("7",1000),rep("8",1000),rep("9",1000))
t=table(labels[dorder[2:10]])
m=which.max(t)
cls[i] =names(m)
}
proc.time()


square = function(x)
{
x^2
}

# function to compute nearest neighbors (O(2^n) complexity, takes long to run)
findnns = function(d,x)
{
dists = apply((x-d)^2,2,sum)
dorder = order(dists)
dorder[1:40]
}

# compute the 40 nearest neighbors for each digit and store in matrix
nbrs256 = matrix(0,40,10000)
proc.time()
for(i in c(1:10000))nbrs256[,i]=findnns(d,d[,i])
proc.time()


# save matrix as binary object
save(nbrs256, file="data/digits_neighbors.Rdata")

#### START HERE ################################################################
# load matrix (loading the matrix from binary file is more efficient as it's compressed)
load("data/digits_neighbors.Rdata")

# read matrix from file
nbrs256 <- scan('data/digits_neighbors.txt', sep=" ")
nbrs256 <- matrix(nbrs256, 40, 10000, byrow=T)

classify = function(nns,k)
{
labels = c(rep("0",1000),rep("1",1000),rep("2",1000),rep("3",1000),rep("4",1000),rep("5",1000),rep("6",1000),rep("7",1000),rep("8",1000),rep("9",1000))
t=table(labels[nns[2:k]])  # as nns[1,] is the digit itself
m=which.max(t)
names(m)
}


# measuring accuracy with different numbers of neighbors
accuracy <- 0
for (k in 2:40){
results = apply(nbrs256,2,function(x) classify(x,k))  # inline function definition

# create confusion matrix
labels = c(rep("0",1000),rep("1",1000),rep("2",1000),rep("3",1000),rep("4",1000),rep("5",1000),rep("6",1000),rep("7",1000),rep("8",1000),rep("9",1000))
conf = table(results,labels)
correct <- sum(diag(conf))  # this gives the number of correct predictions
paste0("Accuracy: ", correct/length(labels)*100)
accuracy[k] = correct
}

# plot the accuracies
plot(c(2:40), accuracy[2:40], main="accuracy levels for KNN", type = "b")
# it seems that 3 neighbors is a good number. The maximum accuracy achieved
# using KNN was 97.96%

# extract index of 8's classified as 3's
group = which(labels=="8" & results == "3")

# compare neighbor with incorrectly classified digit
par(mfrow=c(1,2))
for(i in group)
{
  z=matrix(d[,i],16,16)
  image(c(1:16),c(1:16),z[,c(16:1)],col=gray(c(0:255)/255))
  z=matrix(d[,nbrs256[2,i]],16,16)
  image(c(1:16),c(1:16),z[,c(16:1)],col=gray(c(0:255)/255))
  readline()
}

