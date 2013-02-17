

" Author: Kent Nassen
" http://www-personal.umich.edu/~knassen/vim/sasfns.html


function! LoadSASLogLst()
    " Assumes you are editing a SAS program.   The log and lst file names will
    " be based on the SAS program basename (the file in the current buffer) and
    " are assumed to end in .log and .lst, as produced by SAS by default.

    " Load the SAS log file in a tab, if it is not already loaded & it exists
    :let log=bufexists(expand("%:p:r") . ".log")
    :if log==0
      :if filereadable(expand("%:p:r") . ".log")
        :execute "tabedit " . expand("%:p:r") . ".log"
      :else
        :echo "*** SAS log file does not exist."
      :endif
    :endif

    " Load the SAS lst file in a tab, if it is not already loaded & it exists
    :let lst=bufexists(expand("%:p:r") . ".lst")
    :if lst==0
      :if filereadable(expand("%:p:r") . ".lst")
        :execute "tabedit " . expand("%:p:r") . ".lst"
      :else
        :echo "*** SAS lst file does not exist."
      :endif
    :endif
  endfunction
  
" Run SAS on the current file/buffer. Assumes you have a SAS program in
  " the current buffer. File will be saved before running SAS, if it has 
  " been modified. SAS will run on the saved file on disk. Two tabs will
  " be opened, one for the log and one for the list, assumed to be in the
  " same location and with the same basename as the SAS program file.
  function! RunSASonCurrentFile()
    " Make sure this is a SAS program file (ends with .sas) so that
    " we don't run SAS on a log file or similar.
    :let checkSASpgm=match(expand("%"),"\.sas")

    " If we did not match .sas in the file name, end this function with
    " a warning msg
    if checkSASpgm==-1
       :echo "*** Current file is not a SAS program.  SAS run has been canceled."
       :return
    endif

    " Ask user if we want to run SAS so we don't accidentally run it.
    :let l:answer = input("Run SAS? Y/N ") 
    :if (l:answer == "Y" || l:answer == "y")

    " If file has been modified, save it before running
    if exists(&modified)
       :echo "*** Saving modified file before SAS run..."
       :w
    endif

    " Run SAS on path/file name (modify to your location of sas)
    :echo "*** Running SAS..."
    let returntxt = system("/usr/local/bin/sas -nodms " . shellescape(expand("%:p")))
    " The following may work for your Windows system. Comment the line above and uncomment 
    " the two lines below and make them one long line.
    "let returntxt = system("\"" . shellescape("C:\\Program\ Files\\SAS\\SAS\ 9.1\\sas.exe") 
    ".  "\ -nosplash" . "\ -sysin" . "\ " . shellescape(expand("%:p")) .  "\"") 

    " Shows the return messages from the SAS commandline (may be useful
    " if no log produced)
    :echo "*** SAS commandline: " . returntxt

    :call LoadSASLogList()

    :else
    :echo "SAS Run cancelled."

    " endif for the Run SAS? check
    :endif
  endfunction


  " Check SAS log files for errors, warnings and other problems
  " Assumes you are editing the file to be checked when invoking this function.
  " No assumption about log file name extension is made so you can check any file.
  function! CheckSASLog()
    " Go to the first line of the file
    :0

    " Set grepformat for use with the program used by grepprg. NOTE:
    " quickfix needs a file name! Example grepformat when a file name is
    " returned by grepprg program
    set grepformat=%f:%l:%m

    " Example grepformat with no file name returned by the program used
    " by grepprg.
    "set grepformat=%l:%m

    " Save current grepprg setting
    let _grepprg=&grepprg

    " Define the program to use for searching the SAS log
    :set grepprg=internal

    " Run grepprg on the current file 
    grep /warning\|error\|uninit\| 0 obs\|no obser\|repeats of\|not found\|not valid\|invalid\|overwritten/c\/g %:p

    " Set grepprg back to its original setting
    let &grepprg=_grepprg

    " Open the quickfix error window 
    :cope
  endfunction



