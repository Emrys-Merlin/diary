;;;; library.el --- Generation of my diary layout for a month

;;; Author: Tim Adler <tim+github@emrys-merlin.de>
;;; Created: 26 Jan 2018
;;; Keywords: calendar, convenience
;;; Package-requires: (calendar)

;;; Commentary:
;; This library generates the layout of my org-mode-diary (in German).  The user should mainly use "create-diary-buffer" which generates the layout for the given MONTH and YEAR or "create-diary-buffer-from-today" with takes the month and year from the current date.  As mentioned above the output is in German.  If you want to use it in another language you should search and replace the appropriate strings.

;;; Code:

(require 'calendar)

(defun create-diary-buffer-from-today ()
  "Prepare a buffer as a diary taken the month and your from the current date."
  
  (let ((today (calendar-current-date)) month year)
    (setq month (nth 0 today))
    (setq year (nth 2 today) )
    (create-diary-buffer month year))
  )

(defun create-diary-buffer (month year)
  "Prepare a buffer as a diary for a given MONTH and YEAR.  The Layout is my standard-layout sorted by calender week and so forth."

  (insert "* Zusammenfassung\n")
  (insert "  -\n\n")
  (insert "* Wochen\n")
  (insert "  -\n\n")

  (let ((run t)
	(cw (cw-from-date 01 month year))
	(days nil))
    (while run
      (setq days (date-from-cw-in-month cw month year))
      (if days
	  (progn
	    (insert-cw-header cw days)
	    (dolist (element days)
	      (apply 'insert-day-header element)
	      )
	    (setq cw (+ cw 1)))
	(setq run nil))
      )
    )

  (goto-char 1)
  )

(defun cw-from-date (day month year)
  "Get the calender week from a given DAY, MONTH and YEAR."

  (car
   (calendar-iso-from-absolute
    (calendar-absolute-from-gregorian (list month day year))
    ))
  )


(defun date-from-cw (cw year)
  "Return a list of gregorian dates of the calendar week CW in YEAR."
  
  (let (value)
  (dolist (wd '(0 6 5 4 3 2 1) value)
    (setq value (cons
		 (calendar-gregorian-from-absolute
		  (calendar-absolute-from-iso (list cw wd year))
		  )
		 value))
    ))
  )

(defun date-from-cw-in-month (cw month year)
  "Return a list of gregorian dates of the calendar week CW which lie in MONTH in the given YEAR."

  (let (value)
    (dolist (element (date-from-cw cw year) value)
      (when (= month (nth 0 element))
	(setq value (cons element value))
	)
      )
    (setq value (reverse value))
    )
  )

(defun insert-cw-header (cw dates)
  "Take a calender week CW and a list of DATES (month day year) and and prints the cw header."

  (let (first fday lday month year)
    (setq first (car dates))
    (setq fday (nth 1 first))
    (setq month (nth 0 first))
    (setq year (nth 2 first))
    (setq lday (nth 1 (car (reverse dates))))
    (if (= fday lday)
	(insert (format "** KW%02d (%02d.%02d.%d)\n"
		cw fday month year))
      (insert (format "** KW%02d (%02d.-%02d.%02d.%d)\n"
		      cw fday lday month year)))
    (insert "   - \n\n")
    )
  )

(defun weekday-from-date (month day year)
  "Take a MONTH, DAY and YEAR and return the weekday (in German)."

  (nth 
   (nth 1
	(calendar-iso-from-absolute
	 (calendar-absolute-from-gregorian (list month day year))
	 ))
   '(So Mo Di Mi Do Fr Sa))
  )

(defun insert-day-header (month day year)
  "Insert the header for each day specified by MONTH, DAY and YEAR in the form weekday(German), date."
  
  (insert (format "*** %s, %02d.%02d.%d\n"
		  (weekday-from-date month day year)
		  day month year))
  (insert "    - \n\n")
  )

(provide 'diary)
;;; diary.el ends here
