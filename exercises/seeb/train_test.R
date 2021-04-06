orig_data = read.table("../../data/seeb/four_salmon_pops.csv",header=TRUE,colClasses="character",sep=",")
set.seed(100) #to ensure reproducibility

#Convert the data at each locus to a factor
#Note that we have to be careful to include all the levels from *both* columns
#for each locus
mylevels= function(locus){levels(factor(c(orig_data[,(1+2*locus)],
                                          orig_data[,(2+2*locus)])))}


#now set up four_salmon_pops
four_salmon_pops = orig_data
for(locus in 1:12){
  four_salmon_pops[,1+2*locus]= factor(four_salmon_pops[,1+2*locus],levels = mylevels(locus))
  four_salmon_pops[,2+2*locus]= factor(four_salmon_pops[,2+2*locus],levels = mylevels(locus))
}


#Randomly divide the data into a training set and a test set
nsamp = nrow(four_salmon_pops)
subset = (rbinom(nsamp,1,0.5)==1) #include each fish in subset with probability 0.5
train = four_salmon_pops[subset,]
test = four_salmon_pops[!subset,]


#this function computes a table of the alleles and their counts at a given locus (locus= 1...12)
#in a given data frame (data)
compute_counts = function(data,locus){
  return(table(data[,1+2*locus]) + table(data[,2+2*locus]))
}

#Here's an example of how this can be used
#to compute the allele frequencies (both the counts and the proportions) in the training set
trainc = list()
for(i in 1:locus){trainc[[i]]= compute_counts(train,i)}

normalize= function(x){x/sum(x)}
trainf = lapply(trainc,normalize) #compute the proportions, or relative frequencies, from counts

#Here is the Exercise:
#The idea is that you want to see if you can correctly classify the individuals in the test set
#based on the information in the training set.
#1. At each locus, use the training set to estimate the allele frequencies (ie proportions) in each of the four subpopulations. 
#Assume for the remainder of this exercise that these allele frequencies from the training set are the "true" frequencies in each population.
#2. For each individual in the test data set, compute the posterior probability that it arose from each of the four populations, assuming
# that all four populations are equally likely a priori. You can assume that at each locus the two alleles in an indvidual are independent draws from the population allele frequencies. You can further assume that  the 12 loci contribute independently to the likelihood. THat is, the likelihood is defined
# by multiplying the likelihood across loci.
#3. If you ``assign" each individual in the test set to the population that maximizes its posterior probability, 
# what is the error rate? (ie how many individuals are misassigned vs correctly assigned?)
#4. Comment on any problems you came across as you did this exercise, and how you solved them. 

