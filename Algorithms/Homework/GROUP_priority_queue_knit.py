# -*- coding: utf-8 -*-
#!/usr/bin/python

class StudentListGenerator():
    # generates a random CSV file with student and registration data for testing purposes
    from random import randint
    import csv
    import datetime
    # options
    def __init__(self):
        self.n_students = 100  # number of students to generate
        self.orientation_start = self.datetime.date(2020, 8, 20)  # yr, mo, day
    
    
    def randdate(self, start_date, n):
        n_rand = self.randint(0,n)
        random_date = start_date + self.datetime.timedelta(days=n_rand)
        return random_date
    
    
    def generate_student(self, i):
        #student = []
        n_id = 'N' + str(i+1)  # generate student ID
    
        grad = self.randint(0, 2)  # generate graduate status
        if grad == 0: grad = 'graduate'
        elif grad == 1: grad = 'undergraduate'
        else: grad = 'audit'
    
        if grad == 'undergraduate': yr = self.randint(1, 4)  # generate undergraduate year
        else: yr = 0
    
        if grad == 'undergraduate':   # generate aoc value
            aoc = self.randint(0, 2)
            if aoc == 1: aoc = 'Mathematics'
            elif aoc == 2: aoc = 'Computer Science'
            else: aoc = 'other'
        else: aoc = 'Data Science'
    
        d_reg = self.randdate(self.orientation_start, 10)  # generate registration date
    
        return n_id, grad, yr, aoc, str(d_reg)
    
    def man_student(self):
        student_id  = input("Enter an identifier for the student: ")
        while True:
            try:
                grad_status = int(input("Enter status [1-3]:\n1) Graduate Student\n2) Undergraduate Student\n3) Autitor\n"))
                if grad_status in [1,2,3]:
                    break
                else:
                    print("Invalid selection")
                    continue
            except:
                print("invalid selection")
                continue
        if grad_status == 2:
            while True:
                try:
                    ac_year = int(input("Enter the undergraduate year [1-4]: "))
                    if ac_year in [1,2,3,4]:
                        break
                    else:
                        print("Invalid selection")
                        continue
                except:
                    print("invalid selection")
                    continue
            while True:
                try:
                    aoc = int(input("Enter the undergraduate concentration [1-2]:\n1) Conputer Science or Mathematics\n2) Other\n"))
                    if aoc in [1,2]:
                        break
                    else:
                        print("Invalid selection")
                        continue
                except:
                    print("invalid selection")
                    continue
        elif grad_status == 1:
            ac_year = 0
            aoc = 0
        else:
            ac_year = 0
            aoc = 0
        while True:
            try:
                reg_day = int(input("Enter the day of orientation registered [1-6]: "))
                if reg_day in [1,2,3,4,5,6]:
                    break
                else:
                    print("Invalid selection")
                    continue
            except:
                print("invalid selection")
                continue
        d_reg = self.orientation_start + self.datetime.timedelta(days=reg_day)
        
        return student_id, grad_status, ac_year, aoc, d_reg
    
    def build_student_data(self, n):
        with open('registered_students.csv', mode='w') as student_data:
            student_writer = self.csv.writer(student_data, delimiter=',', quotechar='"', quoting=self.csv.QUOTE_MINIMAL)
            student_writer.writerow(['student_id', 'grad_status', 'ac_year', 'aoc', 'date_register'])
    
            for i in range(0, n):
                student_writer.writerow(self.generate_student(i))
    
class PriorityAssign():
    #  Generates priority values for students based on:
    #       - student type: grad/ undergrad/ audit (0:2)
    #       - student year (0:3)
    #       - undergraduate major is CS or Math (0/1)
    #       - registration day (1:6)
    
    # I tried to make this a tiny bit flexible for data input variety, so that it it'll be pretty straightforward
    # to modify if needed (kind of lol)
    
    import pandas as pd
    import datetime as dt
    import numpy as np
    
    # options
    def __init__(self, filepath = ''):
        self.path_to_file = filepath
        self.file_name = 'registered_students.csv'
        self.students_df = self.pd.read_csv(self.path_to_file+self.file_name)
        
        self.col_student_id = 'student_id'  # edit column names to match input data
        self.col_grad = 'grad_status'
        self.col_year = 'ac_year'
        self.col_major = 'aoc'
        self.col_register = 'date_register'
        
        self.priority_majors = ['Computer Science', 'Mathematics', 'Priority']  # change majors with priority
        self.orientation_start = self.dt.datetime(2020, 8, 20)  # orientation start date (yr, mo, day)
    
    # priority category quantization definitions
    def quantify_grad(self, x):  # quantifies student type: grad/ undergrad/ audit
        if x == 'graduate': return 2
        elif x == 'undergraduate': return 1
        else: return 0  # for student type audit
    def quantify_year(self, x):  # senors = 3, freshmen = 0
        return 4-int(x)
    def quantify_major(self, x):
        if x in self.priority_majors: return 1
        else: return 0
    def quantify_register(self, x):  # num days from orientation day
        x = self.dt.datetime.strptime(x, '%Y-%m-%d')
        registration_day = int( (x - self.orientation_start).days )
        if registration_day > 5: return 6
        else: return registration_day
    
    
    def priority_to_magnitude(p_cat):
        if p_cat[4] == 0:
            p_mag = 0
        else:
            p_mag_s = [str(x) for x in p_cat]
            p_mag = int("".join(p_mag_s[1:5]))
        return [p_cat[0], p_mag]
    
    
    def prioritize(self, priority_quantified):
        return [self.priority_to_magnitude(x) for x in priority_quantified]
    
    def student_list_to_df(self, sl):
        if sl == None:
            print("NoneType passes")
        sldf = self.pd.DataFrame(sl)
        for i in range(len(sldf[1])):
            if sldf.iloc[i,1] == 1:
                sldf.iloc[i,1] = 'graduate'
            elif sldf.iloc[i,1] == 2:
                sldf.iloc[i,1] = 'undergraduate'
            else:
                sldf.iloc[i,1] = 'audit'
            
            if sldf.iloc[i,3] == 1:
                sldf.iloc[i,3] = "Priority"
            else:
                sldf.iloc[i,3] = "Other"
            
            sldf.iloc[i,4] = str(sldf.iloc[i,4])
            
        sldf.columns = [self.col_student_id, self.col_grad, self.col_year, self.col_major, self.col_register]
        return(sldf)
    
    def to_priority(self, df):
    
        priority_df = self.pd.DataFrame(df[self.col_student_id])
    
        priority_df['grad_priority'] = [self.quantify_grad(x) for x in df[self.col_grad]]
        priority_df['year_priority'] = [self.quantify_year(x) for x in df[self.col_year]]
        priority_df['major_priority'] = [self.quantify_major(x) for x in df[self.col_major]]
        priority_df['register_priority'] = [self.quantify_register(x) for x in df[self.col_register]]
    
        priority_df['aggregate_priority'] = priority_df['grad_priority'].astype(str) + \
                                            priority_df['year_priority'].astype(str) + \
                                            priority_df['major_priority'].astype(str) + \
                                            priority_df['register_priority'].astype(str)
        priority_df.drop(columns=['grad_priority', 'year_priority', 'major_priority', 'register_priority'], inplace=True)
        priority_list = priority_df.values.tolist()
        return priority_list
    
    def generate_priorities(self, custom = False, sl = None):
        if not custom:
            return self.to_priority(self.students_df)
        else:
            return self.to_priority(self.student_list_to_df(sl))
    
class Heap():
    import math
    def __init__(self):
        pass
    
    def max_heapify(self, A, stop, i = 0):
        '''
        INPUT:  (A)    - a list of two item lists or tuples where the item ar index position 1 is a priority score,
                (stop) - an index position indicating how much of the list to max_heapify
                (i)    - an index position indicating where to begin to heapify
        RETURN: NA
        '''
        largest = i
        left_arg = 2*i + 1
        right_arg = 2*i + 2                                      
        if left_arg < (stop) and float(A[left_arg][1]) > float(A[i][1]):           
            largest = left_arg
        else:
            largest = i 
        
        if right_arg < (stop) and float(A[right_arg][1]) > float(A[largest][1]):
            largest = right_arg
        if largest != i:
            A[i], A[largest] = A[largest], A[i]
            self.max_heapify(A,stop = stop, i=largest)
    
    
    def build_max_heap(self, A):
        '''
        INPUT:  (A)    - a list of two item lists or tuples where the item ar index position 1 is a priority score
        RETURN: NA
        '''
        x = len(A)                                   # assign x
        for i in range(int(x/2), -1, -1):            # assign i
            self.max_heapify(A,stop=len(A),i=i)
    
    
    def heap_sort(self, A):
        '''
        INPUT:  (A)    - a list of two item lists or tuples where the item ar index position 1 is a priority score
        RETURN: NA
        '''
        self.build_max_heap(A)
        for i in range((len(A)-1),1, -1):       # assign i and make switch
            A[0], A[i] = A[i], A[0]
            self.max_heapify(A, stop=(i-1))
            
            
    def heap_extract_max(self, A):
        if len(A) <1:
            print("Heap underflow")
        mx = A[0]
        A[0] = A[len(A)-1]
        A.pop(len(A)-1)
        self.max_heapify(A, len(A))
        return mx
    
    def heap_increase_key(self, A, i, key):
        if float(key[1]) < float(A[i][1]):
            print('New key is amaller than the current key.')
        A[i][1] = key[1]
        if (i-2)/2 % 1 == 0:
            parent = int((2 - i)/2)
        elif (i-1)/2 % 1 == 0:
            parent = int((i-1)/2)
        else:
            parent = 0
        
        while i > 0 and float(A[parent][1]) < float(A[i][1]):
            A[i], A[parent] = A[parent], A[i]
            i = parent
            
    def max_heap_insert(self, A, key):
        A.append([key[0], -(self.math.inf)])
        self.heap_increase_key(A, len(A)-1, key)
    
    

def studentSelector():
    from time import sleep
    
    listGenerator = StudentListGenerator()
    priorityAssign = PriorityAssign()
    heap = Heap()
    studentList = []
    print("Welcome to the class list generator!")
    sleep(2)
    
    running = True
    while running:
        while True:
            try:
                opt = int(input("Plese select an option:\n1) Generate a random student list\n2) Manually add students\n3) Generate a class roster\n4) Select additional students from student list\n5) Quit\n"))
                if opt not in [1,2,3,4,5]:
                    print("Invalid selection.")
                    continue
                else:
                    break
            except:
                print("Invalid selection")
                continue
            
        if opt == 1:
            while True:
                try:
                    n = int(input("How many students should be generated?\n"))
                    break
                except ValueError:
                    print("You did not enter a number")
                    continue
        
            listGenerator.build_student_data(n)
            print("Student list generated.")
            studentList = priorityAssign.generate_priorities()
            sleep(2)
            print("Priority scores assigned.")
            heap.build_max_heap(studentList)

        
        if opt == 2:
            students = []
            adding = True
            while adding:
                students.append(listGenerator.man_student())
                while True:
                    sel = input("Add another student? [Y/N]: ")
                    if sel.lower() in ['y','yes']:
                        break
                    elif sel.lower() in ['n','no']:
                        adding = False
                        break
                    else:
                        print('invalid input')
                        continue
            addition = (priorityAssign.generate_priorities(custom = True, sl = students))
            if len(studentList) > 0:
                for i in range(len(addition)):
                    heap.max_heap_insert(studentList, addition[i])
            else:
                for i in range(len(addition)):
                    studentList.append(addition[i])
                heap.build_max_heap(studentList)

        if opt == 3:
            while True:
                try:
                    num_students = int(input("Enter the number of students for the roster: "))
                    break
                except:
                    print("You did not enter a number.")
            if num_students < len(studentList):
                classRoster = [heap.heap_extract_max(studentList) for x in range(num_students)]
            else:
                print('That is more studens than are on the list. Here are the remaining students:')
                classRoster = [heap.heap_extract_max(studentList) for x in range(len(studentList))]
            sleep(2)
            print("Class roster generated\n")
            print(classRoster)
            print("\n\n")
        
        if opt == 4:
            if studentList == []:
                print('No students in the student list')
                continue
            else:
                while True:
                    try:
                        num_students = int(input("Enter the number of additional students to select: "))
                        break
                    except:
                        print("You did not enter a number.")
                if num_students < len(studentList):
                    classRoster = [heap.heap_extract_max(studentList) for x in range(num_students)]
                else:
                    classRoster = [heap.heap_extract_max(studentList) for x in range(len(studentList))]
                sleep(2)
                print("The next priority students are:\n\n")
                print(classRoster)
                print("\n\n")
        
            
        if opt == 5:
            running = False
            
        
studentSelector()