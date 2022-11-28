#lang Scheme

; Racket/Scheme CSV reader code for COMPSCI 320 Programming Project 2
; Zach Oster, 2022-11-20

; ** You are not expected to understand how this code works. **
; ** You do not need to edit this file, and you probably should not edit it. **

; To use this code in your Programming Project 2 file, make sure that this file
; is in the same folder/directory as your Project 2 code, then include the
; following line at the start of your Project 2 code:
; (require rnrs "./pp2csv.scm")

(require rnrs)
(provide (all-defined-out))

(define read-billdata
  (lambda (filepath)
    ; Open file for input: assume UTF-8 encoded text, Windows-style line breaks
    (let ((port (open-file-input-port filepath
                                      (file-options)
                                      (buffer-mode line)
                                      (make-transcoder (utf-8-codec) 'crlf))))
    (cond
      ; If file is empty, return an empty association list
      ((port-eof? port) '{})
      ; Otherwise, process the header line, then process billing data
      ; one line at a time using the read-billdata-helper function
      (else (let ((header (split-on-delim #\, (get-line port))))
              (read-billdata-helper header port)))))))

      ; Close the input port before returning
      ;(close-port port))))

(define read-billdata-helper
  (lambda (header port)
    (cond
      ((port-eof? port) '())
      (else (let ((next-record (make-billdata-record header port)))
                 (if (port-eof? port)
                     (cons next-record '())
                     (cons next-record (read-billdata-helper header port))))))))

(define make-billdata-record
  (lambda (header port)
    (map cons header (split-on-delim #\, (get-line port)))))

(define char-locations-in-string
  (lambda (char str)
    (reverse (char-locations-in-string-collector char str 0 '()))))

(define char-locations-in-string-collector
  (lambda (char str index lst)
    (cond
      ((eof-object? str) lst)
      ((= index (string-length str)) lst)
      ((char=? char (string-ref str index))
       (char-locations-in-string-collector char str (+ index 1) (cons index lst)))
      (else
       (char-locations-in-string-collector char str (+ index 1) lst)))))
      
(define split-on-delim
  (lambda (delim str)
    (let ((delim-locations (char-locations-in-string delim str)))
      (split-on-delim-helper str
                             0
                             delim-locations))))

(define split-on-delim-helper
  (lambda (str start-index delim-locations)
    (cond
      ((eof-object? str) '())  ; if we've hit end-of-file, return an empty list
      ((null? delim-locations) ; the rest of the string after the final delimiter
       (cons (substring str start-index (string-length str)) '()))
      (else ; the part of the string from starting point to next delimiter
       (cons (substring str start-index (car delim-locations))
             (split-on-delim-helper str
                                    (+ 1 (car delim-locations))
                                    (cdr delim-locations)))))))
    

;;; Code to test read-billdata with the sample data set (in the same
;;; folder/directory as this code). Displays the internal representation
;;; as a list of association-lists (alists): each alist is a record.
;(let ((port (open-file-input-port "cs320-F21-pp2-data.csv"
;                                  (file-options)
;                                  (buffer-mode line)
;                                  (make-transcoder (utf-8-codec) 'crlf))))
;  (cond
;    ((port-eof? port) (display "Empty billing data file."))
;    (else (display (read-billdata port))))
;  (close-port port))
