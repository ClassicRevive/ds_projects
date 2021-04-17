This file contains the code for carrying out PCA on the model parameters of the sevens


#Please see script Model Parameters.R to generate params and #goodfits
load("params")
load("goodfits")
gp=params[,goodfits]


gp=t(gp)
c=var(gp)
e=eigen(c)
p=gp %*% e$vectors
plot(e$values)
mp=apply(p,2,mean) #computes the mean for each eigenvectors

#this code generated 10000 random values for each eigenvector
#the random values come from a Normal distribution
ranv = matrix(rnorm(130000),13,10000)
ranv = ranv * sqrt(e$values) #sets the standard deviation 
ranv = ranv+mp # sets the mean for each eigenvectors

#this line reconstructs the parameter vectors from the #eigenvectors
#ranv3 contains the 8 parameters for the model
ranv3=t(ranv)%*% t(e$vectors)


plot(ranv3[,1],ranv3[,2])
plot(ranv3[,3],ranv3[,7])

b7=matrix(0,256,10000)
for(i in c(1:10000))
{
x1=ranv3[i,1]
y1=ranv3[i,2]
theta1=ranv3[i,3]
width1=ranv3[i,4]

x2=ranv3[i,5]
y2=ranv3[i,6]
theta2=ranv3[i,7]
width2=ranv3[i,8]

x3=ranv3[i,9]
y3=ranv3[i,10]
theta3=ranv3[i,11]
len3=ranv3[i,12]
width3=ranv3[i,13]


s1=stroke(x1,y1,theta1,20,width1)
s2=stroke(x2,y2,theta2,20,width2)
s3=stroke(x3,y3,theta3,len3,width3)

im=s1+s2+s3
im[im > 1]=1

#image(c(1:16),c(1:16),im,col=gray(c(0:256)/256),xlab7="",ylab7="",mar=c(1,1,1,1))

im = im*256
im = im[,16:1] #we have to turn the image upside-down so that it matches the real digits

im=matrix(im,256,1)

#this is where the new random digit is added to matrix b7
b7[,i]=im


#readline()
}

proc.time()
nb7rspca = matrix(0,40,1000)
for(i in c(1:1000))nb7rspca[,i]=findnns(b7,d7[,i])
proc.time()


nearestpca = b7[,nb7rspca[1,]]
dim(nearestpca)

#this code calculates the distance between each real one
#and its nearest randomly generated one
distspca = nearestpca -d7
distspca = apply(distspca^2,2,sum)


dev.new()
hist(distspca)

b <- cbind(b1, b7)
d <- cbind(d1,d7)
# If you wish to find the accuracy for classifying the ones and the sevens using
# the PCA data. You can generate 10k random ones using the code in model PCA.R 
# and 10k random sevens using the code ab7ove. You can then use the code at the 
# bottom of file sevens.R to do the classification.

# Here is my confusion matrix

       labels
results    1    7
      1 1000   24
      7    0  976

# Joseph's confusion matrix (k=1)

      labels
results    1    7
      1 1000   33
      7    0  967      




