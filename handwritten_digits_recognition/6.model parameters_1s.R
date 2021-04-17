# In this project, I use PCA to project the parameters of good fit synthetic
# digits into eigenspace, generate parameters from normal distributions and
# return to original parameter space. I will then see how good the fits are
# in comparison to original fits

# Set working directory
setwd("C:/Users/joluw/OneDrive - Dublin City University/Documents/r_projects/ca274")

# load environment 
#load("environment/image_gen_box17.RData")


#we read in the real digits 
d1=scan("data/digits/Zl1d.dat",nlines=1000,n=256000)
d1=matrix(d1,256,1000)

#this is the same findnns() function which we used last week
findnns = function(d,x)
{
  d=d-x
  d=d^2
  dists=apply(d,2,sum)
  dorder=order(dists)
  dorder[1:40]
}

#this loop generates random ones
#the images are stored in the matrix b
#b has the same dimensions as the matrix d in our previous work

params=matrix(0,8,100000)
b100k=matrix(0,256,100000) #in the lecture I used values of 10,000 and 100,000
b10k=matrix(0,256,10000)
proc.time()
for(i in c(1:100000))
{
  #this code generates random values for each argument of stroke
  x1=runif(1,12,16)
  y1=runif(1,12,16)
  theta1 = runif(1,pi/2,pi*0.9)# new upper limit pi*0.9
  len=20
  width1=runif(1,0.5,3) #in the first lecture the upper limit was 2
  
  x2=runif(1,12,16)
  y2=runif(1,12,16)
  theta2 = runif(1,theta1,pi*1.1)#new lower limit theta1
  len=20
  width2=runif(1,0.5,3)#new upper limit 3
  
  params[,i]=c(x1,y1,theta1,width1,x2,y2,theta2,width2)
  
  s1=stroke(x1,y1,theta1,20,width1)
  s2=stroke(x2,y2,theta2,20,width2)
  
  im=s1+s2
  im[im > 1]=1
  
  #image(c(1:16),c(1:16),im,col=gray(c(0:256)/256),xlab="",ylab="",mar=c(1,1,1,1))
  
  im = im*256
  im = im[,16:1] #we have to turn the image upside-down so that it matches the real digits
  
  im=matrix(im,256,1)
  
  #this is where the new random digit is added to matrix b
  if (i<=10000)
  {
    b10k[,i] = im
  }
  b100k[,i]=im
  
  
  #readline()
}
proc.time()

#this is the same code as we used last week to find the 40 nearest neighbours
#however, this time we are searching matrix b rather than d

nbrs100k = matrix(0,40,1000)
start <- proc.time()[[3]]
for(i in c(1:1000))nbrs100k[,i]=findnns(b100k,d1[,i])
end <- proc.time()[[3]]
print(paste0("time taken: ", end-start))

# Time: Generating NN's from b100k ~ 516.97s

nbrs10k <- matrix(0,40,1000)
start <- proc.time()[[3]]
for(i in c(1:1000))nbrs10k[,i]=findnns(b10k,d1[,i])
end <- proc.time()[[3]]
print(paste0("time taken: ", end-start))


#this code displays each real digit next to its nearest neighbour in matrix b
#we can see the match between the real digit and the randomly generated digit
par(mfrow=c(2,1))
par(mar = c(1,1,1,1))
for(i in c(1:1000))
  #for(i in group)
{
  z = matrix(d1[,i],16,16) # the real digit
  image(c(1:16),c(1:16),z[,16:1],col=gray(c(0:256)/256),xlab="",ylab="",mar=c(1,1,1,1))
  z = matrix(b[,nbrs[1,i]],16,16) #the nearest neighbour in matrix b
  image(c(1:16),c(1:16),z[,16:1],col=gray(c(0:256)/256),xlab="",ylab="",mar=c(1,1,1,1))
  readline()
}

nearest100k <- b100k[,nbrs100k[1,]]
nearest10k <- b10k[,nbrs10k[1,]]

#this code selects extreme bad matches
group = which(dists > 2000000)

dists100k = nearest100k -d1
dists100k = apply(dists100k^2,2,sum)

goodfits=nbrs[1,dists100k < 800000]


plot(params1[3,goodfits1],params1[7,goodfits1],xlab="theta1",ylab="theta2")
plot(params1[1,goodfits1],params1[5,goodfits1],xlab="x1",ylab="x2")
plot(params1[1,goodfits1],params1[2,goodfits1],xlab="x1",ylab="y1")
plot(params1[2,goodfits1],params1[6,goodfits1],xlab="y1",ylab="y2")
plot(params1[4,goodfits1],params1[8,goodfits1],xlab="width1",ylab="width2")


plot(params[3,goodfits],params[7,goodfits],xlab="theta1",ylab="theta2", main="theta spread 1")
plot(params[1,goodfits],params[5,goodfits],xlab="x1",ylab="x2")
plot(params[1,goodfits],params[2,goodfits],xlab="x1",ylab="y1")
plot(params[2,goodfits],params[6,goodfits],xlab="y1",ylab="y2")
plot(params[4,goodfits],params[8,goodfits],xlab="width1",ylab="width2")

save(params, goodfits, list=c("params", "goodfits"), file="environment/paramPCA.RData")


#### PARAMETER PCA APPROACH ###############################################################
# Assuming normality of goodfit distributions, I will 

#### EVALUATION #################################################################

#this code calculates the distance between each real one
#and its nearest randomly generated one

dists10k = nearest10k -d1
dists10k = apply(dists10k^2,2,sum)

# NOTE: the fit here is not meant to be partiularly good. We expanded the range
# for the uniform RV theta1 in order to get a better view of the distribution of
# theta parameters
par(mfrow=c(2,1))
hist(dists10k, main="Fits 10k 1's using Uniform RV")
hist(dists100k, main="Fits 100k 1's using Uniform RV")

save(params, goodfits, list=c("params", "goodfits"), file="environment/paramPCA.RData")

