#------ TASK 1 ------

# 1.Create a vector of five ones
rep(1, 5)

# 2.Create a vector that counts down from 10 to 0
10:0

# 3.Use rep() to create a vector like:
# [1 1 1 2 2 2 3 3 3 1 1 1 2 2 2 3 3 3]
rep(1:3, times = 2, each = 3)

#------ TASK 2 ------

# Create a vector filled with 10 numbers drawn from the uniform distribution
# (hint: use function runif) and store them in x
x = runif(10)

# Using logical subsetting as above,
# get all the elements of x which are larger than 0.5,
# and store them in y
y = x[ x > 0.3]

# Using the function which,
# store the indices of all the elements of x which are larger than 0.5 in iy
iy = which(x > 0.3)

# Check that y and x[iy] are identical.
all(y == x[iy])
