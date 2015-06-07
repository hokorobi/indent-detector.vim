"Script Title: Indent Detector
"Script Version: 0.0.3
"Author: luochen1990
"Last Edited: 2015 June 6

if exists('g:loaded_indentdetector')
	finish
endif
let g:loaded_indentdetector = 1

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=* Indentdetector :call indentdetector#hook(<f-args>)

let &cpo = s:save_cpo
unlet s:save_cpo
