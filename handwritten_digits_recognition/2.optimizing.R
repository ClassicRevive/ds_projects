# The goal here is to optimize KNN algorithm using a number of methods

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


# function to compute nearest neighbors (O(2^n) complexity, takes long to run)
findnns = function(d,x)
{
  dists = apply((x-d)^2,2,sum)
  dorder = order(dists)
  dorder[1:40]
}


#### RAW DATA APPROACH #########################################################
# compute the 40 nearest neighbors for each digit and store in matrix
nbrs256 = matrix(0,40,10000)
system.time(for(i in c(1:10000))nbrs256[,i]=findnns(d,d[,i]))
# time: 502.47s or 8.37 mins

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
raw_accuracy <- 0
proc.time()
for (k in 2:40){
  results = apply(nbrs256,2,function(x) classify(x,k))  # inline function definition
  
  # create confusion matrix
  labels = c(rep("0",1000),rep("1",1000),rep("2",1000),rep("3",1000),rep("4",1000),rep("5",1000),rep("6",1000),rep("7",1000),rep("8",1000),rep("9",1000))
  conf = table(results,labels)
  correct <- sum(diag(conf))  # this gives the number of correct predictions
  paste0("Accuracy: ", correct/length(labels)*100)
  raw_accuracy[k] = correct
}
proc.time()
# time: ~75s

# plot the accuracies
plot(c(2:40), raw_accuracy[2:40], main="accuracy levels for KNN")
# It appears that k=6 (5 neighbors)

#### PCA APPROACH ##############################################################
n <- 40
d <- t(d)
c <- var(d)
e <- eigen(c)
plot(e$values)

p <- d %*% e$vectors[,1:n]  # project data onto eigenvectors
p <- t(p)
dim(p)
nbrsp20 <- matrix(0, 40, 10000)
proc.time()
for (i in 1:10000) nbrsp20[,i]=findnns(p[1:n,], p[1:n,i])
proc.time()
# Time: 2.73m or 163.83s
# significantly faster than raw data approach

#to calculate the accuracy we use the same code as above but we replace 'nbrs256' with 'nbrsp20'
pacc=0
for(k in c(2:40))
{
  results = apply(nbrsp20,2,function(x) classify(x,k))
  t=table(results,labels)
  pacc[k]=sum(diag(t))
}
plot(c(2:40),pacc[2:40])

# compare with raw data accuracies
plot(c(2:40), raw_accuracy[2:40], main="accuracy levels for KNN (red is with PCA)")
points(c(2:40), pacc[2:40], col="red")
# clearly there is a trade-off here


# this code calculates the nearest neighbours and the accuracy
# for different numbers of eigenvectors from 2 to 20
# this code takes a very long time to run!
e_accuracies=0
for(n in c(2:20))
{
  for(i in c(1:10000))neighbours[,i]=findnns(p[1:n,],p[1:n,i])
  results = apply(neighbours,2,function(x) classify(x,5))
  t=table(results,labels)
  e_accuracies[n]=sum(diag(t))
}
plot(e_accuracies)


#### BOX APPROACH ##############################################################
# this code calcuates the 40 nearest neighbours by searching within a box
# boxes are based on PC1 and PC2 distances only
nbrsbox = matrix(0,40,10000)
proc.time()
for(i in c(1:10000))
{
  #box=which(abs(p[1,]-p[1,i]) < 600)
  box=which(abs(p[1,]-p[1,i]) < 600 & abs(p[2,]-p[2,i]) < 500)
  nnb=findnns(p[1:20,box],p[1:20,i])
  nbrsbox[,i]=box[nnb]
}
proc.time()
# Time: ~52s!

#we can check how similar the neighbours are to the neighbours calculated with the full dataset
sum(nbrsp20[1:5,] != nbrsbox[1:5,])

#we could also calculate the accuracy with the same code as for 'nbrs256'
#but we would substitute 'nbrs256' with 'nbrsbox' 

pacc=0
for(k in c(2:40))
{
  results = apply(nbrsbox,2,function(x) classify(x,k))
  t=table(results,labels)
  pacc[k]=sum(diag(t))
}
points(c(2:40),pacc[2:40],col='green')
# The accuracy for the boxed method has a low drop-off 
# The time taken to find nearest neighbors was less than
# a third of that without the box method!


#this is the code to decide how much the images are blurred
width = 1
ii = c(0:15)
ii[9:16] = 17 - c(9:16)
ii = ii^2
ex = exp(-ii/width)
gau = ex %*% t(ex)
image(c(1:16),c(1:16),256*gau,col=gray(c(0:256)/256))


d=c(d0,d1,d2,d3,d4,d5,d6,d7,d8,d9)
d=matrix(d,256,10000)
d=t(d)

#this is the code that does the blurring
#the blurred images are called x2
x2=d
x=d
for(i in c(1:10000))
{
  z = matrix(as.numeric(x[i,]),16,16)
  ft=fft(z)
  ft = ft *gau
  z2=fft(ft,inverse=T)
  #image(c(1:16),c(1:16),abs(z2),col=gray(c(0:256)/256))
  x2[i,]=matrix(abs(z2),1,256)
}

#this sets the mean of the blurred data to zero
mx2=apply(x2,2,mean)
x2=sweep(x2,2,mx2)
x2=256*x2/max(x2)

#this calculates the eigenvectors of the blurred data
c=var(x2)
e=eigen(c)
plot(e$values)
pblr=x2 %*% e$vectors[,1:3]

#this calculates the nearest neighbours within a box determined by the blurred data
pblr=t(pblr)
nbrsblrbox = matrix(0,40,10000)
for(i in c(1:10000))
{
  
  box=index[abs(pblr[1,]-pblr[1,i]) < 250 & abs(pblr[2,]-pblr[2,i]) < 250]
  
  if(length(box) < 100)
    box=index[abs(pblr[1,]-pblr[1,i]) < 500 & abs(pblr[2,]-pblr[2,i]) < 500]
  
  #we use the unblurred eigenvectors to find the neighbours
  nnb=findnns(p[1:20,box],p[1:20,i])
  nbrsblrbox[,i]=box[nnb]
}

#Again we can find the accuracy using the same code as for 'nbrs256' 
#except we substitute 'nbrsblrbox'

pacc=0
for(k in c(2:40))
{
  results = apply(nbrsblrbox,2,function(x) classify(x,k))
  t=table(results,labels)
  pacc[k]=sum(diag(t))
}
points(c(2:40),pacc[2:40],col='magenta')

