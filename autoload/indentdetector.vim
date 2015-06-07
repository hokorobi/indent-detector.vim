"Script Title: Indent Detector
"Script Version: 0.0.3
"Author: luochen1990
"Last Edited: 2015 June 6

function! s:search_nearby(pat) abort
	return search(a:pat, 'Wnc', 0, 20) > 0 || search(a:pat, 'Wnb', 0, 20) > 0
endfunction

function! s:detect() abort
	let leadtab = s:search_nearby('^\t')
	let leadspace = s:search_nearby('^ ')

	if leadtab + leadspace >= 2 || s:search_nearby('^\(\t\+ \| \+\t\)') > 0
		return 'mixed'
	elseif leadtab + leadspace == 0
		return 'default'
	elseif leadtab
		return 'tab'
	endif

	let spacenum = 0
	if s:search_nearby('^ [^\t ]')
		let spacenum = 1
	elseif s:search_nearby('^  [^\t ]')
		let spacenum = 2
	elseif s:search_nearby('^   [^\t ]')
		let spacenum = 3
	elseif s:search_nearby('^    [^\t ]')
		let spacenum = 4
	endif
	return 'space * '.(spacenum ? spacenum : '>4')
endfunction

function! s:echo(str, hlgroup, level) abort
	if a:hlgroup > a:level
		return
	endif

	let hlgroup = ['', 'ErrorMsg', 'WarningMsg', 'None']
	exec 'echohl '.hlgroup[a:hlgroup]
	echomsg 'indentedetector: '.a:str
	echohl None
endfunction

" echolevel: 0 - none; 1 - error; 2 - warnning; 3 - info (all)
function! indentdetector#hook(autoadjust, echolevel) abort
	if &readonly != 0
		return
	endif

	let ErrorMsg   = 1
	let WarningMsg = 2
	let InfoMsg    = 3

	let rst = s:detect()

	if rst ==# 'mixed'
		call s:echo('mixed indent', ErrorMsg, a:echolevel)
		return
	endif

	if rst ==# 'tab'
		if a:autoadjust
			setlocal noexpandtab nosmarttab
		endif
		return
	endif

	if rst[0] !=# 's' "not space
		return
	endif

	" space
	if rst[8] ==# '>' "too many
		call s:echo('too many leading spaces here.', WarningMsg, a:echolevel)
		return
	endif

	if a:autoadjust
		let n = rst[8]
		exec 'setlocal expandtab smarttab tabstop='.n.' shiftwidth='.n.' softtabstop='.n
	endif
	call s:echo('indent: '.rst, InfoMsg, a:echolevel)
endfunction

