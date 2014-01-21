" Use filetypes
filetype plugin indent on

" Display
syn on

set number
set scrolloff=3
set showcmd
set wildmode=list:longest
set wildmenu
set wildignore=*.o,*.obj,*.py[co],*.swp,*.exe,*.bbl,*.aux,*.blg,*.fls,*.pdf,*.fdb_latexmk,*.bbl,*.gz
set t_Co=256

" GUI
set guioptions=aegiL
" Status line
set laststatus=2

"set statusline=
"set statusline+=%<%.30{getcwd()}\ %f%m "working directory, filename, modified flag
"set statusline+=\ [%{&ff}
"set statusline+=:%{(&fenc==\"\"?&enc:&fenc)}
"set statusline+=:%Y]
"set statusline+=%{(!exists('b:remotestatus')?'':('\ ['.b:remotestatus.']'))}
"set statusline+=\ %=
"set statusline+=\ %{v:register}
"set statusline+=\ %l\/%L
"set statusline+=\ %c%V\  

" Formatting
set backspace=eol,start,indent
set wrap
set lbr
"set wrapmargin=2
set formatoptions+=w
set shiftwidth=4
set tabstop=4
set copyindent

" Behaviour
set autochdir
set autoread
set ignorecase
set smartcase
set incsearch
set nohlsearch
set nomagic
set hidden
set switchbuf=usetab,newtab

augroup line_return
	au!
	au BufReadPost *
				\ if line("'\"") > 0 && line("'\"") <= line("$") |
				\     execute 'normal! g`"zvzz' |
				\ endif
augroup END

" Powerline is special
set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim

if filereadable(expand("~/.vimrc.bundles"))
	source ~/.vimrc.bundles
endif

" Some settings for LaTeX-suite
set shellslash

" Don't let vim-space wreck select-mode
let g:space_disable_select_mode = 1

" Enable folding in LaTeX before LaTeX-Box starts
let g:LatexBox_Folding=1

" Solarized
let g:solarized_termcolors=16
set bg=dark
colo ir_black

" Mappings
noremap <silent> k gk
noremap <silent> j gj
noremap <silent> ^ g^
noremap <silent> $ g$
inoremap <silent> <Up> <C-o>gk
inoremap <silent> <Down> <C-o>gj
inoremap <silent> <Home> <C-o>g^
inoremap <silent> <End> <C-o>g$

nnoremap Y y$

nnoremap _ <C-w>-
nnoremap + <C-w>+

nnoremap L :tabn<cr>
nnoremap H :tabp<cr>
nmap ]q :cn<cr>zv
nmap [q :cp<cr>zv
nmap <C-p> gwap
imap <C-p> <Esc>gwapgi

" Toggleable options
nmap <F9> :set invhlsearch<cr>
nmap <F10> :set invpaste<cr>

" Annoying keys
nmap K <nop>

" Window navigation
noremap <C-h>  <C-w>h
noremap <C-j>  <C-w>j
noremap <C-k>  <C-w>k
noremap <C-l>  <C-w>l

nmap <cr> za

map <c-n> :NERDTreeToggle<cr>

" Prevent the cursor moving when clicking the window to focus it.
augroup NO_CURSOR_MOVE_ON_FOCUS
  au!
  au FocusLost * let g:oldmouse=&mouse | set mouse=
  au FocusGained * if exists('g:oldmouse') | let &mouse=g:oldmouse | unlet g:oldmouse | endif
augroup END

" Auto-reload .vimrc when saved
augroup Reload-Vimrc
	au!
	autocmd BufWritePost $MYVIMRC source % | doautocmd ColorScheme .vimrc
augroup END

"augroup AutoDeleteSwapFiles
"	au!
"	autocmd SwapExists * call CheckSwapFile()
"augroup END
"function! CheckSwapFile()
"	let v:swapchoice = ''
"	let cmd = "diff -q /tmp/" . expand('%') . " " .expand('%')
"	echo expand('%:p')
"	echo v:swapname
"	call delete("/tmp/" . v:swapname)
"	save! /tmp/%
"	let differs = system(cmd)
"	if differs == 0
"		echo "Deleted redundant swapfile"
"		"let v:swapchoice = 'd'
"	endif
"endfunction

function! s:HandleRecover()
  echo system('diff - ' . shellescape(expand('%:p')), join(getline(1, '$'), "\n") . "\n")
  if v:shell_error
    call s:DiffOrig()
  else
    echohl WarningMsg
    echomsg "No differences; deleting the old swap file."
    echohl NONE
    call delete(b:swapname)
  endif
endfunction

function! s:DiffOrig()
  vert new
  set bt=nofile
  r #
  0d_
  diffthis
  wincmd p
  diffthis
endfunction

augroup HandleRecover
	au!
	autocmd SwapExists  * let b:swapchoice = '?' | let b:swapname = v:swapname
	autocmd BufReadPost * let b:swapchoice_likely = (&l:ro ? 'o' : 'r')
	autocmd BufEnter    * let b:swapchoice_likely = (&l:ro ? 'o' : 'e')
	autocmd BufWinEnter * if exists('b:swapchoice') && exists('b:swapchoice_likely') | let b:swapchoice = b:swapchoice_likely | unlet b:swapchoice_likely | endif
	autocmd BufWinEnter * if exists('b:swapchoice') && b:swapchoice == 'r' | call s:HandleRecover() | endif
augroup END

function! TexCompiling(filename)
	let curbuf = bufnr("%")
	execute ":b " . a:filename
	let b:remotestatus = 'Compiling'
	redrawstatus
	execute ":b " . curbuf
endfunction

function! TexSuccess(filename)
	let curbuf = bufnr("%")
	execute ":b " . a:filename
	let b:remotestatus = 'Success'
	redrawstatus
	execute ":b " . curbuf
endfunction

function! TexFailure(filename)
	let curbuf = bufnr("%")
	execute ":b " . a:filename
	let b:remotestatus = 'Errors'
	"call UpdateErrors()
	redrawstatus
	execute ":b " . curbuf
endfunction

