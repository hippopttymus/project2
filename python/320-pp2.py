'''
Python code to read the CSV file for COMPSCI 320 Programming Project 2
Zach Oster, 2022-11-21
'''

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

## Query functions ##

# Sample query function: returns true for each customer who is in Canada.
# Input: a dictionary (dict) containing one customer's billing data
# Output: true if the customer's address is in Canada, false otherwise
def is_Canadian(customer):
    return customer['Country'] == 'CA'

# ordered_this_month: true iff the customer ordered any items this
# month; expects one argument, a dictionary (dict) containing one
# customer's billing data

# has_zero_balance: true iff the customer has a zero balance; expects
# one argument, a dictionary (dict) containing one customer's billing
# data

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


### Main program ###

# You can hard-code the data set's location into your main program. This code
# assumes that the data set is in the same directory/folder as the code.
billdata_path = './cs320-F22-pp2-data.csv'

## Fill in code below here to generate the report.
## I've included some sample code to give you some ideas, but the sample
## code **will not work** until you complete the extract function.

### Demonstrating query function: print only the names of Canadian customer(s)
##print('----------')
##print('Customer(s) with address(es) in Canada:')
##for customer in extract(is_Canadian, billdata_path):
##    print(customer['First Name'], customer['Last Name'])
##
### Demonstrating query function: print names of customers whose postcodes
### begin with the string 547
print('----------')
print('Customer(s) whose postal codes begin with 547:')
for customer in extract(postcode_begins_with('547'), billdata_path):
    print(customer['First Name'], customer['Last Name'], customer['Postal Code'])

                
