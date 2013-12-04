" Use filetypes
filetype plugin indent on

" Display
syn on

set number
set scrolloff=3
set showcmd
set wildmode=list:longest
set wildmenu
set wildignore=*.o,*.obj,*.py[co],*.swp,*.exe,*.bbl,*.aux,*.blg,*.fls
set t_Co=256

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
"set wrapmargin=2
set formatoptions+=w
set shiftwidth=4
set tabstop=4
set copyindent

" Behaviour
set autochdir
set ignorecase
set smartcase
set incsearch
set nohlsearch
set magic
set hidden
set switchbuf=usetab,newtab

" Powerline is special
set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim

if filereadable(expand("~/.vimrc.bundles"))
	source ~/.vimrc.bundles
endif

" Some settings for LaTeX-suite
set shellslash

" Solarized
let g:solarized_termcolors=16
set bg=dark
colo solarized

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

nmap <F9> :set invhlsearch<cr>

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

