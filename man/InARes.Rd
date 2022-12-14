% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/InARes.R
\name{InARes}
\alias{InARes}
\title{Calculation of the Index for Adaptive Responses}
\usage{
InARes(data, 
       traits = FALSE, 
       traits.mal = FALSE, 
       treatCol = "treatment", 
       ctrl = "control", 
       as.defined = FALSE, 
       rexmax.adapt = FALSE, 
       rexmax.mal = FALSE, 
       na.action = "keep", 
       as.PI = FALSE)
}
\arguments{
\item{data}{A data.frame to be used, which contains the rex transformed values of all traits that should be included.}

\item{traits}{The names of the columns that contains the rex transformed values
of the traits to be incorporated where the adaptiveness is unknown or an increase is considered an adaptation.}

\item{traits.mal}{The names of the columns that contains the rex transformed values
of the traits to be incorporated where an increase is considered as a maladaptation.}

\item{treatCol}{column name of the treatments (defaults to 'treatment'). At the current state, everything that is not control is
considered as one treatment. If there are several treatments in the data set, we recommend to subset the data accordingly.}

\item{ctrl}{the name of the control treatment as set in treatCol (defaults to 'control').}

\item{as.defined}{if TRUE the sign of rexmax will be positive for traits and negative
for traits.mal when used as weighing parameter. If set to FALSE (default) the sign might be
positive or negative for traits (since their adaptiveness is considered unknown), but always negative for traits.mal.
This parameter is thought for cases where the functionality of the traits are unclear and the Index will be evaluated using dContribution().}

\item{rexmax.adapt}{a vector containing values for rexmax for each trait provided in traits.
It can be specified, if one wants to calculate values comparable with other experiments or the literature.
rexmax has to be set for all traits or an NA should be included. Order should be similar to as set
in traits. Each value must be between -1 and 1. Defaults to FALSE (not considered unless provided).}

\item{rexmax.mal}{a vector containing values for rexmax for each trait provided in traits.mal
(works similar as for rexmax.adapt). Order should be similar to as set in traits.
Each value must be between -1 and 1. Defaults to FALSE (not considered unless provided).}

\item{na.action}{Defines the way, how NAs are treated (row wise). Can be either "omit", "keep", or "interpolate".
Defaults to "keep".
When "keep" the InARes value will be NA, if one or more of the trait values contain NA. Usually
recommended for unbiased estimates!
In case of "interpolate", it will use the median value of the trait of the current treatment. However,
this might bias your estimates in some way, if the median of the treatment in this trait is not ??fitting adequately,
but it helps if a lot of NAs occur in fields of different traits. We recommend this way, as a conservative
way to prevent NAs. However, if there are a lot of gaps in your trait data, it may bias the outcome strongly.
When "omit" it calculates the InARes with traits where an NA occurs. In this case, NA-traits are
ignored and number of traits reduced by the number of traits with NA (for each individual). This, however,
may bias the outcome or the later estimation of each traits' contribution. The values may be misleading.
This way is not recommended and should only be used if you are certain about what you do!}

\item{as.PI}{can be set TRUE if the aim is to use this function for calculating an overall plasticity index.
In this case, all traits should be transformed with Trex(..., usemc = 1). Additionally, all traits
should be provided via traits (not traits.mal) and as.defined should be set TRUE. Now you will receive
values that are measures of the mean deviation over all traits from the control mean.}
}
\value{
Returns a list containing the transformed data and additional information like rexmax.
}
\description{
Calculates the Index for Adaptive Responses from several rex transformed traits:
if as.defined = TRUE: InARes = sum((-1) * rex(x) / max( |rex|(all treatments) )) / number of parameter
or
if as.defined = FALSE (default): InARes = sum((-1) * rex(x) / ( max( |rex|(all treatments) )) * median(treatment) / |median(treatment)| ) / number of parameter
The (-1) is only necessary, if we believe that the increase of one trait is maladaptive.
rexmax will be 1 when usemc = 1 was selected in rex transformation.
At the current state, everything that is not control is considered as one treatment. If there are several
treatments in the data set, we recommend to subset the data accordingly.
}
\examples{
# load example data
library(InARes)
mydata <- data.InARes

# first transform trait values with Trex
params <- c("BL", "SL", "BW", "BWL", "Forn", "Furca", "SBAd", "SBAv", "meansld", "meanslv")
for(i in 1:length(params)){
  mydata[, paste(params[i], "_rex", sep = "")] <- Trex(x = mydata[,params[i]],
                                                       y = mydata$induced,
                                                       ctrl = "n")
}

# calculate the InARes in its default form (without a priori knowledge)
results <- InARes(data = mydata,
                  traits = c("BL_rex", "SL_rex", "BW_rex", "BWL_rex", "Forn_rex", 
                             "Furca_rex", "SBAd_rex", "SBAv_rex", "meansld_rex", "meanslv_rex"),
                  treatCol = "induced",
                  ctrl = "n")
# results contains two parts: index and rexmax                 
# InARes contains a vector with the calculated values
mydata$InARes <- results$index
# and rexmax with the values for maximal expression
results$rexmax

# calculate the InARes with adaptive and maladaptive traits, where both are known to be that
results <- InARes(data = mydata,
                  traits = c("BWL_rex", "Forn_rex", "Furca_rex", "SBAd_rex", "SBAv_rex", 
                             "meansld_rex", "meanslv_rex"),
                  traits.mal = c("BL_rex", "SL_rex", "BW_rex"),
                  treatCol = "induced",
                  ctrl = "n",
                  as.defined = TRUE)
                  
# calculate the InARes with rexmax values from literature or preliminary experiments
results <- InARes(data = mydata,
                  traits = c("BL_rex", "SL_rex", "BW_rex", "BWL_rex", "Forn_rex", 
                             "Furca_rex", "SBAd_rex", "SBAv_rex", "meansld_rex", "meanslv_rex"),
                  rexmax.adapt = c(-0.6, 0.8, 0.7, -0.8, 0.6, 0.6, 0.6, 0.5, 0.7, 0.8),
                  treatCol = "induced",
                  ctrl = "n")
                  
}
\references{
TODO: Link to the Publication
}
\seealso{
Trex(), transforms trait values to a relative expression value.

contARes(), can be used to estmate each traits' contribution to the Index of Adaptive Responses.
}
