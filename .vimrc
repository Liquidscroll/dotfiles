"""""""""""""""
" General
"""""""""""""""
" Check if we're on Windows, if so set shellslash
"if has('win32') || has('win64')
"    set shellslash
"endif

" Set history length
set history=500

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set mapleader, for custom macros
let mapleader = ","


"""""""""""""""
" VIM UI
"""""""""""""""

" Set scroll offset -- will keep the number of lines above and 
" below the cursor when scrolling with 'j' and 'k'
set so=7

" Wildmenu is enhanced command-line completion menu
set wildmenu

" Always show current pos
set ruler

" Set height of command bar
set cmdheight=1

" Config backspace to act as it should
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore Case when searching and set smart case searching
set ignorecase
set smartcase

" Highlight search results
set hlsearch

" Set incrmental se5rach
set incsearch

" Disable screen redraw while executing macros
set lazyredraw

" Turn on magic for reg exp
set magic

" Show matching brackets and make them blink
" for 2-tenths of a second
set showmatch
set mat=2

" Disable sounds
set noerrorbells
set novisualbell
set t_vb=
set tm=500
set belloff=all
" Add extra margin on left
set foldcolumn=1


"""""""""""""""
" Colors and Fonts
"""""""""""""""

" Enable syntax highlighting
syntax enable

" Set reg exp engine automatically
set regexpengine=0

" Try to set colour scheme
try
    colorscheme molokai
    "let g:molokai_original = 1
catch
endtry

" Optimise colors for dark background
set background=dark

" Set utf8 as standard encoding
" and en_AU as the standard language
set encoding=utf8
set langmenu=en_AU

"Use unix as the standard file type
set ffs=unix,dos,mac



"""""""""""""""
" Text, Tab and Indent related
"""""""""""""""

" Use spaces instead of tabs
set expandtab

" Use smart tabs
set smarttab

" Make 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 char
set lbr
set tw=500

" Turn on line numbers
set number

" Turn on auto indent
set autoindent

" Turn on smart indent
set smartindent

" Wrap lines
set wrap

"""""""""""""""
" Movement
"""""""""""""""

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

"""""""""""""""
" Status Line
"""""""""""""""

" Always show status line
set laststatus=2

" Format the status line
"set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c
"set statusline=\ %{HasPaste()}%{TruncatePath(expand('%:p'))}%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c
set statusline=\ %{HasPaste()}%{TruncatePath(expand('%:p'))}%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c
set statusline+=%= 
set statusline+=\{…\}%3{codeium#GetStatusString()}

"""""""""""""""
" Editing Mappings
"""""""""""""""

" Delete trailing white space on save, useful for some filetypes ;)
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

if has("autocmd")
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
endif

"""""""""""""""
" Spell-Checking
"""""""""""""""
" Toggle spell check with ',ss'
map <leader>ss :setlocal spell!<cr>


"""""""""""""""
" Misc
"""""""""""""""

" Press ',m' to remove Windows carriage returns
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Toggle paste mode with ',pp'
map <leader>pp :setlocal paste!<cr>

" Turn Off Codeium Bindings 
let g:codeium_disable_bindings = 1
"Attemp shift-tab remap
imap <script><silent><nowait><expr> <C-g> codeium#Accept()
imap <C-;> <Cmd> call codeium#CycleCompletions(1)<CR>
imap <C-.> <Cmd> call codeium#CycleCompletions(-1)<CR>
imap <C-x> <Cmd> call codeium#Clear()<CR>
imap <C-`> <Cmd> call codeium#Complete()<CR> 

"""""""""""""""
" Helper Funcs
"""""""""""""""

" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

" Truncate File Path
function! TruncatePath(path)
    let l:max_dirs = 3
    let l:parts = split(a:path, '/')

    if len(l:parts) > l:max_dirs
        return '~/.../' . join(l:parts[-l:max_dirs:], '/')
    else
        return a:path
    endif
endfunction

"""""""""""""""
" Files, backups and undo
"""""""""""""""

" Check for temp dir and create it if
" it doesn't exist
if !isdirectory(expand('~/vimtemp/backup'))
    call mkdir(expand('~/vimtemp/backup'), 'p')
endif
if !isdirectory(expand('~/vimtemp/swap'))
    call mkdir(expand('~/vimtemp/swap'), 'p')
endif
if !isdirectory(expand('~/vimtemp/undo'))
    call mkdir(expand('~/vimtemp/undo'), 'p')
endif

" Set directories

set backupdir=~/vimtemp/backup//
set directory=~/vimtemp/swap//
set undodir=~/vimtemp/undo//

set backup
set writebackup
set undofile
