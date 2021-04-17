#this function draws a stroke on a 16x16 image
#the arguments are x1,y1 the coordinates of the start point
#theta is its angle
#len is its length and width is its width

# GOAL: in this program I intend to find distributions of good parameter fits
# to improve simulation process for model digits and increase accuracy

# set working directory
setwd("C:/Users/joluw/OneDrive - Dublin City University/Documents/r_projects/ca274")
stroke = function(x1,y1,theta,len,width)
{
x=c(1:16)
y=c(1:16)

x=x-x1
y=y-y1
u1=x*cos(theta)
u2=y*sin(theta)
u=matrix(u1,16,16)+t(matrix(u2,16,16))


v1=-x*sin(theta)
v2=y*cos(theta)
v=matrix(v1,16,16)+t(matrix(v2,16,16))

m = (v > 0 & v < len)
exp(-u*u/width)*m
}


#here is an example of how to use it
s1=stroke(14,14,0.55*pi,15,2)
dim(s1)
# [1] 16 16
image(c(1:16),c(1:16),s1,col=gray(c(0:256)/256),xlab="",ylab="",mar=c(1,1,1,1))


#this shows how to add two strokes together to create an image im
s1=stroke(14,14,pi/2,15,2)
s2=stroke(14,14,pi*0.75,15,2)
im=s1+s2
im[im > 1]=1  #this thresholds the image so that the max brightness is 1
image(c(1:16),c(1:16),im,col=gray(c(0:256)/256),xlab="",ylab="",mar=c(1,1,1,1))


#this loop generates random ones
#the images are stored in the matrix b
#b has the same dimensions as the matrix d in our previous work
params=matrix(0,8,10000)
b=matrix(0,256,10000) #in the lecture I used values of 10,000 and 100,000
proc.time()
m <- 10000
for(i in c(1:m))
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
width2=runif(1,0.5,2)#new upper limit 3

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
b[,i]=im


#readline()
}
proc.time()

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

#this is the same code as we used last week to find the 40 nearest neighbours
#however, this time we are searching matrix b rather than d
nbrs = matrix(0,40,1000)
start <- proc.time()[[3]]
for(i in c(1:1000))nbrs[,i]=findnns(b,d1[,i])
end <- proc.time()[[3]]
print(paste0("time taken: ", end-start))


#this code displays each real digit next to its nearest neighbour in matrix b
#we can see the match between the real digit and the randomly generated digit
par(mfrow=c(2,1))
for(i in c(1:1000))
#for(i in group)
{
z = matrix(d1[,i],16,16) # the real digit
image(c(1:16),c(1:16),z[,16:1],col=gray(c(0:256)/256),xlab="",ylab="",mar=c(1,1,1,1))
z = matrix(b[,nbrs[1,i]],16,16) #the nearest neighbour in matrix b
image(c(1:16),c(1:16),z[,16:1],col=gray(c(0:256)/256),xlab="",ylab="",mar=c(1,1,1,1))
readline()
}

nearest = b[,nbrs[1,]]
dim(nearest)

#this code calculates the distance between each real one
#and its nearest randomly generated one
dists = nearest -d1
dists = apply(dists^2,2,sum)

dev.new()
hist(dists)

#this code selects extreme bad matches
group = which(dists > 2000000)



goodfits=nbrs[1,dists < 800000]


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

#in the code below 
#variables ending in "100k" were created using 100,000 random digits
#variables ending in "10k" were created using 10,000 random digits
#variables ending in "p100k" were created using 100,000 random digits
#and the extended model (i.e. limits on width1 of 3 and theta2 of pi*1.1)
#variables ending in "p10k" were created using 10,000 random digits
#and the extended model

nearest100k = b100k[,nbrs100k[1,]]
dim(nearest100k)


dists100k = nearest100k -d1
dists100k = apply(dists100k^2,2,sum)

hist(dists10k,breaks=c(0:12)*250000,ylim=c(0,500))
hist(dists100k,breaks=c(0:12)*250000,ylim=c(0,500))



hist(distsp10k,breaks=c(0:12)*250000,ylim=c(0,500))
hist(distsp100k,breaks=c(0:12)*250000,ylim=c(0,500))


#### DISTRIBUTIONS ##########################################################

# theta 1 good fits approximately ~ Normal(2.2422,0.1357)
# theta 2 good fits approximately ~ Normal(2.8853,0.1746^2)


