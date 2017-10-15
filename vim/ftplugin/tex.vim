imap <buffer> [[ 		\begin{
imap <buffer> ]]		<Plug>LatexCloseCurEnv
nmap <buffer> <F5>		<Plug>LatexChangeEnv
vmap <buffer> <F7>		<Plug>LatexWrapSelection
vmap <buffer> <S-F7>		<Plug>LatexEnvWrapSelection
"imap <buffer> (( 		\eqref{

"map <buffer> <leader>ll :Rubber<cr>
"map <buffer> <leader>lk :RubberStop<cr>
"map <buffer> <leader>lg :RubberStatus<cr>
"map <buffer> <leader>lG :RubberStatusDetailed<cr>
"map <buffer> <leader>lL :RubberForce<cr>
"map <buffer> <leader>lc :RubberClean<cr>

"map <silent> <buffer> <C-J> :call LatexBox_JumpToNextBraces(0)<cr>
"map <silent> <buffer> <C-K> :call LatexBox_JumpToNextBraces(1)<cr>

imap <buffer> <C-s> <c-o>:w<cr>
map <buffer> <M-p> gwap
imap <buffer> <M-p> <c-o>gwap
imap <buffer> <M-i> \item

let g:vim_program = v:progname

set spell
set nobackup

function! MapTexMotions()
	for l:motion in ['w', 'e', 'b', 'ge']
		for l:mode in ['n', 'o', 'v']
			let l:cmd  = l:mode . 'noremap <buffer> <silent> '
			let l:cmd .= l:motion . ' '
			let l:cmd .= ':<C-U>call MoveTexWord("'
			let l:cmd .= l:motion
			let l:cmd .= '", "' . l:mode . '", '
			let l:cmd .= 'v:count1)'
			if l:mode == 'o' && l:motion == 'w'
				"let l:cmd .= '<C-H>'
			endif
			let l:cmd .= '<CR>'
			exe l:cmd
		endfor
		exe 'sunmap <buffer> <silent>' . l:motion
	endfor

	vnoremap <buffer> <silent> aw :<C-U>call MoveTexWord('bc', 'n', 1)<cr>vv:call MoveTexWord('w', 'v', 1, 1)<cr><BS>
	vmap <buffer> <silent> iw :<C-U>call MoveTexWord('bc', 'n', 1)<cr>ve
	omap <buffer> <silent> aw :<C-U>normal vaw<cr>
	omap <buffer> <silent> iw :<C-U>normal viw<cr>
endfunction

call MapTexMotions()

function! MoveTexWord(motion, mode, count, ...)
	let motion = a:motion
	if a:mode == 'o' && motion == 'w' && v:operator == 'c'
		let motion = 'e'
	endif

	if motion == 'w'
		let flags = ''
	elseif motion == 'ge'
		let flags = 'be'
	else
		let flags = motion
	endif

	let flags .= 'W'
	if a:0 > 0
		let oneline = a:1
	else
		let oneline = 0
	endif

	if a:mode == 'v'
		normal! gv
	endif

	let c = 0
	while c < a:count
		let current = line('.')
		"call search('\v(\\@=|\W)+\zs\S{-1,}\ze(\\|\W|$)', flags)
		"if oneline
		"	let searchstr = '\v((\\|\w)\w*|[^\\[:alnum:][:space:]]+|$)'
		"else
			let searchstr = '\v((\\|\w)\w*|[^\\[:alnum:][:space:]]+)'
		"endif

		call search(searchstr, flags)
		if oneline && line('.') != current
			exe "normal! " . current . "G"
			normal! $
		endif
		let c = c + 1
	endwhile

	if a:mode == 'o' && motion == 'e'
		normal! 1 
	endif
endfunction

let g:LatexBox_viewer='okular'
let g:LatexBox_quickfix=4
let g:LatexBox_latexmk_async=1
let g:LatexBox_latexmk_preview_continuously=1
let g:LatexBox_fold_envs=0
"let g:LatexBox_latexmk_options="-pdflatex='pdflatex -synctex=1 \\%O \\%S'"
"set makeprg=rubber-info\ %:t:r.log
"set errorformat=%f:%l:\ %m
"map <buffer> <F2> :silent !rubber-info %:t:r.log 2>&1 > %:t:r.errors &<cr>:redraw!<cr>:cfile %:t:r.errors<cr>

function! Errors()
	normal :LatexErrors<cr>
	wincmd p
	"if exists("g:quickfix_is_open")
	"	cclose
	"else
	"	cfile %:t:r.log
	"	let orig_win = winnr()
	"	cwindow
	"	exe orig_win . " :wincmd w"
	"endif
endfunction

augroup QFixToggle
	autocmd!
	autocmd BufWinEnter quickfix let g:quickfix_is_open = bufnr("$")
	autocmd BufWinLeave * if exists("g:quickfix_is_open") && expand("<abuf>") == g:quickfix_is_open | unlet! g:quickfix_is_open | endif
augroup END

map <buffer> <F2> :call Errors()<cr>
"map <buffer> <F2> :LatexErrors<cr>

function! SyncTexForward(...)
	let execstr = "silent !okular --unique ".LatexBox_GetOutputFile().'\#' . "src:".line(".").expand("%:p:h")."/./".expand("%:t")." &> /dev/null &"
	exec execstr
	if a:0 > 0
		echo execstr
	endif
endfunction

nmap <Leader>f :call SyncTexForward()<cr>

augroup AUTOSAVE_ON_IDLE
	au!
	au CursorHold,CursorHoldI buffer nested update
augroup END
set updatetime=500

"augroup COMPILE_ON_SAVE
"	au!
"	au BufWritePost *.tex Latexmk
"augroup END
