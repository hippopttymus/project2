
'''
Python code to read the CSV file for COMPSCI 320 Programming Project 2
Zach Oster, 2022-11-21
'''
import statistics
import sys
import csv

### Function definitions ###

# Read billing data from a CSV file located at billdata_path.
# Input: the path to a CSV file containing billing data
# Output: a list of Python dictionaries (dicts), where each dict contains
#         a key-value pair for each field in the original record
def read_billdata_csv(billdata_path):
    # Open billing data file
    billdata_file = open(billdata_path, 'r')

    # Guess the CSV dialect that this file is using
    #billdata_dialect = csv.Sniffer().sniff(billdata_file.read(256))

    # Set up CSV file reader object
    billdata_file.seek(0) # reset file pointer
    billdata_reader = csv.reader(billdata_file)#, dialect=billdata_dialect)

    # Read newer_file, extracting the header row
    billdata = []
    billdata_header = []
    for record in billdata_reader:
        if billdata_reader.line_num == 1:
            billdata_header = record
        else:
            billdata.append(dict(zip(billdata_header,record)))

    return billdata

## Extract function ##

def extract(query_func, billdata_path):
    billdata = read_billdata_csv(billdata_path)
    # Fill in the rest here. It's possible to finish this function
    # with 1 more line of code, but you can use more if needed.
    return filter(query_func,billdata)

## Query functions ##

# Sample query function: returns true for each customer who is in Canada.
# Input: a dictionary (dict) containing one customer's billing data
# Output: true if the customer's address is in Canada, false otherwise
def is_Canadian(customer):
    return customer['Country'] == 'CA'

# ordered_this_month: true iff the customer ordered any items this
# month; expects one argument, a dictionary (dict) containing one
# customer's billing data
def ordered_this_month(customer):
    return int(customer['Items Ordered This Month']) > 0

# has_zero_balance: true iff the customer has a zero balance; expects
# one argument, a dictionary (dict) containing one customer's billing
# data
def has_zero_balance(customer):
    return float(customer['Amount To Pay']) == 0

# Sample query function (actually a factory function): expects a string.
# Creates and returns a function, which returns true iff a given customer's
# postal code begins with the string that was used as an argument to this
# factory function.
def postcode_begins_with(prefix):
    # you don't strictly need to assign the lambda to a variable,
    # but it might feel less strange if you do
    query_func = lambda customer: customer['Postal Code'].startswith(prefix)
    return query_func

# due_before: a factory function. Expects an integer that encodes a date.
# Creates and returns a function, which returns true iff the customer's
# due date is before the given date.
#   * Your due_before function will use a lambda, similar to
#     postcode_begins_with, but the comparison will be a little different.
def due_before(date):
    query_func = lambda customer: int(customer['Due Date']) < date
    return query_func

### Main program ###

# You can hard-code the data set's location into your main program. This code
# assumes that the data set is in the same directory/folder as the code.
billdata_path = 'cs320-F22-pp2-data.csv'

## Fill in code below here to generate the report.
## I've included some sample code to give you some ideas, but the sample
## code **will not work** until you complete the extract function.

### Demonstrating query function: print only the names of Canadian customer(s)
print('----------')
# print('Customer(s) with address(es) in Canada:')
# for customer in extract(is_Canadian, billdata_path):
#    print(customer['First Name'], customer['Last Name'])

print("Caution the moving walkway is ending")

print('----------')
numcust =0
for customer in extract(ordered_this_month, billdata_path):
   numcust = numcust + 1
print(f'{numcust} Customer(s) ordered item(es) this month')

##
print('----------')
numcustwhitewater = 0
for customer in extract(postcode_begins_with('53190'), billdata_path):
    if(int(customer['Items Ordered This Month']) > 0):
        numcustwhitewater = numcustwhitewater + 1
print(f'{numcustwhitewater} Customer(s) who ordered item(es) this month live in whitewater...GO WARHAWKS! ')

##

print('----------')
avbatal = []
numberoforders = 0
for customer in extract(ordered_this_month, billdata_path):
    numberoforders = numberoforders + 1
    avbatal.append(float(customer['Amount To Pay']))
avbal = round(statistics.fmean(avbatal),2)
print(f'{avbal} Is the average balance of the {numberoforders} Customer(s) who ordered item(es) this month')

##
print('----------')
numzerobal = 0
#print('Customer(s) with a balance of zero:')
for customer in extract(has_zero_balance, billdata_path):
    #print(customer['First Name'], customer['Last Name'])
    numzerobal = numzerobal + 1
print(f'{numzerobal} Customer(s) have a balance of zero')
   
##
print('----------')
numoverdue = 0
overduebaltal = []
maxoverdue = 0
maxoverduecustomer = None
# print('Customer(s) with due date(es) before 2022/11/30:')
for customer in extract(due_before(20221130), billdata_path):
    if(float(customer['Amount To Pay']) > 0):
        numoverdue = numoverdue + 1
        amountduee = float(customer['Amount To Pay'])
        overduebaltal.append(amountduee)
        if(amountduee > maxoverdue):
            maxoverdue = amountduee
            maxoverduecustomer = customer

           
print(f'{numoverdue} Customer(s) have overdue accounts')

mean_over_due_bal = round(statistics.fmean(overduebaltal), 2)

print('----------')

print(f'Average balance for {numoverdue} customers who have overdue accounts is: ${mean_over_due_bal}')
print('----------')
fname = maxoverduecustomer['First Name']
lname = maxoverduecustomer['Last Name']
postal = maxoverduecustomer['Postal Code']

print(f'{fname} {lname} is the customer with the largest overdue balance of {maxoverdue}. Their postcode is {postal}...bring me their head')
print('----------')




### Demonstrating query function: print names of customers whose postcodes
### begin with the string 547


# print('----------')
# print('Customer(s) whose postal codes begin with 547:')
# for customer in extract(postcode_begins_with('547'), billdata_path):
#     print(customer['First Name'], customer['Last Name'], customer['Postal Code'])

                
