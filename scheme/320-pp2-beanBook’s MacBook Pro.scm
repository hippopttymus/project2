#lang Scheme

; Scheme starter code for COMPSCI 320 Programming Project 2
; Zach Oster, 2022-11-21

; Don't edit this line unless pp2csv.scm is in a different folder/directory.
; You will need this line to import the CSV-reading code.
(require rnrs "./pp2csv.scm")

; You can uncomment this line to see the internal representation of the data set.
; It should be commented out (or deleted) in your final submitted version.
(define my-data (read-billdata "cs320-F22-pp2-data.csv"))

; My CSV reader produces a list of records, where each record is represented as
; a data structure called an "association list" or an "alist". This is similar
; to a Python dictionary: for example, you can use (cdr (assoc field-id record))
; to look up the value of the field-id field in the given record. See the
; is_Canadian and postcode_begins_with functions, below, for examples.

; I *strongly* recommend that you use _The Scheme Programming Language_, online
; at https://scheme.com/tspl4/, to help you understand my sample code and look
; for possible ways to solve these problems. The Index link at the end might be
; especially helpful; it was for me!

; Insert your code below. You will need to write the following functions.

;;; Extract function: complete this first! It's probably easier than you think.
(define extract
  (lambda (query-func billdata-path)
    (let ((billdata (read-billdata billdata-path)))
      (filter query-func billdata))))

;; sum function
(define (sum x)
    (if (null? x)
        0
        (+ (string->number (car x)) (sum (cdr x)))))

;; average function
(define (average x)
  
    (/ (sum x) (length x)))

;; display average
;;(display (exact->inexact (average x))

;;; Query functions

; Sample query function: returns true for each customer who is in Canada.
; Input: an association list containing one customer's billing data
; Output: true if the customer's address is in Canada, false otherwise
(define is_us
  (lambda (customer)
    ; note: string=? is like eq? or equal?, but specifically for strings
    (string=? (cdr (assoc "Country" customer)) "US")))

; ordered_this_month: true iff the customer ordered any items this
; month; expects one argument, an association list containing
; one customer's billing data
(define ordered_this_month
  (lambda (customer)
    (not (string=?(cdr(assoc "Items Ordered This Month" customer)) "0"))))

;; find customers who ordered nothing
(define ordered_nothing
  (lambda (customer)
    (string=?(cdr(assoc "Items Ordered This Month" customer)) "0")))

; has_zero_balance: true iff the customer has a zero balance; expects no
; arguments
(define has_zero_balance
  (lambda (customer)
    (string=?(cdr(assoc "Amount To Pay" customer)) "0")))


; Sample query function (actually a factory function): expects a string.
; Creates and returns a function, which returns true iff a given customer's
; postal code begins with the string that was used as an argument to this
; factory function.
; * Example uses of this function:
; ((postcode_begins_with "547") (car (read-billdata billdata-path))) => #f
; ((postcode_begins_with "53") (car (read-billdata billdata-path))) => #t
(define postcode_begins_with
  (lambda (prefix)
    (lambda (customer)
      (let ((prefix-length (string-length prefix))
            (customer-postcode (cdr (assoc "Postal Code" customer))))
        (string=? prefix
                  (substring customer-postcode 0 prefix-length))))))
                  

; due_before: a factory function. Expects an integer that encodes a date.o; Creates and returns a function, which returns true iff the customer's
; due date is before the given date.
;   * Your due_before function will use a lambda nested inside a lambda,
;     similar to postcode_begins_with, but the comparison will be different.
(define due_before
   (lambda (date)
     (lambda (customer)
       (< (string->number(cdr(assoc "Due Date" customer))) date))))


(define get_cust
   (lambda (duemount)
     (lambda (customer)
       (= (string->number(cdr(assoc "Amount To Pay" customer))) duemount))))
    
      

;;; Main program

; You can hard-code the data set's location into your main program. This code
; assumes that the data set is in the same directory/folder as the code.
(define billdata_path "./cs320-F22-pp2-data.csv")

; Fill in code below here to generate the report.
; I've included some sample code to give you some ideas, but the sample
; code **will not work** until you complete the extract function.

; This function prints a string, followed by a newline.
; It will make your output code shorter and easier to read.
(define println
  (lambda (str)
    (display str)
    (newline)))




 ;Demonstrating query function: print names of customers whose postcodes
 ;begin with the string 547
;;(display "----------")
;;(newline)
;;(display "Customer(s) whose postal codes begin with 547:")
;;(newline)
;;(for-each println
;; (map (lambda (customer)
;;                (string-append (cdr (assoc "First Name" customer))
;;                               " "
;;                               (cdr (assoc "Last Name" customer))))
;;             (extract  (postcode_begins_with "547") billdata_path)))
;;
;; Demonstrating query function: print only the names of Canadian customer(s)
;;(newline)
;;(display "----------")
;;(newline)
;;(display "Customer(s) with address(es) in USA")
;;(newline)
;;(for-each println
;; (map (lambda (customer)
;;                (string-append (cdr (assoc "First Name" customer))
;;                               " "
;;                               (cdr (assoc "Last Name" customer))))
;;             (extract is_us billdata_path)))

(display "----------")
(newline)
(display "Number of Customer(s) who Ordered Something :  ")
(length (extract ordered_this_month billdata_path))

(display "----------")
(newline)
(display "Number of Customer(s) from white water who ordered something this month :  ")
(length (filter (postcode_begins_with "53190") (filter is_us  (extract ordered_this_month billdata_path))))


(display "----------")
(newline)
(display "Average Balance of Customer(s) who ordered something this month : $ ")
(average(map (lambda (customer) (cdr (assoc "Amount To Pay" customer))) (extract ordered_this_month billdata_path)))


(display "----------")
(newline)
(display "Number of Customer(s) who have zero balances: ")
(length(extract has_zero_balance billdata_path))

(display "----------")
(newline)
(display "Number of customers who have overdue accounts (due before November 30, 2022) : ")
(length(extract (due_before 20221130) billdata_path))



(display "----------")
(newline)
(display "Average balance for customers who have overdue accounts is : $ ")
(average(map (lambda (customer) (cdr (assoc "Amount To Pay" customer))) (extract (due_before 20221130) billdata_path)))

(display "----------")
(newline)
(display "The customer with the largest overdue balance is:  ")
(for-each println
 (map (lambda (customer)
        (string-append
                (string-append (cdr (assoc "First Name" customer))
                               " "
                               (cdr (assoc "Last Name" customer))) " " (cdr (assoc "Postal Code" customer))))
      
(extract (get_cust (apply max(map (lambda (customer) (string->number (cdr (assoc "Amount To Pay" customer)))) (extract (due_before 20221130) billdata_path)))) billdata_path)))











         