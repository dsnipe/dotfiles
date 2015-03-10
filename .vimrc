" Leader
let mapleader = " "

set nocompatible
set backspace=2   " Backspace deletes like most programs in insert mode
set nobackup
set nowritebackup
set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set autoread      " Auto reload file on change
set history=50
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set laststatus=2  " Always display the status line
set autowrite     " Automatically :write before running commands
set cursorline    " show line under cursor
set mouse=a       " using mouse in terminal
set hidden        " allow Vim to manage multiple buffers effectively
set scrolloff=3

" Use the OS clipboard by default (on versions compiled with `+clipboard`)
set clipboard=unnamed

" Folds
set foldmethod=indent
set foldnestmax=2
set nofoldenable

" Tabs and intends, 2 spaces
set autoindent
set tabstop=2
set smarttab
set softtabstop=2
set shiftwidth=2
set shiftround
set expandtab

" Search settings
set incsearch     " do incremental searching
set hlsearch         "Hilight searches by default
set viminfo='100,f1  "Save up to 100 marks, enable capital marks

" ================ Persistent Undo ==================
" Keep undo history across sessions, by storing in file.
" Only works all the time.

silent !mkdir ~/.vim/backups > /dev/null 2>&1
set undodir=~/.vim/backups
set undofile

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

filetype plugin indent on

augroup vimrcEx
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile Appraisals set filetype=ruby
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd BufRead,BufNewFile /etc/nginx/*,/usr/local/nginx/conf/* if &ft == '' | setfiletype nginx | endif 

  " Enable spellchecking for Markdown
  autocmd FileType markdown setlocal spell

  " Automatically wrap at 80 characters for Markdown
  autocmd BufRead,BufNewFile *.md setlocal textwidth=80

  " Automatically wrap at 72 characters and spell check git commit messages
  autocmd FileType gitcommit setlocal textwidth=72
  autocmd FileType gitcommit setlocal spell

  " Allow stylesheets to autocomplete hyphenated words
  autocmd FileType css,scss,sass setlocal iskeyword+=-
augroup END

" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden
                                \ --ignore .git
                                \ --ignore .DS_Store
                                \ --ignore vendor/bundle
                                \ -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" Pastmode settings
nnoremap <F4> :set invpaste paste?<CR>
set pastetoggle=<F4>
set showmode

" NERDTree settings
map <C-\> <plug>NERDTreeTabsToggle<CR>
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Color scheme
if filereadable($HOME . "/.vim/bundle/vim-hybrid/colors/hybrid.vim")
  " let g:hybrid_use_iTerm_colors = 1
  let g:hybrid_use_Xresources = 1
  colorscheme hybrid
  highlight Comment ctermfg=DarkGray
  highlight CursorLine ctermbg=234
endif

" Change cursor shape in different modes in iTerm2
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" Make it obvious where 120 characters is
set textwidth=120
set colorcolumn=+1

" Numbers
set number
set numberwidth=5

" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <Tab> <c-r>=InsertTabWrapper()<cr>
inoremap <S-Tab> <c-n>

" Exclude Javascript files in :Rtags via rails.vim due to warnings when parsing
let g:Tlist_Ctags_Cmd="ctags --exclude='*.js'"

" Index ctags from any project, including those outside Rails
map <Leader>ct :!ctags -R .<CR>

" Switch between the last two files
nnoremap <leader><leader> <c-^>

" Get off my lawn
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" vim-rspec mappings
nnoremap <Leader>t :call RunCurrentSpecFile()<CR>
nnoremap <Leader>s :call RunNearestSpec()<CR>
nnoremap <Leader>l :call RunLastSpec()<CR>

" Run commands that require an interactive shell
nnoremap <Leader>r :RunInInteractiveShell<space>

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Open new split panes to right and bottom, which feels more natural
set splitright
set splitbelow

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Custom key remapping
inoremap kj <ESC>
nmap <silent> <leader>n :silent :nohlsearch<CR>
nnoremap zw <C-W>o " Zoom Window 

" configure syntastic syntax checking to check on open as well as save
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]

" vim-airline
let g:airline_powerline_fonts = 1 " Enable the patched Powerline fonts
" let g:airline_section_x = '%{PencilMode()}'

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"


" Set spellfile to location that is guaranteed to exist, can be symlinked to
" Dropbox or kept in Git and managed outside of thoughtbot/dotfiles using rcm.
set spellfile=$HOME/.vim-spell-en.utf-8.add

" Always use vertical diffs
set diffopt+=vertical

" -- FUNCTIONS -----------------------------------------------------------------

" Smart indent when entering insert mode with i on empty lines
function! IndentWithI()
  if len(getline('.')) == 0
    return "\"_ddO"
  else
    return "i"
  endif
endfunction
nnoremap <expr> i IndentWithI()

" Open folder in finder
function! OpenInFinder()
  call system('open ' . getcwd())
endfunction
nnoremap <leader>f :call OpenInFinder()<CR>


function! OpenInAtom()
  :w
  exec ':silent !atom ' . shellescape('%:p')
  redraw!
endfunction
nnoremap <leader>a :call OpenInAtom()<CR>


" Local config
if filereadable($HOME . "/.vimrc.local")
  source ~/.vimrc.local
endif
