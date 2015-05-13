" vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={,} foldlevel=0 foldmethod=marker
" Environment {
    if filereadable(expand("~/.vimrc.bundles"))
      source ~/.vimrc.bundles
    endif
    set nocompatible
" }

" General {{{

    set background=dark         " Assume a dark background
    " if !has('gui')
        "set term=$TERM          " Make arrow and other keys work
    " endif
    filetype plugin indent on   " Automatically detect file types.
    set nocompatible
    set autoread      " Auto reload file on change
    syntax on                   " Syntax highlighting
    set mouse=a                 " Automatically enable mouse usage
    set mousehide               " Hide the mouse cursor while typing
    scriptencoding utf-8

    if has('clipboard')
        if has('unnamedplus')  " When possible use + register for copy-paste
            set clipboard=unnamed,unnamedplus
        else         " On mac and Windows, use * register for copy-paste
            set clipboard=unnamed
        endif
    endif

    "set autowrite                       " Automatically write a file when leaving a modified buffer
    set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
    set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
    set virtualedit=onemore             " Allow for cursor beyond last character
    set history=1000                    " Store a ton of history (default is 20)
    " set spell                           " Spell checking on
    set hidden                          " Allow buffer switching without saving
    set iskeyword-=.                    " '.' is an end of word designator
    set iskeyword-=#                    " '#' is an end of word designator
    set iskeyword-=-                    " '-' is an end of word designator

    " Fix Excape delay problem (autoclose plugin)
    " :verbose map <Esc> to check
    if !has('gui_running')
        set ttimeoutlen=10
        augroup FastEscape
            autocmd!
            au InsertEnter * set timeoutlen=0
            au InsertLeave * set timeoutlen=1000
        augroup END
    endif

    " Automatically resize splits when resizing MacVim window
    if has("gui_running")
      if has("autocmd")
        autocmd VimResized * wincmd =
      endif
    endif

    " Instead of reverting the cursor to the last position in the buffer, we
    " set it to the first line when editing a git commit message
    au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

    " http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
    " Restore cursor to file position in previous editing session
    function! ResCur()
        if line("'\"") <= line("$")
            normal! g`"
            return 1
        endif
    endfunction

    augroup resCur
        autocmd!
        autocmd BufWinEnter * call ResCur()
    augroup END

    augroup vimrcEx
      autocmd!
      " Source vimrc on save
      au BufWritePost ~/.vimrc :source ~/.vimrc

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
      " autocmd FileType markdown setlocal spell

      " Automatically wrap at 80 characters for Markdown
      autocmd BufRead,BufNewFile *.md setlocal textwidth=80

      " Automatically wrap at 72 characters and spell check git commit messages
      autocmd FileType gitcommit setlocal textwidth=72
      autocmd FileType gitcommit setlocal spell

      " Allow stylesheets to autocomplete hyphenated words
      autocmd FileType css,scss,sass setlocal iskeyword+=-
    augroup END

    " Setting up the directories {
        set backup                  " Backups are nice ...
        if has('persistent_undo')
            set undofile                " So is persistent undo ...
            set undolevels=1000         " Maximum number of changes that can be undone
            set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
            silent !mkdir ~/.vim/backups > /dev/null 2>&1
            set undodir=~/.vim/backups
        endif
        " ================ Persistent Undo ==================
        " Keep undo history across sessions, by storing in file.
        " Only works all the time.
        set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
    " }
" }}}

" Vim UI {{{
    " Color scheme
    " if filereadable($HOME . "/.vim/bundle/vim-hybrid/colors/hybrid.vim")
    "   " let g:hybrid_use_iTerm_colors = 1
    "   let g:hybrid_use_Xresources = 1
    "   colorscheme hybrid
    "   highlight Comment ctermfg=DarkGray
    "   highlight CursorLine ctermbg=234
    " endif
    if filereadable($HOME . "/.vim/bundle/jellybeans.vim/colors/jellybeans.vim")
      let g:jellybeans_background_color = '2c3643'
      let g:jellybeans_background_color_256 = '234'
      let g:jellybeans_use_lowcolor_black = 1
      colorscheme jellybeans
      " highlight Comment ctermfg=DarkGray
      highlight CursorLine ctermbg=235
    endif

    " Change cursor shape in different modes in iTerm2
    if exists('$TMUX')
      let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
      let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
    else
      let &t_SI = "\<Esc>]50;CursorShape=1\x7"
      let &t_EI = "\<Esc>]50;CursorShape=0\x7"
    endif

    set tabpagemax=15               " Only show 15 tabs
    set showmode                    " Display the current mode

    set cursorline                  " Highlight current line

    highlight clear SignColumn      " SignColumn should match background
    highlight clear LineNr          " Current line number row will have same background color in relative mode
    "highlight clear CursorLineNr    " Remove highlight color from current line number

    if has('cmdline_info')
        set ruler                   " Show the ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
        set showcmd                 " Show partial commands in status line and
                                    " Selected characters/lines in visual mode
    endif

    if has('statusline')
        set laststatus=2

        " Broken down into easily includeable segments
        set statusline=%<%f\                     " Filename
        set statusline+=%w%h%m%r                 " Options
        set statusline+=%{fugitive#statusline()} " Git Hotness
        set statusline+=\ [%{&ff}/%Y]            " Filetype
        set statusline+=\ [%{getcwd()}]          " Current dir
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
    endif

    set backspace=indent,eol,start  " Backspace for dummies
    set linespace=0                 " No extra spaces between rows
    set number                      " Line numbers on
    set showmatch                   " Show matching brackets/parenthesis
    set incsearch                   " Find as you type search
    set hlsearch                    " Highlight search terms
    set winminheight=0              " Windows can be 0 line high
    set ignorecase                  " Case insensitive search
    set smartcase                   " Case sensitive when uc present
    set wildmenu                    " Show list instead of just completing
    set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
    set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
    set scrolljump=5                " Lines to scroll when cursor leaves screen
    set scrolloff=3                 " Minimum lines to keep above and below cursor
    set foldmethod=indent
    set foldnestmax=2
    set nofoldenable
    " set foldenable                  " Auto fold code
    set list
    set list listchars=tab:»·,trail:·,nbsp:·

    " Make it obvious where 120 characters is
    set textwidth=120
    set colorcolumn=+1

    " Numbers
    set numberwidth=5
" }}}

" Formatting {{{

    set nowrap                      " Do not wrap long lines
    set autoindent                  " Indent at the same level of the previous line
    set shiftwidth=4                " Use indents of 4 spaces
    set expandtab                   " Tabs are spaces, not tabs
    set tabstop=2                   " An indentation every four columns
    set softtabstop=2               " Let backspace delete indent
    set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
    set splitright                  " Puts new vsplit windows to the right of the current
    set splitbelow                  " Puts new split windows to the bottom of the current
    "set matchpairs+=<:>             " Match, to be used with %
    set pastetoggle=<F4>           " pastetoggle (sane indentation on pastes)
    "set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks
    "autocmd FileType go autocmd BufWritePre <buffer> Fmt
    autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig
    autocmd FileType haskell,puppet,ruby,elixir,yml,erlang setlocal expandtab shiftwidth=2 softtabstop=2
    " preceding line best in a plugin but here for now.

    autocmd BufNewFile,BufRead *.coffee set filetype=coffee

    " Workaround vim-commentary for Haskell
    " autocmd FileType haskell setlocal commentstring=--\ %s
    " Workaround broken colour highlighting in Haskell
    autocmd FileType haskell,rust setlocal nospell

" }}}

" Key (re)Mapping {{{

    let mapleader = " "
    nnoremap <C-j> <C-w>j
    nnoremap <C-k> <C-w>k
    nnoremap <C-h> <C-w>h
    nnoremap <C-l> <C-w>l

    " Get off my lawn
    " nnoremap <Left> :echoe "Use h"<CR>
    " nnoremap <Right> :echoe "Use l"<CR>
    " nnoremap <Up> :echoe "Use k"<CR>
    " nnoremap <Down> :echoe "Use j"<CR>
    "
    " wrapped lines goes down/up to next row, rather than next line in file.
    " noremap j gj
    " noremap k gk
    map <Down> gj
    map <Up> gk

    inoremap kj <ESC>
    nmap <silent> <leader>n :silent :nohlsearch<CR>

    " the following two lines conflict with moving to top and
    " bottom of the screen
    map <s-h> gt
    map <s-l> gt

    " cmap tabe tabe

    " yank from the cursor to the end of the line, to be consistent with c and d.
    " nnoremap y y$

    " code folding options
    nmap <leader>f0 :set foldlevel=0<cr>
    nmap <leader>f1 :set foldlevel=1<cr>
    nmap <leader>f2 :set foldlevel=2<cr>
    nmap <leader>f3 :set foldlevel=3<cr>
    nmap <leader>f4 :set foldlevel=4<cr>
    nmap <leader>f5 :set foldlevel=5<cr>
    nmap <leader>f6 :set foldlevel=6<cr>
    nmap <leader>f7 :set foldlevel=7<cr>
    nmap <leader>f8 :set foldlevel=8<cr>
    nmap <leader>f9 :set foldlevel=9<cr>

    " most prefer to toggle search highlighting rather than clear the current
    " search results. to clear search highlighting rather than toggle it on
    nmap <silent> <leader>/ :set invhlsearch<cr>

    " find merge conflict markers
    map <leader>fc /\v^[<\|=>]{7}( .*\|$)<cr>

    " shortcuts
    " change working directory to that of the current file
    cmap cwd lcd %:p:h
    cmap cd. lcd %:p:h

    nnoremap ; :
    " nnoremap : ;
    vnoremap ; :
    " vnoremap : ;
    " quick save and quick source ~/.vimrc
    nnoremap <leader>w :w<cr>
    nnoremap <silent> <leader>so :source $MYVIMRC<cr>
    " Open ~/.vimrc in new tab
    nnoremap <silent> <leader>ev :tabe $MYVIMRC<cr>

    " visual shifting (does not exit visual mode)
    vnoremap < <gv
    vnoremap > >gv
    nmap > >>
    nmap < <<

    " Move to left/right tab
    nnoremap t] :tabn<CR>
    nnoremap t[ :tabp<CR>

    " allow using the repeat operator with a visual selection (!)
    " http://stackoverflow.com/a/8064607/127816
    vnoremap . :normal .<cr>

    " fullscreen mode for gvim and terminal, need 'wmctrl' in you path
    " map <silent> <f11> :call system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")<cr>

    nnoremap <c-j> myo<Esc>`y
    nnoremap <c-k> myO<Esc>`y

    if has("gui_macvim") && has("gui_running")
       " Map command-[ and command-] to indenting or outdenting
      " while keeping the original selection in visual mode
      vmap <D-]> >gv
      vmap <D-[> <gv

      nmap <D-]> >>
      nmap <D-[> <<

      omap <D-]> >>
      omap <D-[> <<

      imap <D-]> <Esc>>>i
      imap <D-[> <Esc><<i

      " Bubble single lines
      nmap <D-Up> [e
      nmap <D-Down> ]e
      nmap <D-k> [e
      nmap <D-j> ]e

      " Bubble multiple lines
      vmap <D-Up> [egv
      vmap <D-Down> ]egv
      vmap <D-k> [egv
      vmap <D-j> ]egv

      " Map Command-# to switch tabs
      map  <D-0> 0gt
      imap <D-0> <Esc>0gt
      map  <D-1> 1gt
      imap <D-1> <Esc>1gt
      map  <D-2> 2gt
      imap <D-2> <Esc>2gt
      map  <D-3> 3gt
      imap <D-3> <Esc>3gt
      map  <D-4> 4gt
      imap <D-4> <Esc>4gt
      map  <D-5> 5gt
      imap <D-5> <Esc>5gt
      map  <D-6> 6gt
      imap <D-6> <Esc>6gt
      map  <D-7> 7gt
      imap <D-7> <Esc>7gt
      map  <D-8> 8gt
      imap <D-8> <Esc>8gt
      map  <D-9> 9gt
      imap <D-9> <Esc>9gt
      noremap <d-/> :TComment   
    else
      " Map Control-# to switch tabs
      map  <C-0> 0gt
      imap <C-0> <Esc>0gt
      map  <C-1> 1gt
      imap <C-1> <Esc>1gt
      map  <C-2> 2gt
      imap <C-2> <Esc>2gt
      map  <C-3> 3gt
      imap <C-3> <Esc>3gt
      map  <C-4> 4gt
      imap <C-4> <Esc>4gt
      map  <C-5> 5gt
      imap <C-5> <Esc>5gt
      map  <C-6> 6gt
      imap <C-6> <Esc>6gt
      map  <C-7> 7gt
      imap <C-7> <Esc>7gt
      map  <C-8> 8gt
      imap <C-8> <Esc>8gt
      map  <C-9> 9gt
      imap <C-9> <Esc>9gt     
    endif
" }}}

" Plugins settings {{{

    " OmniComplete {
        if has("autocmd") && exists("+omnifunc")
            autocmd Filetype *
                \if &omnifunc == "" |
                \setlocal omnifunc=syntaxcomplete#Complete |
                \endif
        endif
        
        hi Pmenu  guifg=#000000 guibg=#F8F8F8 ctermfg=black ctermbg=Lightgray
        hi PmenuSbar  guifg=#8A95A7 guibg=#F8F8F8 gui=NONE ctermfg=darkcyan ctermbg=lightgray cterm=NONE
        hi PmenuThumb  guifg=#F8F8F8 guibg=#8A95A7 gui=NONE ctermfg=lightgray ctermbg=darkcyan cterm=NONE

        " Some convenient mappings
        " inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
        " inoremap <expr> <CR>     pumvisible() ? "\<C-y>" : "\<CR>"
        " inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
        " inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
        " inoremap <expr> <C-d>      pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
        " inoremap <expr> <C-u>      pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"

        " Automatically open and close the popup menu / preview window
        au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
        set completeopt=menu,preview,longest
    " }

    " Ctags {
        set tags=./tags;/,~/.vimtags

        " Make tags placed in .git/tags file available in all levels of a repository
        let gitroot = substitute(system('git rev-parse --show-toplevel'), '[\n\r]', '', 'g')
        if gitroot != ''
            let &tags = &tags . ',' . gitroot . '/.git/tags'
        endif
        " Exclude Javascript files in :Rtags via rails.vim due to warnings when parsing
        let g:Tlist_Ctags_Cmd="ctags --exclude='*.js'"

        " Index ctags from any project, including those outside Rails
        map <Leader>ct :!ctags -R .<CR>
    " }

    " NerdTree {
        if isdirectory(expand("~/.vim/bundle/nerdtree"))
            map <C-\> <plug>NERDTreeTabsToggle<CR>
            map <leader>e :NERDTreeFind<CR>
            autocmd StdinReadPre * let s:std_in=1
            autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

            let NERDTreeShowBookmarks=1
            let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
            let NERDTreeChDirMode=1
            let NERDTreeQuitOnOpen=1
            let NERDTreeMouseMode=2
            let NERDTreeShowHidden=0
            let NERDTreeKeepTreeInNewTab=1
            let g:nerdtree_tabs_open_on_gui_startup=0
 
            " TAB as opener in NERDTree 
            nnoremap <silent><tab> :call nerdtree#ui_glue#invokeKeyMap(g:NERDTreeMapActivateNode)<cr>
        endif
    " }

    " JSON {
        nmap <leader>jt <Esc>:%!python -m json.tool<CR><Esc>:set filetype=json<CR>
        let g:vim_json_syntax_conceal = 0
    " }

    " ctrlp {
        if isdirectory(expand("~/.vim/bundle/ctrlp.vim/"))
            let g:ctrlp_working_path_mode = 'ra'
            let g:ctrlp_open_new_file = 'r'
            nnoremap <silent> <D-t> :CtrlP<CR>
            nnoremap <silent> <D-r> :CtrlPMRU<CR>
            nnoremap <C-b> :CtrlPBuffer<cr>
            let g:ctrlp_custom_ignore = {
                \ 'dir':  '\.git$\|\.hg$\|\.svn$',
                \ 'file': '\v\.(exe|so|dll|aux|lof|log|lot|out|toc|jpg)$',
                \ }

            if executable('ag')
                let s:ctrlp_fallback = 'ag %s --nocolor --ignore vendor/bundle -l -g ""'
                let g:ctrlp_use_caching = 0
            elseif executable('ack-grep')
                let s:ctrlp_fallback = 'ack-grep %s --nocolor --ignore vendor/bundle -f'
                let g:ctrlp_use_caching = 0
            elseif executable('ack')
                let s:ctrlp_fallback = 'ack %s --nocolor --ignore vendor/bundle -f'
                let g:ctrlp_use_caching = 0
            else
                let s:ctrlp_fallback = 'find %s -type --ignore vendor/bundle f'
            endif
            let g:ctrlp_user_command = {
                \ 'types': {
                    \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
                    \ 2: ['.hg', 'hg --cwd %s locate -I .'],
                \ },
                \ 'fallback': s:ctrlp_fallback
            \ }

            if isdirectory(expand("~/.vim/bundle/ctrlp-funky/"))
                " CtrlP extensions
                let g:ctrlp_extensions = ['funky']

                "funky
                nnoremap <Leader>fu :CtrlPFunky<Cr>
            endif
        endif
    "}

    " Fugitive {
        if isdirectory(expand("~/.vim/bundle/vim-fugitive/"))
            nnoremap <silent> <leader>gs :Gstatus<CR>
            nnoremap <silent> <leader>gd :Gdiff<CR>
            nnoremap <silent> <leader>gc :Gcommit<CR>
            nnoremap <silent> <leader>gb :Gblame<CR>
            nnoremap <silent> <leader>gl :Glog<CR>
            nnoremap <silent> <leader>gp :Git push<CR>
            nnoremap <silent> <leader>gr :Gread<CR>
            nnoremap <silent> <leader>gw :Gwrite<CR>
            nnoremap <silent> <leader>ge :Gedit<CR>
            " Mnemonic _i_nteractive
            nnoremap <silent> <leader>gi :Git add -p %<CR>
            nnoremap <silent> <leader>gg :SignifyToggle<CR>
        endif
    "}

   " indent_line {
        let g:indentLine_char = "┆"
        let g:indentLine_color_term = 234
    " }

    " Wildfire {
    let g:wildfire_objects = {
                \ "*" : ["i'", 'i"', "i)", "i]", "i}", "ip"],
                \ "html,xml" : ["at"] }
    " }

    " Syntastic {
        " configure syntastic syntax checking to check on open as well as save
        let g:syntastic_always_populate_loc_list = 1
        let g:syntastic_auto_loc_list = 1
        let g:syntastic_check_on_open = 1
        let g:syntastic_check_on_wq = 0
        let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]
    " }

    " neocomplete {
        let g:acp_enableAtStartup = 1
        let g:neocomplete#enable_at_startup = 1
        let g:neocomplete#enable_smart_case = 1
        let g:neocomplete#enable_auto_delimiter = 1
        let g:neocomplete#max_list = 5
        let g:neocomplete#force_overwrite_completefunc = 1
        let g:neocomplete#auto_completion_start_length = 3
        let g:neocomplete#enable_auto_select = 1

        " Define dictionary.
        let g:neocomplete#sources#dictionary#dictionaries = {
                    \ 'default' : '',
                    \ 'vimshell' : $HOME.'/.vimshell_hist',
                    \ 'scheme' : $HOME.'/.gosh_completions'
                    \ }

        " Define keyword.
        if !exists('g:neocomplete#keyword_patterns')
            let g:neocomplete#keyword_patterns = {}
        endif
        let g:neocomplete#keyword_patterns['default'] = '\h\w*'

        " Plugin key-mappings {
            " <C-k> Complete Snippet
            " <C-k> Jump to next snippet point
            " imap <silent><expr><Tab> neosnippet#expandable() ?
            "             \ "\<Plug>(neosnippet_expand_or_jump)" : (pumvisible() ?
            "             \ "\<C-e>" : "\<Plug>(neosnippet_expand_or_jump)") neosnippet#smart_close_popup()

            inoremap <expr><C-g> neocomplete#undo_completion()
            inoremap <expr><C-l> neocomplete#complete_common_string()
            " inoremap <expr><CR> neocomplete#complete_common_string()

            " <CR>: close popup
            " <s-CR>: close popup and save indent.
            inoremap <expr><s-CR> pumvisible() ? neocomplete#smart_close_popup()"\<CR>" : "\<CR>"

            function! CleverCr()
                if pumvisible()
                    if neosnippet#expandable()
                        let exp = "\<Plug>(neosnippet_expand)"
                        return exp . neocomplete#smart_close_popup()
                    else
                        return neocomplete#smart_close_popup()
                    endif
                else
                    return "\<CR>"
                endif
            endfunction

            
            " <CR> close popup and save indent or expand snippet
            imap <expr><CR> CleverCr()
            " <C-h>, <BS>: close popup and delete backword char.
            " inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
            inoremap <expr><C-y> neocomplete#smart_close_popup()

            " <TAB>: completion.
            " inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"
            imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
                \ "\<Plug>(neosnippet_expand_or_jump)"
                \: pumvisible() ? "\<C-r>=<SID>my_cr_function()<CR>" : "\<TAB>"
            smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
                \ "\<Plug>(neosnippet_expand_or_jump)"
                \: "\<TAB>"

            function! s:my_cr_function()
              "return neocomplete#close_popup() . "\<CR>"
              " For no inserting <CR> key.
              return pumvisible() ? neocomplete#close_popup() : "\<TAB>"
            endfunction

        " }

        " Enable heavy omni completion.
        if !exists('g:neocomplete#sources#omni#input_patterns')
            let g:neocomplete#sources#omni#input_patterns = {}
        endif
        let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
        let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
        let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
        let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
        let g:neocomplete#sources#omni#input_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
        
        " Enable omni-completion.
        autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
        autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
        autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
        autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
        autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
        autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
        autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
    " }


    " Snippets {
        " Use honza's snippets.
        let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'

        " Enable neosnippet snipmate compatibility mode
        let g:neosnippet#enable_snipmate_compatibility = 1

        " For snippet_complete marker.
        if has('conceal')
            set conceallevel=2 concealcursor=i
        endif

        " Enable neosnippets when using go
        let g:go_snippet_engine = "neosnippet"

        " Disable the neosnippet preview candidate window
        " When enabled, there can be too much visual noise
        " especially when splits are used.
        set completeopt-=preview
    " }
" }}}

" GUI Settings {{{

    " GVIM- (here instead of .gvimrc)
    if has('gui_running')
        set guioptions-=T           " Remove the toolbar
        set lines=40                " 40 lines of text instead of 24
    else
        if &term == 'xterm' || &term == 'screen'
            set t_Co=256            " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
        endif
    endif

" }}}

" Switch between the last two files
" nnoremap <leader><leader> <c-^>

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" tComment maps

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

