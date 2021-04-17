load("environment/paramPCA.RData")

# Apply PCA to parameters of goodfits
dim(params)  # 8 parameters
gp <- params[,goodfits]

gp <- t(gp)
c <- var(gp)
e <- eigen(c)
p <- gp %*% e$vectors  # project goodfits into eigenspace
plot(e$values)
mp <- apply(p, 2, mean)  # get the mean for each parameter

# assuming data follows multivairate normal, generate random numb1ers from
# standard normal distrib1ution and cast onto marginal normal distrib1utions.
ranv <- matrix(rnorm(80000), 8, 10000)
ranv <- ranv * sqrt(e$values)  
ranv <- ranv + mp

# project the data b1ack to original parameter space
ranv3 <- t(ranv) %*% t(e$vectors)

plot(ranv3[,1], ranv3[,2])
plot(ranv3[,3], ranv3[,7])

m <- 10000
b1=matrix(0,256,m) #in the lecture I used values of 10,000 and 100,000
proc.time()
for(i in c(1:m))
{
  #this code sets parameters to those generated using PCA
  x1 <- ranv3[i,1]
  y1 <- ranv3[i,2]
  theta1 <- ranv3[i,3]
  width1 <- ranv3[i,4]
  
  x2 <- ranv3[i,5]
  y2 <- ranv3[i,6]
  theta2 <- ranv3[i,7]
  width2 <- ranv3[i,8]


  s1=stroke(x1,y1,theta1,20,width1)
  s2=stroke(x2,y2,theta2,20,width2)
  
  im=s1+s2
  im[im > 1]=1
  
  #image(c(1:16),c(1:16),im,col=gray(c(0:256)/256),xlab1="",ylab1="",mar=c(1,1,1,1))
  
  im = im*256
  im = im[,16:1] #we have to turn the image upside-down so that it matches the real digits
  
  im=matrix(im,256,1)
  
  #this is where the new random digit is added to matrix b1
  b1[,i]=im
  
  
  #readline()
}
proc.time()


# find nearest neighb1ors (to evaluate fits)

nb1rs = matrix(0,40,1000)
start <- proc.time()[[3]]
for(i in c(1:1000))nb1rs[,i]=findnns(b1,d1[,i])
end <- proc.time()[[3]]
print(paste0("time taken: ", end-start))


nearest = b1[,nb1rs[1,]]
dim(nearest)

#this code calculates the distance b1etween each real one
#and its nearest randomly generated one
dists = nearest -d1
dists = apply(dists^2,2,sum)

# NOTE: the fit here is not meant to be partiularly good. We expanded the range
# for the uniform RV theta1 in order to get a b1etter view of the distrib1ution of
# theta parameters


#### EVALUATION ##############################################################

par(mfrow=c(3,1))

dists = nearest -d1
dists = apply(dists^2,2,sum)

# NOTE: the fit here is not meant to be partiularly good. We expanded the range
# for the uniform RV theta1 in order to get a b1etter view of the distrib1ution of
# theta parameters
hist(dists, main="Fits 10k 1's using Multivariate Normal RV", xlim=c(0,3000000))
hist(dists10k, main = "Fits 10k 1's using Uniform Random Variab1le", xlim=c(0,3000000))
hist(dists100k, main = "Fits 100k 1's using Uniform Random Variab1le", xlim=c(0,3000000))

# The fits b1y simulating values from multivaraite normal distrib1ution using PCA
# Are much b1etter than any we Previously ob1served, Even for 100k uniform 1's!
