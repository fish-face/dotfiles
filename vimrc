" Use filetypes
filetype plugin indent on

" Display {{{
syn on

set number
set scrolloff=3
set showcmd
set t_Co=256
" }}}

" WildMenu {{{
set wildmode=list:longest
set wildmenu
set wildignore+=*.o,*.obj,*.exe,*.dll
set wildignore+=*.py[co]
set wildignore+=*.swp
set wildignore+=*.bbl,*.aux,*.blg,*.fls,*.pdf,*.fdb_latexmk,*.bbl,*.gz,*.out,*.toc
" }}}

" GUI
set guioptions=aegiL
set guifont=Droid\ Sans\ Mono\ for\ Powerline\ 10,Bitstream\ Vera\ Sans\ Mono\ for\ Powerline\ 10,Bitstream\ Vera\ Sans\ 10

" Formatting {{{
set backspace=eol,start,indent
set wrap
set lbr
set formatoptions+=w
set shiftwidth=4
set tabstop=4
set copyindent
" }}}

" Behaviour {{{
set autochdir
set autoread
set ignorecase
set smartcase
set gdefault
set incsearch
set nohlsearch
set hidden
set switchbuf=usetab,newtab
" set spell
set foldopen-=block

" Remember position in file
augroup line_return
	au!
	au BufReadPost *
				\ if line("'\"") > 0 && line("'\"") <= line("$") |
				\     execute 'normal! g`"zvzz' |
				\ endif
augroup END
" }}}

" Plugins {{{
" Powerline is special
" set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim

" Some settings for LaTeX-suite
set shellslash

" Don't let vim-space wreck select-mode
let g:space_disable_select_mode = 1
" Or cabbreviations
let g:space_no_quickfix = 1

" Enable folding in LaTeX before LaTeX-Box starts
let g:LatexBox_Folding=1

" Colors
let g:solarized_termcolors=16
set bg=dark
colo BusyBee

if filereadable(expand("~/.vimrc.bundles"))
	source ~/.vimrc.bundles
endif

" Pymode
let g:pymode_lint_ignore = "E501"
let g:pymode_options = 0
let g:pymode_lint_cwindow = 0
let g:pymode_rope_lookup_project = 0
let g:pymode_rope_complete_on_dot = 0
"let g:pymode_indent = 0

" }}}

" Mappings {{{
" Navigation
noremap <silent> k gk
noremap <silent> j gj
noremap <silent> ^ g^
noremap <silent> $ g$
inoremap <silent> <Up> <C-o>gk
inoremap <silent> <Down> <C-o>gj
inoremap <silent> <Home> <C-o>g^
inoremap <silent> <End> <C-o>g$

" Laze
nnoremap ; :

" Sane yank
nnoremap Y y$

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

" Fix broken highlighting
noremap <F12> :syntax sync fromstart<cr>
map <F11> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
			\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
			\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") .  ">"<CR>

" Window navigation
noremap <C-h>  <C-w>h
noremap <C-j>  <C-w>j
noremap <C-k>  <C-w>k
noremap <C-l>  <C-w>l
nnoremap <C-c> <C-w>c
nnoremap _ <C-w>-
nnoremap + <C-w>+

nmap <cr> za

map <c-n> :NERDTreeToggle<cr>
" }}}

" Commands {{{

function! OpenInNewTab()
	tabnew
	browse e
endfunction
command! Tbe call OpenInNewTab()
Alias tbe Tbe

" }}}

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

" Command to process file whenever it's changed
function! CompileFunction(cmd)
	let b:compile_cmd = a:cmd
	augroup MyCompile
		au!
		au BufWritePost <buffer> execute 'silent !' . b:compile_cmd . ' ' . expand('%:p')
	augroup END
	" execute '!' . a:cmd . expand('%:p')
	" execute '!' . a:cmd . ' ' . expand('%:p')
endfunction
command! -nargs=1 Compile call CompileFunction('<args>')

" Handle existence of swap files semi-sanely {{{
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
" }}}

" Filetypes {{{
" Vim {{{
augroup ft_vim
	au!
	au FileType vim setlocal foldmethod=marker
augroup END
" }}}

" LaTeX
let g:tex_flavor = "latex"
" }}}
