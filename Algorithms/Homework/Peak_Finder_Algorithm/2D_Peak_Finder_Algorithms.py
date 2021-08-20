#!/usr/bin/env python
# coding: utf-8

# # 2D Peak Finder Algorithms

# ## Import Statements

# In[4]:


import numpy as np
from random import randint
from timeit import timeit
import seaborn as sns
import pandas as pd
import matplotlib.pyplot as plt
get_ipython().run_line_magic('matplotlib', 'inline')


# ## Test Arrays

# In[5]:


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


# ## 2D Peak Finder 1

# #### Definition

# In[6]:


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

# In[7]:


twoByP1 = peak2D1(twoBy)
print('[2x2] 2D Peak Finder 1 found peak: {} in {} steps'.format(twoByP1[0],twoByP1[1]))


# In[8]:


threeByP1 = peak2D1(threeBy)
print('[3x3] 2D Peak Finder 1 found peak: {} in {} steps'.format(threeByP1[0],threeByP1[1]))


# In[9]:


fourByP1 = peak2D1(fourBy)
print('[4x4] 2D Peak Finder 1 found peak: {} in {} steps'.format(fourByP1[0],fourByP1[1]))


# In[10]:


fiveByP1 = peak2D1(fiveBy)
print('[5x5] 2D Peak Finder 1 found peak: {} in {} steps'.format(fiveByP1[0],fiveByP1[1]))


# In[11]:


sixByP1 = peak2D1(sixBy)
print('[6x6] 2D Peak Finder 1 found peak: {} in {} steps'.format(sixByP1[0],sixByP1[1]))


# In[12]:


sevenByP1 = peak2D1(sevenBy)
print('[7x7] 2D Peak Finder 1 found peak: {} in {} steps'.format(sevenByP1[0],sevenByP1[1]))


# In[13]:


eightByP1 = peak2D1(eightBy)
print('[8x8] 2D Peak Finder 1 found peak: {} in {} steps'.format(eightByP1[0],eightByP1[1]))


# In[14]:


nineByP1 = peak2D1(nineBy)
print('[9x9] 2D Peak Finder 1 found peak: {} in {} steps'.format(nineByP1[0],nineByP1[1]))


# #### Functional Tests on Transpose, Reverse, Random, and Non-Square Arrays

# In[15]:


peak2D1(nineByRev) # Reversed


# In[16]:


peak2D1(nineByT) # Transposed


# In[17]:


peak2D1(eightByNS) # Non-Square


# In[18]:


peak2D1(nineByRand) # Random Integers


# In[19]:


nineByRand


# #### Time Tests

# In[256]:


twoByP1T = timeit('peak2D1(twoBy)', globals=globals())


# In[257]:


threeByP1T = timeit('peak2D1(threeBy)', globals=globals())


# In[258]:


fourByP1T = timeit('peak2D1(fourBy)', globals=globals())


# In[259]:


fiveByP1T = timeit('peak2D1(fiveBy)', globals=globals())


# In[260]:


sixByP1T = timeit('peak2D1(sixBy)', globals=globals())


# In[261]:


sevenByP1T = timeit('peak2D1(sevenBy)', globals=globals())


# In[262]:


eightByP1T = timeit('peak2D1(eightBy)', globals=globals())


# In[263]:


nineByP1T = timeit('peak2D1(nineBy)', globals=globals())


# ## 2D Peak Finder 2

# In[20]:


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

# In[21]:


twoByP2 = peak2D2(twoBy)
print('[2x2] 2D Peak Finder 2 found peak: {} in {} steps'.format(twoByP2[0],twoByP2[1]))


# In[22]:


threeByP2 = peak2D2(threeBy)
print('[3x3] 2D Peak Finder 2 found peak: {} in {} steps'.format(threeByP2[0],threeByP2[1]))


# In[23]:


fourByP2 = peak2D2(fourBy)
print('[4x4] 2D Peak Finder 2 found peak: {} in {} steps'.format(fourByP2[0],fourByP2[1]))


# In[24]:


fiveByP2 = peak2D2(fiveBy)
print('[5x5] 2D Peak Finder 2 found peak: {} in {} steps'.format(fiveByP2[0],fiveByP2[1]))


# In[25]:


sixByP2 = peak2D2(sixBy)
print('[6x6] 2D Peak Finder 2 found peak: {} in {} steps'.format(sixByP2[0],sixByP2[1]))


# In[26]:


sevenByP2 = peak2D2(sevenBy)
print('[7x7] 2D Peak Finder 2 found peak: {} in {} steps'.format(sevenByP2[0],sevenByP2[1]))


# In[27]:


eightByP2 = peak2D2(eightBy)
print('[8x8] 2D Peak Finder 2 found peak: {} in {} steps'.format(eightByP2[0],eightByP2[1]))


# In[28]:


nineByP2 = peak2D2(nineBy)
print('[9x9] 2D Peak Finder 2 found peak: {} in {} steps'.format(nineByP2[0],nineByP2[1]))


# #### Functional Tests on Transpose, Reverse, and Non-Square Arrays

# In[361]:


peak2D2(nineByRev)


# In[362]:


peak2D2(nineByT)


# In[363]:


# NOTE: Peak Finder 2 finds one peak (the first encountered) and not the maximum value 
#        7 is a peak value in the non-square array eightByNS
peak2D2(eightByNS)


# In[364]:


eightByNS


# In[379]:


peak2D2(nineByRand)


# In[378]:


nineByRand


# #### Time Tests

# In[272]:


twoByP2T = timeit('peak2D2(twoBy)', globals=globals())


# In[273]:


threeByP2T = timeit('peak2D2(threeBy)', globals=globals())


# In[274]:


fourByP2T = timeit('peak2D2(fourBy)', globals=globals())


# In[275]:


fiveByP2T = timeit('peak2D2(fiveBy)', globals=globals())


# In[276]:


sixByP2T = timeit('peak2D2(sixBy)', globals=globals())


# In[277]:


sevenByP2T = timeit('peak2D2(sevenBy)', globals=globals())


# In[278]:


eightByP2T = timeit('peak2D2(eightBy)', globals=globals())


# In[279]:


nineByP2T = timeit('peak2D2(nineBy)', globals=globals())


# ## Step Count Analysis

# In[29]:


dataSC = {'algorithm':['2D Peak Finder 1', '2D Peak Finder 1', '2D Peak Finder 1', '2D Peak Finder 1',
                     '2D Peak Finder 1', '2D Peak Finder 1','2D Peak Finder 1', '2D Peak Finder 1',
                     '2D Peak Finder 2', '2D Peak Finder 2', '2D Peak Finder 2', '2D Peak Finder 2',
                     '2D Peak Finder 2', '2D Peak Finder 2','2D Peak Finder 2', '2D Peak Finder 2'],
       'array_size':['2x2', '3x3', '4x4','5x5','6x6','7x7','8x8','9x9',
             '2x2', '3x3', '4x4','5x5','6x6','7x7','8x8','9x9'],
       'step_count':[twoByP1[1], threeByP1[1], fourByP1[1], fiveByP1[1], 
                   sixByP1[1], sevenByP1[1], eightByP1[1], nineByP1[1], 
                   twoByP2[1], threeByP2[1], fourByP2[1], fiveByP2[1], 
                   sixByP2[1], sevenByP2[1], eightByP2[1], nineByP2[1]]}


# In[30]:


sc_df = pd.DataFrame(dataSC)


# In[31]:


sc_df


# In[32]:


plt.figure(figsize=(12,8))
sns.barplot(x='array_size', y='step_count', hue='algorithm', data = sc_df, palette = 'viridis')


# In[33]:


sc_df.pivot_table(values = 'step_count', index = ['array_size', 'algorithm'])


# ## Time Test Visualizations

# In[328]:


data = {'algorithm':['2D Peak Finder 1', '2D Peak Finder 1', '2D Peak Finder 1', '2D Peak Finder 1',
                     '2D Peak Finder 1', '2D Peak Finder 1','2D Peak Finder 1', '2D Peak Finder 1',
                     '2D Peak Finder 2', '2D Peak Finder 2', '2D Peak Finder 2', '2D Peak Finder 2',
                     '2D Peak Finder 2', '2D Peak Finder 2','2D Peak Finder 2', '2D Peak Finder 2'],
       'array_size':['2x2', '3x3', '4x4','5x5','6x6','7x7','8x8','9x9',
             '2x2', '3x3', '4x4','5x5','6x6','7x7','8x8','9x9'],
       'run_time':[twoByP1T, threeByP1T, fourByP1T, fiveByP1T, sixByP1T, sevenByP1T, eightByP1T, nineByP1T, 
                   twoByP2T, threeByP2T, fourByP2T, fiveByP2T, sixByP2T, sevenByP2T, eightByP2T, nineByP2T]}


# In[329]:


df = pd.DataFrame(data)


# In[330]:


df


# In[331]:


plt.figure(figsize=(12,8))
sns.barplot(x='array_size', y='run_time', hue='algorithm', data = df, palette = 'viridis')


# In[332]:


df.pivot_table(values = 'run_time', index = ['array_size', 'algorithm'])

