SAS-Vim
=======

Vim plugins, syntax and indention for Running SAS and editing SAS programs.

This package is many things.

SAS syntax  by  Zhenhuan Hu
---------------------------

SAS indent  by  Jianzhong Liu
------------------------------

Run, cklog functions by Kent Nassen
-----------------------------------

Tagset syntax and Indent by Eric Gebhart
----------------------------------------

This package is the combination of the SAS-Syntax syntax by Zhenhuan Hu
the sas.vim indent by Jianzhong Liu, The sas run and log file parsing by Kent Nassen,
and ODS tagset syntax and indent by Eric Gebhart.

I have more to add from my days as a SAS developer where I ran batch sas on a multitude of
remote machines and processed the logs for errors. Those tools are coming.

These are the most up to date sas vim plugins which accomodate SAS versions 9.1, 9.2 and 9.3

The SAS addon functions written by Kent Nassen which provided running of SAS and parsing the logs for errors.
http://www-personal.umich.edu/~knassen/vim/sasfns.html#LoadSASLogList

Also included are the tpl file syntax and indent files for editing ODS Tagsets. 
It does not necessarily support the other template file types like style, table, layout, control or package.
These are are a work in progress, but are significantly nicer than not having them at all.

Installing:
-----------

I recommend Vundle or Pathogen to manage your vim installations. 
Vundle is the best.  https://github.com/gmarik/vundle
Add this github to your bundles.  Don't forget to do a Bundle install.  

Bundle "EricGebhart/SAS-Vim"


Here is the README files from Zhenhuan's syntax and Jianzhong's indent package.
-------------------------------------------------------------------------------
This is a mirror of http://www.vim.org/scripts/script.php?script_id=1089

SAS indent file.


This is a mirror of http://www.vim.org/scripts/script.php?script_id=3522

This syntax script was based on the script originally written by James Kidd years ago. The mechanism for matching SAS keywords has been completely rewritten. The new approach is supposed to be more sophisticated and content sensitive than the old one. 

New improvements of the latest syntax script:

1. Keywords newly introduced in SAS 9.1/9.2/9.3 have been added, including ODS statements, hash object, Proc SGPLOT and Proc SGPANEL.
2. All keywords (according to SAS official documents) in base SAS (up to 9.3) have been supported.
3. Highlights for format tags, user defined macro functions, and macro comments have been supported.

I omitted syntax supports for SAS log and list files in this script. Syntax supports for these files should be kept in separate scripts.  

Please let me know if there is any bugs in the script.

Zhenhuan also has an indent package, which you may wish to try 
PS: Don't forget to check out my SAS indent script here: http://vim.sourceforge.net/scripts/script.php?script_id=4034

Kent Nassen's Run buffer in SAS and Check SAS log functions.
------------------------------------------------------------

Kent's functionality needs a little bit more explanation. For a full explanation see his web page.
http://www-personal.umich.edu/~knassen/vim/sasfns.html#loadsaslog

Here is the short version. Adapt and use the mappings as you see fit. If you are using PC sas be sure to check out the code
and adapt it to running PC sas. The code is fully commented to accodate the situation.

"ADD menu items and key mappings as desired.

" Add a separator before the SAS menu items
  menu Tools.-Sep-     :

  " Assign RunSASonCurrentFile function to the tools menu
  menu Tools.Run\ SAS\ on\ Current\ File  :call RunSASonCurrentFile()

  " Assign  LoadSASLogLst function to the tools menu
  menu Tools.Load\ SAS\ Log\/List\ for\ Current\ File :call LoadSASLogLst()

  " Assign  ChkSASLog function to the tools menu
  menu Tools.Check\ SAS\ Log :call CheckSASLog()

  " Map RunSASonCurrentFile to a function key
  map <F10> :call RunSASonCurrentFile()

  " Map LoadSASLogLst to a function key
  map <F11> :call LoadSASLogLst()

  " Map CheckSASLog to a function key
  map <F12> :call CheckSASLog()
