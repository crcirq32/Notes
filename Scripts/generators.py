import sys, cProfile

nums_squared_lc = [num**2 for num in range(10000)]
nums_squared_gc = (num**2 for num in range(10000))

sys.getsizeof(nums_squared_lc)
sys.getsizeof(nums_squared_gc)

#print(nums_squared_lc)
#print(nums_squared_gc)

cProfile.run('sum([i*2for i in range(10000)])')
cProfile.run('sum((i*2for i in range(10000)))')
