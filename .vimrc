"asdf vim: fdm=marker:
" Recommended for vim >= 7; no guarantee of compatibility with earlier versions
" Lucas Oman <me@lucasoman.com>
" --enable-rubyinterp --prefix=/usr --enable-ruby
" Get latest from: http://github.com/lucasoman/Conf/raw/master/.vimrc

" load pathogen
"set t_Co=256

" misc options
" {{{ interface
" lines, cols in status line
set ruler
set rulerformat=%=%h%m%r%w\ %(%c%V%),%l/%L\ %P

" a - terse messages (like [+] instead of [Modified]
" t - truncate file names
" I - no intro message when starting vim fileless
" T - truncate long messages to avoid having to hit a key
set shortmess=atTI

" display the number of (characters|lines) in visual mode, also cur command
set showcmd

" current mode in status line
set showmode

" max items in popup menu
set pumheight=8

" show number column
set number
set numberwidth=3

" show fold column, fold by markers
set foldcolumn=2
set foldmethod=marker

" indicate when a line is wrapped by prefixing wrapped line with '> '
set showbreak=>\ 

" highlight search matches
set hlsearch

" highlight position of cursor
"set cursorline
"set cursorcolumn

"set statusline=%f\ %2*%m\ %1*%h%r%=[%{&encoding}\ %{&fileformat}\ %{strlen(&ft)?&ft:'none'}\ %{getfperm(@%)}]\ 0x%B\ %12.(%c:%l/%L%)
"set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
"set laststatus=2
" }}}
" {{{ behavior
set nocompatible
syntax on
filetype on
filetype plugin on

" fast terminal for smoother redrawing
set ttyfast

set omnifunc=syntaxcomplete#Complete

" indentation options
" Note: smartindent is seriously outdated. cindent, even, is unnecessary.
" Let the filetype plugins do the work.
set shiftwidth=2
set tabstop=2
filetype indent on
"set autoindent
set cindent

" show matching enclosing chars for .1 sec
set showmatch
set matchtime=1

" t: autowrap text using textwidth
" l: long lines are not broken in insert mode
" c: autowrap comments using textwidth, inserting leader
" r: insert comment leader after <CR>
" o: insert comment leader after o or O
set formatoptions-=t
set formatoptions+=lcro
set textwidth=80

" context while scrolling
set scrolloff=3

" arrow keys, bs, space wrap to next/prev line
set whichwrap=b,s,<,>,[,]

" backspace over anything
set backspace=indent,eol,start

" case insensitive search if all lowercase
set ignorecase smartcase

" turn off bells, change to screen flash
set visualbell

" show our whitespace
set listchars=tab:\|\ ,trail:.
"set list

" complete to longest match, then list possibilities
set wildmode=longest,list

" turn off swap files
set noswapfile

" options for diff mode
set diffopt=filler
set diffopt+=context:4
set diffopt+=iwhite
set diffopt+=vertical

" keep a lot of history
set history=100

" keep lots of stuff
set viminfo+=:100
set viminfo+=/100

" don't duplicate an existing open buffer
set switchbuf=useopen

" }}}
" {{{ colors
highlight SpecialKey cterm=bold ctermfg=0
" tabe line colors
highlight TabLineFill ctermfg=DarkGray
highlight TabLine ctermfg=4 ctermbg=DarkGray cterm=bold
highlight TabLineSel ctermfg=7 cterm=none ctermbg=DarkGray

" number column colors
highlight LineNr cterm=none ctermbg=none ctermfg=4

" fold colors
highlight Folded cterm=none ctermbg=none ctermfg=4
highlight FoldColumn cterm=none ctermbg=none ctermfg=4

" visual mode colors
highlight Visual ctermbg=7 ctermfg=4

" dictionary menu colors
highlight Pmenu ctermbg=7 ctermfg=0
highlight PmenuSel ctermbg=Yellow ctermfg=0

" diff colors
highlight DiffAdd cterm=none ctermbg=4
highlight DiffDelete cterm=none ctermbg=4
highlight DiffChange cterm=none ctermbg=4
highlight DiffText cterm=none ctermbg=4

" keep cursor column last so it overrides all others
highlight CursorColumn cterm=none ctermbg=Black
highlight CursorLine cterm=none ctermbg=Black

highlight Search cterm=none ctermbg=7 ctermfg=4

" make sure bold is disabled or your terminal will look like the vegas strip
" }}}

" mappings
" {{{ general
let mapleader = "\\"
" easier move screen up/down
nmap <C-j> <C-e>
nmap <C-k> <C-y>
nmap <space> za
" turns off highlighting
nmap <Leader>/ :nohl<CR>
" search for highlighted text
vmap // y/<C-R>"<CR>
" keep block highlighted when indenting
vmap >> >gv
vmap << <gv
" fix a block of XML; inserts newlines, indents properly, folds by indent
nmap <Leader>fx :setlocal filetype=xml<CR>:%s/></>\r</g<CR>:1,$!xmllint --format -<CR>:setlocal foldmethod=indent<CR>
" comment/uncomment highlighted block
vmap <Leader>cc :s!^!//!<CR>
vmap <Leader>cu :s!^//!!<CR>
" open local projects list file
nmap <Leader>l :70vsplit ~/Dropbox/projects.list<CR>
" fix syntax highlighting
nmap <Leader>ss :syntax sync fromstart<CR>
" toggle the tag list
nmap <Leader>tl :TlistToggle<CR>
" toggle gundo
nmap <Leader>gu :GundoToggle<CR>
" make arrow keys useful
" use them to swap between split windows
com -range XselCopy :<line1>,<line2>w !xsel -i -b
com XselPaste :r !xsel -o -b
vmap <silent> <Leader>xc :XselCopy<CR>
nmap <silent> <Leader>xp :XselPaste<CR>
"}}}

" minor helpful stuff
fun! ToggleColumns() "{{{
	"make it easy to remove line number column etc. for cross-terminal copy/paste
  if &number
    set nonumber
    set foldcolumn=0
    let s:showbreaktmp = &showbreak
    set showbreak=
  else
    set number
    set foldcolumn=2
    let &showbreak = s:showbreaktmp
  end
endfunction
"}}}
fun! WriteTrace() "{{{
	let lineNum = line('.')
	let lineFile = bufname('%')
	let lineVal = getline(lineNum)

	let allLines = readfile($HOME."/trace.txt")
	let allLines = add(allLines,lineFile.":".lineNum)
	let allLines = add(allLines,lineVal)
	let allLines = add(allLines,"")

	call writefile(allLines,$HOME."/trace.txt")
endfunction
"}}}
"{{{ctags stuff
nmap <Leader>tf :call CtagsFind(expand('<cword>'))<CR>
com! -nargs=+ Tf :call CtagsFind("<args>")
" split window and search for tag
nmap <Leader>ts :exe('stj '.expand('<cword>'))<CR>

" open new tab and search for tag
fun! CtagsFind(keyword)
	tabe
	exe "tj ".a:keyword
endfunction
"}}}

set mouse=a
set clipboard+=unnamed
set undodir=/home/ping/.vimundo
set undofile
