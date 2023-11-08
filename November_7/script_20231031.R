set.seed(123)

##### Let's start out easy with a Gaussian GLM #####

N_PTS = 30 # Arbitrarily choosing 30 as our sample size for all our modelling efforts

B0_gauss = -1 # intercept
B1_gauss = 3 # slope
SIGMA = 0.5 # standard deviation

rx_gauss = rnorm(N_PTS) # random covariate values
ry_gauss = rnorm(N_PTS, mean = B0_gauss + B1_gauss * rx_gauss, sd = SIGMA) # random y variables, which are causally influenced by covariates

# Mathematically speaking, these should turn out to be the exact same thing, but this response only holds for the Gaussian GLM!
model_fit_least_squares = lm(ry_gauss ~ rx_gauss)
model_fit_glm_R = glm(ry_gauss ~ rx_gauss, family = gaussian(link = "identity"))

# Now let's try writing this on our own
neg_logLik_glm_gaussian = function(pars, Y, X) {
  # pars: vector with our three parameter values (intercept, slope, log of variance)
  # Y: vector with all the response variables
  # X: vector with all the covariates (should be the same length as Y)
  
  linear_predictor = pars[1] + pars[2] * X # the mean of the Gaussian distribution from which each value of Y supposedly came from is equal to (intercept + slope * X)
  
  # A few reminders: we use log = TRUE in the "dnorm" call because we are computing the log-likelihood. Additionally, while the true likelihood of the data is a product of each data point, when we do the log of a produce we get a sum of a bunch of log's, so we can just sum over each of the dnorm's here. And lastly, notice we take the exponent of pars[2]. This forces it to always be greater than 0 and this way we don't have to impose any optimization bounds if we don't want to.
  -sum(dnorm(Y, mean = linear_predictor, sd = exp(pars[3]), log = TRUE))
}

# A few reminders here: The "par" argument just represents the "initial guess" given to the optimization algorithm. This typically doesn't matter but can be very influential with more complex models (sometimes it is smart to run optim() with multiple initial guesses). I have selected "Nelder-Mead" for the method here; I didn't have to actually put this because this is the default value for the "method" argument, but just reminding that there are many different optimization algorithms available to you within optim. They all have their pros and cons, and there are many other algorithms that are not supported by optim (see nlminb, bobyqa, optimx if interested).
model_fit_glm_from_scratch = optim(par = c(0, 0, 0), fn = neg_logLik_glm_gaussian, method = "Nelder-Mead", X = rx_gauss, Y = ry_gauss)

# Once again, it should give the same result as the other ones!

##### Now let's try a binomial GLM #####

N_PTS = 300 # Going to increase the sample size here as we add more parameters and also increase the complexity of the model!

B0_binom = 0.2
B1_binom = c(1.5, -0.7, 0.1) # Let's spice things up a bit, too, and try with a few different covariates

# Going to write a little helper function that we will use quite a lot to fit our binomial model
expit_helper = function(x) 1 / (1 + exp(-x)) # this is a "logistic" function with the sigmoidal shape you all know and love!

rx_binom = matrix(nrow = N_PTS, ncol = length(B1_binom), data = runif(N_PTS * length(B1_binom)))
ry_binom = rbinom(N_PTS, size = 1, prob = expit_helper(B0_binom + rx_binom %*% B1_binom))

# Let's use the R glm() function and see what we get, as a reference. You can try fitting these data with lm() and now, since we are using binomial data, the result will be quite different!
model_fit_glm_binom_R = glm(ry_binom ~ rx_binom[, 1] + rx_binom[, 2] + rx_binom[, 3], family = binomial(link = "logit"))

# Now let's write one of our own
neg_logLik_glm_binomial = function(pars, Y, X) {
  # pars now includes the intercept as the first entry, and then a (potentially variable) number of slopes. The way we write this function will allow us to use the same function to fit a model with any number of covariates! Similarly, X is expected to be a matrix where each column represents a different predictor variable
  
  # The %*% operator does matrix multiplication between two R objects (either vectors or matrices). This is convenient shorthand for 
  linear_predictor = pars[1] + X %*% pars[-1]
  
  # We use the expit_helper() function to transform our linear predictor to something that is, well, non-linear, and bound between 0 and 1. This is why the R glm() function has the "link = "logit"" thing there - because that's the function we use to transform our values back from 0's and 1's to "linear" results, if we need to.
  expit_predictor = expit_helper(linear_predictor)
  
  # The "size" parameter in the binomial distribution represents the number of trials. Here we always have at most one trial because our data cannot be greater than 1, so we keep the "size" parameter fixed. 
  -sum(dbinom(Y, size = 1, prob = expit_predictor, log = TRUE)) # If this line of code looks a bit familiar, it's because it is very similar to the Gaussian GLM we already wrote!
}

model_fit_glm_binom_from_scratch = optim(par = rep(0, 4), fn = neg_logLik_glm_binomial, method = "Nelder-Mead", X = rx_binom, Y = ry_binom)
# Answers should be, pretty much, the same. Any decimal dust is likely a result of how R will use a different optimization algorithm (probably a better one, if I had to guess!) than what we wrote manually with optim().

##### Some "experiments" with mixed-effects regression #####

# install.packages("glmmTMB") if necessary
require(glmmTMB)

N_PTS_PER_GROUP = 30
N_GROUPS = 5

SIGMA_R = 2
SIGMA_F = 1
B_0 = 0.75
B_1 = -3

u_groups = rnorm(5, SIGMA_R)

r_x = rnorm(N_PTS_PER_GROUP * N_GROUPS)

y_groups = rep(1:N_GROUPS, each = N_PTS_PER_GROUP)
r_y = rnorm(N_PTS_PER_GROUP * N_GROUPS, B_0 + B_1 * r_x + u_groups[y_groups], SIGMA_F)

# Fit a GLMM with only the random intercept
model_fit_glmmTMB_intercept = glmmTMB(r_y ~ r_x + (1 | y_groups), family = gaussian())
model_fit_glmmTMB_slope = glmmTMB(r_y ~ r_x + (0 + r_x | y_groups), family = gaussian())
model_fit_glmmTMB_intercept_slope = glmmTMB(r_y ~ r_x + (1 + r_x | y_groups), family = gaussian())

# Rudimentarily, we can use something like AIC to compare the three models and see which one is best, and it might suggest to us that the intercept-only model is most parsimonious for these data.