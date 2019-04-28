results = []

for x in data:
    y = delayed(inc)(x)
    results.append(y)
    
total = delayed(sum)(results)

# Let's see what type of thing total is
print("Printing total: ", total)

# Compuing ...
result = total.compute()
print("Printing result from computing total:", result)
