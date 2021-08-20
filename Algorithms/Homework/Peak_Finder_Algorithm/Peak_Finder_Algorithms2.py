#!/usr/bin/env python
# coding: utf-8

# # 1D Peak Finder Algorithms

# ## Import Statements



import numpy as np
from random import randint
from timeit import timeit
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

def run_time_tests():
    while True:
        ans = input('Do you wish to run the millisecond time tests?\nTHIS WILL SIGNIFICANTLY INCREASE RUN TIME!!\n[Y]es/[N]o:')
        if ans.lower() in ['y', 'yes']:
            return True
        elif ans.lower() in ['n','no']:
            return False
        else:
            print('INVALID INPUT\n')
            continue

mstt = run_time_tests()


# ## Worst Case Scenarios


print('\nInitializing worst case scenario test lists...')
WC10000 = [x for x in range(0,10000)] #10000 numbers
WC1000 = [x for x in range(0,1000)] #1000 numbers
WC100 = [x for x in range(0,100)] #100 numbers
WC10 = [x for x in range(0,10)] #10 numbers
print('Done')

# ## Random Lists


print('\nInitializing Random number test lists...')
RL10000 = [randint(0,100) for x in range(0,10000)] #10000 numbers
RL1000 = [randint(0,100) for x in range(0,1000)] #1000 numbers
RL100 = [randint(0,100) for x in range(0,100)] #100 numbers
RL10 = [randint(0,100) for x in range(0,10)] #10 numbers
print('Done\n')

# ## Peak Finder 1

# ### Definition


def peak1(A):
    """
    INPUT: A list of numbers
    
    RETURNS: The maximum value and a step count (n)
    """
    n = 0
    p = A[0]
    n += 1 # Set p
    
    for i in range(len(A)):
        n += 2 # Set i and check if
        if A[i] > p:
            p = A[i]
            n += 1 # Set p
            
    return p,n


# ### Worse Case Tests

print("\nWorst Case Scenario tests of Peak Finder 1\n")
p1WC10000 = peak1(WC10000)
print('[10000] Peak Finder 1 found peak: {} in {} steps'.format(p1WC10000[0],p1WC10000[1]))

p1WC1000 = peak1(WC1000)
print('[1000] Peak Finder 1 found peak: {} in {} steps'.format(p1WC1000[0],p1WC1000[1]))

p1WC100 = peak1(WC100)
print('[100] Peak Finder 1 found peak: {} in {} steps'.format(p1WC100[0],p1WC100[1]))

p1WC10 = peak1(WC10)
print('[10] Peak Finder 1 found peak: {} in {} steps'.format(p1WC10[0],p1WC10[1]))



# ### Random List Tests

print("\nRandom List tests of Peak Finder 1\n")
p1RL10000 = peak1(RL10000)
print('[10000] Peak Finder 1 found peak: {} in {} steps'.format(p1RL10000[0],p1RL10000[1]))

p1RL1000 = peak1(RL1000)
print('[1000] Peak Finder 1 found peak: {} in {} steps'.format(p1RL1000[0],p1RL1000[1]))

p1RL100 = peak1(RL100)
print('[100] Peak Finder 1 found peak: {} in {} steps'.format(p1RL100[0],p1RL100[1]))

p1RL10 = peak1(RL10)
print('[100] Peak Finder 1 found peak: {} in {} steps'.format(p1RL100[0],p1RL100[1]))




# ### Time Tests


# #### The time test of the 10,000 digit lists were omitted because of the time involved
if mstt:
    print('\nCalculating rum_time of Peak Finder 1 in ms.\nThis may take a while...')
    p1WC1000T = timeit('peak1(WC1000)', globals=globals())
    p1WC100T = timeit('peak1(WC100)', globals=globals())
    p1WC10T = timeit('peak1(WC10)', globals=globals())
    p1RL1000T = timeit('peak1(RL1000)', globals=globals())
    p1RL100T = timeit('peak1(RL100)', globals=globals())
    p1RL10T = timeit('peak1(RL10)', globals=globals())
    print('Done\n')

# ## Peak Finder 2
# In order to overcome an IndexError, this algorithm was inplemented in two different ways.

# ### Type A
# #### Definition


def peak2a(A):
    """
    INPUT: A list of numbers
    
    RETURNS: The first peak value and a step count (n)
    """
    n = 0
    
    p = A[0]
    n += 1 # Set p
    
    j=1
    n += 1 # Set j
    
    while j < (len(A)) and p < A[j]:
        n += 1 # Check while
        try:
            p = A[j]
            n += 1 # set p
            
            j += 1
            n += 1 # set j
        except IndexError:
            break
            
    return p,n


# ### Worse Case Tests

print("\nWorst Case Scenario tests of Peak Finder 2 Type A\n")
p2aWC10000 = peak2a(WC10000)
print('[10000] Peak Finder 2a found peak: {} in {} steps'.format(p2aWC10000[0],p2aWC10000[1]))

p2aWC1000 = peak2a(WC1000)
print('[1000] Peak Finder 2a found peak: {} in {} steps'.format(p2aWC1000[0],p2aWC1000[1]))

p2aWC100 = peak2a(WC100)
print('[100] Peak Finder 2a found peak: {} in {} steps'.format(p2aWC100[0],p2aWC100[1]))

p2aWC10 = peak2a(WC10)
print('[10] Peak Finder 2a found peak: {} in {} steps'.format(p2aWC10[0],p2aWC10[1]))


# ### Random List Tests

print("\nRandom List tests of Peak Finder 2 Type A\n")
p2aRL10000 = peak2a(RL10000)
print('[10000] Peak Finder 2a found peak: {} in {} steps'.format(p2aRL10000[0],p2aRL10000[1]))

p2aRL1000 = peak2a(RL1000)
print('[1000] Peak Finder 2a found peak: {} in {} steps'.format(p2aRL1000[0],p2aRL1000[1]))

p2aRL100 = peak2a(RL100)
print('[100] Peak Finder 2a found peak: {} in {} steps'.format(p2aRL100[0],p2aRL100[1]))

p2aRL10 = peak2a(RL10)
print('[100] Peak Finder 2a found peak: {} in {} steps'.format(p2aRL100[0],p2aRL100[1]))



# ### Time Tests

# #### The time test of the 10,000 digit lists were omitted because of thetime involved
if mstt:
    print('\nCalculating rum_time of Peak Finder 2a in ms.\nThis may take a while...')
    p2aWC1000T = timeit('peak2a(WC1000)', globals=globals())
    p2aWC100T = timeit('peak2a(WC100)', globals=globals())
    p2aWC10T = timeit('peak2a(WC10)', globals=globals())
    p2aRL1000T = timeit('peak2a(RL1000)', globals=globals())
    p2aRL100T = timeit('peak2a(RL100)', globals=globals())
    p2aRL10T = timeit('peak2a(RL10)', globals=globals())
    print('Done\n')


# ### Type B
# #### definition

# Type b
def peak2b(A):
    """
    INPUT: A list of numbers
    
    RETURNS: The first peak value and a step count (n)
    """
    n = 0
    
    p = A[0]
    n += 1 # Set p
    
    j=1 # Set j
    n += 1
    
    while j < (len(A)):
        n += 1 # Check while
        if j < (len(A)) and p < A[j]:
            n += 1 # Checked if only
            
            p = A[j]
            n += 1 # Set p
            
            j += 1
            n += 1 # Set j
        else:
            n += 2 # Checked if and else
            break
    return p,n


# ### Worse Case Tests

print("\nWorst Case Scenario tests of Peak Finder 2 Type B\n")
p2bWC10000 = peak2b(WC10000)
print('[10000] Peak Finder 2b found peak: {} in {} steps'.format(p2bWC10000[0],p2bWC10000[1]))

p2bWC1000 = peak2b(WC1000)
print('[1000] Peak Finder 2b found peak: {} in {} steps'.format(p2bWC1000[0],p2bWC1000[1]))

p2bWC100 = peak2b(WC100)
print('[100] Peak Finder 2b found peak: {} in {} steps'.format(p2bWC100[0],p2bWC100[1]))

p2bWC10 = peak2b(RL10)
print('[10] Peak Finder 2b found peak: {} in {} steps'.format(p2bWC10[0],p2bWC10[1]))


# ### Random List Tests

print("\nRandom List tests of Peak Finder 2 Type B\n")
p2bRL10000 = peak2b(RL10000)
print('[10000] Peak Finder 2b found peak: {} in {} steps'.format(p2bRL10000[0],p2bRL10000[1]))

p2bRL1000 = peak2b(RL1000)
print('[1000] Peak Finder 2b found peak: {} in {} steps'.format(p2bRL1000[0],p2bRL1000[1]))

p2bRL100 = peak2b(RL100)
print('[100] Peak Finder 2b found peak: {} in {} steps'.format(p2bRL100[0],p2bRL100[1]))

p2bRL10 = peak2b(WC10)
print('[100] Peak Finder 2b found peak: {} in {} steps'.format(p2bRL100[0],p2bRL100[1]))


# ### Time Tests

# #### The time test of the 10,000 digit lists were omitted because of thetime involved
if mstt:
    print('\nCalculating rum_time of Peak Finder 2b in ms.\nThis may take a while...')
    p2bWC1000T = timeit('peak2b(WC1000)', globals=globals())
    p2bWC100T = timeit('peak2b(WC100)', globals=globals())
    p2bWC10T = timeit('peak2b(WC10)', globals=globals())
    p2bRL1000T = timeit('peak2b(RL1000)', globals=globals())
    p2bRL100T = timeit('peak2b(RL100)', globals=globals())
    p2bRL10T = timeit('peak2b(RL10)', globals=globals())
    print('Done\n')


# ## Peak Finder 3


def peak3(A, n=0):
    """
    INPUT: A list of numbers and a step count
    
    RETURNS: A peak and a step count (n)
    """
    n += 1 # Check if
    if len(A) == 1:
        return A[0], n
    
    m = int(len(A)/2)
    n += 1 # Set m
    
    if A[m] < A[m-1]:
        n += 1 # Checked if only
        return peak3(A[:m], n)
    elif m+1 < len(A) and A[m] < A[m+1]:
        n += 2 # Checked if and elif only
        return peak3(A[m:], n)
    else: 
        n += 3 # Checked if, elif, and else
        return A[m], n


# ### Worse Case Tests

print("\nWorst Case Scenario tests of Peak Finder 3\n")
p3WC10000 = peak3(WC10000)
print('[10000] Peak Finder 3 found peak: {} in {} steps'.format(p3WC10000[0],p3WC10000[1]))

p3WC1000 = peak3(WC1000)
print('[1000] Peak Finder 3 found peak: {} in {} steps'.format(p3WC1000[0],p3WC1000[1]))

p3WC100 = peak3(WC100)
print('[100] Peak Finder 3 found peak: {} in {} steps'.format(p3WC100[0],p3WC100[1]))

p3WC10 = peak3(WC10)
print('[10] Peak Finder 3 found peak: {} in {} steps'.format(p3WC10[0],p3WC10[1]))


# ### Random List Tests

print("\nRandom List tests of Peak Finder 3\n")
p3RL10000 = peak3(RL10000)
print('[10000] Peak Finder 3 found peak: {} in {} steps'.format(p3RL10000[0],p3RL10000[1]))

p3RL1000 = peak3(RL1000)
print('[1000] Peak Finder 3 found peak: {} in {} steps'.format(p3RL1000[0],p3RL1000[1]))

p3RL100 = peak3(RL100)
print('[100] Peak Finder 3 found peak: {} in {} steps'.format(p3RL100[0],p3RL100[1]))

p3RL10 = peak3(RL10)
print('[100] Peak Finder 3 found peak: {} in {} steps'.format(p3RL100[0],p3RL100[1]))


# ### Time Tests

# #### The time test of the 10,000 digit lists were omitted because of thetime involved
if mstt:
    print('\nCalculating rum_time of Peak Finder 3 in ms.\nThis may take a while...')
    p3WC1000T = timeit('peak3(WC1000)', globals=globals())
    p3WC100T = timeit('peak3(WC100)', globals=globals())
    p3WC10T = timeit('peak3(WC10)', globals=globals())
    p3RL1000T = timeit('peak3(RL1000)', globals=globals())
    p3RL100T = timeit('peak3(RL100)', globals=globals())
    p3RL10T = timeit('peak3(RL10)', globals=globals())
    print('Done\n')


# ## Step Count Visualizations
# Only the worse case scenarios will be graphed since they are the most useful for comparison

print('\nCreating pandas DataFrame objects and visualizations for the 1D step count tests.\n')
data_1D_SC = {'algorithm':['Peak Finder 1','Peak Finder 1','Peak Finder 1','Peak Finder 1',
                     'Peak Finder 2a', 'Peak Finder 2a', 'Peak Finder 2a', 'Peak Finder 2a',
                     'Peak Finder 2b', 'Peak Finder 2b', 'Peak Finder 2b', 'Peak Finder 2b',
                     'Peak Finder 3', 'Peak Finder 3', 'Peak Finder 3', 'Peak Finder 3',],
       'n':['10000', '1000', '100', '10', '10000', '1000', '100', '10', 
            '10000', '1000', '100', '10', '10000', '1000', '100', '10'],
       'step_count':[p1WC10000[1], p1WC1000[1], p1WC100[1], p1WC10[1], 
                     p2aWC10000[1], p2aWC1000[1], p2aWC100[1], p2aWC10[1], 
                     p2bWC10000[1], p2bWC1000[1], p2bWC100[1], p2bWC10[1], 
                     p3WC10000[1], p3WC1000[1], p3WC100[1], p3WC10[1]]}


df_1D_SC = pd.DataFrame(data_1D_SC)

plt.figure(figsize=(12,8))
plt.title('1D Peak Finder Step Counts')
sns.barplot(x='n', y='step_count', hue='algorithm', data = df_1D_SC, palette = 'viridis')


df_1D_SC_pivot = df_1D_SC.pivot_table(values = 'step_count', index = ['n', 'algorithm'])
print('Done')

# ## Time Test Visualizations
# Only the worse case scenarios will be graphed since they are the most useful for comparison
if mstt:
    print('\nCreating pandas DataFrame objects and visualizations for the 1D run time tests.')
    data_1D_RT = {'algorithm':['Peak Finder 1','Peak Finder 1','Peak Finder 1',
                          'Peak Finder 2a', 'Peak Finder 2a', 'Peak Finder 2a',
                          'Peak Finder 2b', 'Peak Finder 2b', 'Peak Finder 2b',
                          'Peak Finder 3', 'Peak Finder 3', 'Peak Finder 3',],
           'n':['1000', '100', '10',  '1000', '100', '10', 
                '1000', '100', '10', '1000', '100', '10'],
           'run_time':[p1WC1000T, p1WC100T, p1WC10T, 
                       p2aWC1000T, p2aWC100T, p2aWC10T, 
                       p2bWC1000T, p2bWC100T, p2bWC10T, 
                       p3WC1000T, p3WC100T, p3WC10T]}
    
    df_1D_RT = pd.DataFrame(data_1D_RT)
    
    plt.figure(figsize=(12,8))
    plt.title('1D Peak Finder Run Times')
    sns.barplot(x='n', y='run_time', hue='algorithm', data = df_1D_RT, palette = 'viridis')
    
    
    df_1D_RT.pivot_table(values = 'run_time', index = ['n', 'algorithm'])
    print('Done')

# # 2D Peak Finder Algorithms

# ## Test Arrays

print('\nCreating 2D worst case scenario test arrays')
twoBy = np.array([[1,4], 
                  [2,3]]) # 2x2
threeBy = np.array([[1,0,7], 
                    [2,0,6], 
                    [3,4,5]]) # 3x3
fourBy = np.array([[1,0,9,10], 
                    [2,0,8,0], 
                    [3,0,7,0], 
                    [4,5,6,0]]) # 4x4
fiveBy = np.array([[1,0,11,12,13], 
                    [2,0,10,0,14], 
                    [3,0,9,0,15], 
                    [4,0,8,0,16], 
                    [5,6,7,0,17]]) # 5x5
sixBy = np.array([[1,0,13,14,15,0], 
                  [2,0,12,0,16,0], 
                  [3,0,11,0,17,0], 
                  [4,0,10,0,18,0], 
                  [5,0,9,0,19,0], 
                  [6,7,8,0,20,21]]) # 6x6
sevenBy = np.array([[1,0,15,16,17,0,31], 
                    [2,0,14,0,18,0,30], 
                    [3,0,13,0,19,0,29], 
                    [4,0,12,0,20,0,28], 
                    [5,0,11,0,21,0,27], 
                    [6,0,10,0,22,0,26], 
                    [7,8,9,0,23,24,25]]) # 7x7
eightBy = np.array([[1,0,17,18,19,0,35,36], 
                    [2,0,16,0,20,0,34,0], 
                    [3,0,15,0,21,0,33,0], 
                    [4,0,14,0,22,0,32,0], 
                    [5,0,13,0,23,0,31,0], 
                    [6,0,12,0,24,0,30,0], 
                    [7,0,11,0,25,0,29,0], 
                    [8,9,10,0,26,27,28,0]]) # 8x8
nineBy = np.array([[1,0,19,20,21,0,39,40,41], 
                    [2,0,18,0,22,0,38,0,42], 
                    [3,0,17,0,23,0,37,0,43], 
                    [4,0,16,0,24,0,36,0,44], 
                    [5,0,15,0,25,0,35,0,45], 
                    [6,0,14,0,26,0,34,0,46], 
                    [7,0,13,0,27,0,33,0,47], 
                    [8,0,12,0,28,0,32,0,48],
                    [9,10,11,0,29,30,31,0,49]]) # 9x9
nineByRev = np.array([[49,0,31,30,29,0,39,40,41], 
                    [48,0,32,0,28,0,38,0,42], 
                    [47,0,33,0,27,0,37,0,43], 
                    [46,0,34,0,26,0,36,0,44], 
                    [45,0,35,0,25,0,35,0,45], 
                    [44,0,36,0,24,0,34,0,46], 
                    [43,0,37,0,23,0,33,0,47], 
                    [42,0,38,0,22,0,18,0,48],
                    [41,40,39,0,21,20,19,0,49]]) # 9x9
nineByT = nineBy.transpose()
nineByRand = np.array([[randint(0,100) for x in range(0,9)] for x in range(0,9)])
eightByNS = eightBy.reshape(2,32)
print('Done\n')

# ## 2D Peak Finder 1

# #### Definition


def peak2D1(A,n=0):
    """
    INPUT: A 2D array of integers (A), and an internal counter value (n)
    
    RETURNS: The maximum value of the array
    """
    p = A[0,0]
    n +=1 # Set p
    
    for i in range(len(A[0,:])):
        n += 1 #Set i
        for j in range(len(A[:,i])):
            n += 2 # Set j and check if
            if A[j,i] >p:
                p = A[j,i]
                n +=1 # Set p
    return p, n


# #### Tests

print("\nWorst Case Scenario tests of 2D Peak Finder 1\n")
twoByP1 = peak2D1(twoBy)
print('[2x2] 2D Peak Finder 1 found peak: {} in {} steps'.format(twoByP1[0],twoByP1[1]))

threeByP1 = peak2D1(threeBy)
print('[3x3] 2D Peak Finder 1 found peak: {} in {} steps'.format(threeByP1[0],threeByP1[1]))

fourByP1 = peak2D1(fourBy)
print('[4x4] 2D Peak Finder 1 found peak: {} in {} steps'.format(fourByP1[0],fourByP1[1]))

fiveByP1 = peak2D1(fiveBy)
print('[5x5] 2D Peak Finder 1 found peak: {} in {} steps'.format(fiveByP1[0],fiveByP1[1]))

sixByP1 = peak2D1(sixBy)
print('[6x6] 2D Peak Finder 1 found peak: {} in {} steps'.format(sixByP1[0],sixByP1[1]))

sevenByP1 = peak2D1(sevenBy)
print('[7x7] 2D Peak Finder 1 found peak: {} in {} steps'.format(sevenByP1[0],sevenByP1[1]))

eightByP1 = peak2D1(eightBy)
print('[8x8] 2D Peak Finder 1 found peak: {} in {} steps'.format(eightByP1[0],eightByP1[1]))

nineByP1 = peak2D1(nineBy)
print('[9x9] 2D Peak Finder 1 found peak: {} in {} steps'.format(nineByP1[0],nineByP1[1]))


# #### Functional Tests on Transpose, Reverse, Random, and Non-Square Arrays
print('\nPerforming functional test on Transpose, Reverse, Random, and Non-Square Arrays\n')
print('[9x9 reversed] 2D Peak Finder 1 found peak: {} in {} steps'.format(peak2D1(nineByRev)[0],peak2D1(nineByRev)[1])) # Reversed
print('[9x9 transpose] 2D Peak Finder 1 found peak: {} in {} steps'.format(peak2D1(nineByT)[0],peak2D1(nineByT)[1])) # Transposed
print('[2x32 non-square] 2D Peak Finder 1 found peak: {} in {} steps'.format(peak2D1(eightByNS)[0],peak2D1(eightByNS)[1])) # Non-Square
print('[9x9 random int] 2D Peak Finder 1 found peak: {} in {} steps'.format(peak2D1(nineByRand)[0],peak2D1(nineByRand)[1])) # Random Integers



# #### Time Tests
if mstt:
    print('\nCalculating rum_time for 2D Peaak Finder 1 in ms.\nThis may take a while...')
    twoByP1T = timeit('peak2D1(twoBy)', globals=globals())
    threeByP1T = timeit('peak2D1(threeBy)', globals=globals())
    fourByP1T = timeit('peak2D1(fourBy)', globals=globals())
    fiveByP1T = timeit('peak2D1(fiveBy)', globals=globals())
    sixByP1T = timeit('peak2D1(sixBy)', globals=globals())
    sevenByP1T = timeit('peak2D1(sevenBy)', globals=globals())
    eightByP1T = timeit('peak2D1(eightBy)', globals=globals())
    nineByP1T = timeit('peak2D1(nineBy)', globals=globals())
    print('Done\n')

# ## 2D Peak Finder 2


def peak2D2(A, n=0):
    """
    INPUT: A 2D DataFrame object (A) and an internal counter value (n)
    
    RETURNS: A Peak value (the first peak value encountered)
    """
    n += 1 # Check if
    if len(A.shape) == 1:
        return A.max(), n
        
    else:
        n += 1 # Checked else
        num_rows, num_cols = A.shape
        n += 1 # Set num_cols and num_rows
    
    m = int((num_cols / 2))
    n += 1 # Set m
    
    q = A[:,m].argmax()
    n += 1 # Set q
    
    if m >= 1 and A[q,m] < A[q,m-1]:
        n += 1 # Checked if only
        return peak2D2(A[:,:m], n)
    elif m+1 <= num_cols-1 and A[q,m] < A[q,m+1]:
        n += 2 # Checked if and elif
        return peak2D2(A[:,m:], n)
    else:
        n += 3 # Checked if, elif, and else
        return peak2D2(A[:,m], n)


# #### Tests
print("\nWorst Case Scenario tests of 2D Peak Finder 2\n")
twoByP2 = peak2D2(twoBy)
print('[2x2] 2D Peak Finder 2 found peak: {} in {} steps'.format(twoByP2[0],twoByP2[1]))

threeByP2 = peak2D2(threeBy)
print('[3x3] 2D Peak Finder 2 found peak: {} in {} steps'.format(threeByP2[0],threeByP2[1]))

fourByP2 = peak2D2(fourBy)
print('[4x4] 2D Peak Finder 2 found peak: {} in {} steps'.format(fourByP2[0],fourByP2[1]))

fiveByP2 = peak2D2(fiveBy)
print('[5x5] 2D Peak Finder 2 found peak: {} in {} steps'.format(fiveByP2[0],fiveByP2[1]))

sixByP2 = peak2D2(sixBy)
print('[6x6] 2D Peak Finder 2 found peak: {} in {} steps'.format(sixByP2[0],sixByP2[1]))

sevenByP2 = peak2D2(sevenBy)
print('[7x7] 2D Peak Finder 2 found peak: {} in {} steps'.format(sevenByP2[0],sevenByP2[1]))

eightByP2 = peak2D2(eightBy)
print('[8x8] 2D Peak Finder 2 found peak: {} in {} steps'.format(eightByP2[0],eightByP2[1]))

nineByP2 = peak2D2(nineBy)
print('[9x9] 2D Peak Finder 2 found peak: {} in {} steps'.format(nineByP2[0],nineByP2[1]))


# #### Functional Tests on Transpose, Reverse, and Non-Square Arrays

# NOTE: Peak Finder 2 finds one peak (the first encountered) and not the maximum value 
#        7 is a peak value in the non-square array eightByNS

print('\nPerforming functional test on Transpose, Reverse, Random, and Non-Square Arrays\n')
print('[9x9 reversed] 2D Peak Finder 2 found peak: {} in {} steps'.format(peak2D2(nineByRev)[0],peak2D2(nineByRev)[1])) # Reversed
print('[9x9 transpose] 2D Peak Finder 2 found peak: {} in {} steps'.format(peak2D2(nineByT)[0],peak2D2(nineByT)[1])) # Transposed
print('[2x32 non-square] 2D Peak Finder 2 found peak: {} in {} steps'.format(peak2D2(eightByNS)[0],peak2D2(eightByNS)[1])) # Non-Square
print('[9x9 random int] 2D Peak Finder 2 found peak: {} in {} steps'.format(peak2D2(nineByRand)[0],peak2D2(nineByRand)[1])) # Random Integers



# #### Time Tests
if mstt:
    print('\nCalculating rum_time for 2D Peaak Finder 2 in ms.\nThis may take a while...')
    twoByP2T = timeit('peak2D2(twoBy)', globals=globals())
    threeByP2T = timeit('peak2D2(threeBy)', globals=globals())
    fourByP2T = timeit('peak2D2(fourBy)', globals=globals())
    fiveByP2T = timeit('peak2D2(fiveBy)', globals=globals())
    sixByP2T = timeit('peak2D2(sixBy)', globals=globals())
    sevenByP2T = timeit('peak2D2(sevenBy)', globals=globals())
    eightByP2T = timeit('peak2D2(eightBy)', globals=globals())
    nineByP2T = timeit('peak2D2(nineBy)', globals=globals())
    print('Done\n')

# ## Step Count Analysis

print('\nCreating pandas DataFrame objects and visualizations for the 2D step count tests.\n')
data_2D_SC = {'algorithm':['2D Peak Finder 1', '2D Peak Finder 1', '2D Peak Finder 1', '2D Peak Finder 1',
                     '2D Peak Finder 1', '2D Peak Finder 1','2D Peak Finder 1', '2D Peak Finder 1',
                     '2D Peak Finder 2', '2D Peak Finder 2', '2D Peak Finder 2', '2D Peak Finder 2',
                     '2D Peak Finder 2', '2D Peak Finder 2','2D Peak Finder 2', '2D Peak Finder 2'],
       'array_size':['2x2', '3x3', '4x4','5x5','6x6','7x7','8x8','9x9',
             '2x2', '3x3', '4x4','5x5','6x6','7x7','8x8','9x9'],
       'step_count':[twoByP1[1], threeByP1[1], fourByP1[1], fiveByP1[1], 
                   sixByP1[1], sevenByP1[1], eightByP1[1], nineByP1[1], 
                   twoByP2[1], threeByP2[1], fourByP2[1], fiveByP2[1], 
                   sixByP2[1], sevenByP2[1], eightByP2[1], nineByP2[1]]}


df_2D_SC = pd.DataFrame(data_2D_SC)

plt.figure(figsize=(12,8))
plt.title('2D Peak Finder Step Counts')
sns.barplot(x='array_size', y='step_count', hue='algorithm', data = df_2D_SC, palette = 'viridis')

df_2D_SC_pivot = df_2D_SC.pivot_table(values = 'step_count', index = ['array_size', 'algorithm'])
print('Done')

# ## Time Test Visualizations
if mstt:
    print('\nCreating pandas DataFrame objects and visualizations for the 2D run time tests.')
    data_2D_RT = {'algorithm':['2D Peak Finder 1', '2D Peak Finder 1', '2D Peak Finder 1', '2D Peak Finder 1',
                         '2D Peak Finder 1', '2D Peak Finder 1','2D Peak Finder 1', '2D Peak Finder 1',
                         '2D Peak Finder 2', '2D Peak Finder 2', '2D Peak Finder 2', '2D Peak Finder 2',
                         '2D Peak Finder 2', '2D Peak Finder 2','2D Peak Finder 2', '2D Peak Finder 2'],
           'array_size':['2x2', '3x3', '4x4','5x5','6x6','7x7','8x8','9x9',
                 '2x2', '3x3', '4x4','5x5','6x6','7x7','8x8','9x9'],
           'run_time':[twoByP1T, threeByP1T, fourByP1T, fiveByP1T, sixByP1T, sevenByP1T, eightByP1T, nineByP1T, 
                       twoByP2T, threeByP2T, fourByP2T, fiveByP2T, sixByP2T, sevenByP2T, eightByP2T, nineByP2T]}
    
    
    df_2D_RT = pd.DataFrame(data_2D_RT)
    
    plt.figure(figsize=(12,8))
    plt.title('2D Peak Finder Run Times')
    sns.barplot(x='array_size', y='run_time', hue='algorithm', data = df_2D_RT, palette = 'viridis')
    
    df_2D_RT_pivot = df_2D_RT.pivot_table(values = 'run_time', index = ['array_size', 'algorithm'])
    
    print('Done')
