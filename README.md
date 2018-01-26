Diary
=====

I write my diary in emacs org-mode and use a peculiar layout. I use one file for each month and each has the following peculiar layout (the localization is German):

```org
* Zusammenfassung
  - ...
  
* Wochen
  
** KW01 (01.-07.01.2018)
   - ...
   
*** Mo, 01.01.2018
	- ...

...
```
The library provides two interactive commands `create-diary-buffer` and `create-diary-buffer-from-today`. The first command takes a month and a year and generates the buffer layout at point. The second command does the same, however, it does not ask for the month or date, but instead uses the current date to determine both. 

In order to use the package put it in your emacs load path and add

```elisp
(require 'diary)
```

to your config file (probably `~/.emacs`). Additionally, I bind `create-diary-buffer-from-today` to some keyboard shortcut. For example you can

```elisp
(global-set-key (kbd "C-c C-ö") 'create-diary-buffer-from-today)
```
to your config file to bind the command to `C-c C-ö`.

This is my first emacs "library". So I would be very intersted in any comments you have concerning the file. Just leave me a message or fork it and open pull requests.
