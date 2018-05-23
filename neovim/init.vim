""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""" BUNDLES """""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

filetype off

call plug#begin('~/.vim/plugged')

" Global
Plug 'embear/vim-localvimrc'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'            " <Enter> to visually align
Plug 'roryokane/detectindent'             " :DetectIndent to match file struct
Plug 'tpope/vim-commentary'               " gcc to toggle comments

" Styling
Plug 'chriskempson/base16-vim'

" Writing/Authoring Tools
Plug 'reedes/vim-pencil'                  " Super-powered writing things
Plug 'tpope/vim-abolish'                  " Fancy abbreviation replacements
Plug 'junegunn/limelight.vim'             " Highlights only active paragraph
Plug 'junegunn/goyo.vim'                  " Full screen writing mode
Plug 'reedes/vim-lexical'                 " Better spellcheck mappings
Plug 'reedes/vim-litecorrect'             " Better autocorrections
Plug 'reedes/vim-textobj-sentence'        " Treat sentences as text objects
Plug 'reedes/vim-wordy'                   " Weasel words and passive voice

" Reading Tools
Plug 'jamestomasino/vim-scroll'           " :ScrollDown (ESC to stop)

" Development Tools
Plug 'airblade/vim-gitgutter'             " git changes
Plug 'mileszs/ack.vim'                    " helpful search things
Plug 'tpope/vim-fugitive'                 " git wrapper
Plug 'w0rp/ale'                           " linting
Plug 'sheerun/vim-polyglot'               " syntax for lots of things
Plug 'posva/vim-vue'
Plug 'jamestomasino/vim-conceal'          " conceal formatting for js/py

call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""" FUNCTIONS """"""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! InitDirs()
    let l:parent = $HOME
    let l:prefix = 'vim'
    let l:dir_list = {
                \ 'backup': 'backupdir',
                \ 'views': 'viewdir',
                \ 'swap': 'directory' }

    if has('persistent_undo')
        let l:dir_list['undo'] = 'undodir'
    endif

    let l:common_dir = l:parent . '/.' . l:prefix

    for [l:dirname, l:settingname] in items(l:dir_list)
        let l:directory = l:common_dir . l:dirname . '/'
        if exists('*mkdir')
            if !isdirectory(l:directory)
                call mkdir(l:directory)
            endif
        endif
        if !isdirectory(l:directory)
            echo 'Warning: Unable to create backup directory: ' . l:directory
            echo 'Try: mkdir -p ' . l:directory
        else
            let l:directory = substitute(l:directory, ' ', '\\\\ ', 'g')
            exec 'set ' . l:settingname . '=' . l:directory
        endif
    endfor
endfunction
call InitDirs()

function! StripTrailingWhitespace()
    " Preparation: save last search, and cursor position.
    let l:_s=@/
    let l:l = line('.')
    let l:c = col('.')
    " do the business:
    %s/\s\+$//e
    " clean up: restore previous search history, and cursor position
    let @/=l:_s
    call cursor(l:l, l:c)
endfunction

function! MyHighlights() abort
    highlight clear SignColumn      " SignColumn should match background
    highlight clear LineNr          " Current line number row will have same background color in relative mode
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""" AUTOCMD """""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if has('autocmd')

    autocmd BufReadPost * if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif 

    augroup func_whitespace
        autocmd!
        autocmd filetype c,markdown,cpp,java,go,php,javascript,python,twig,text,xml,yml autocmd BufWritePre <buffer> call StripTrailingWhitespace()
    augroup END

    augroup type_gitcommit
        autocmd!
        autocmd filetype gitcommit call setpos('.', [0, 1, 1, 0])
        autocmd filetype gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])
    augroup END

    augroup type_javascript
        autocmd!
        autocmd filetype javascript setlocal shiftwidth=2
        autocmd filetype javascript setlocal softtabstop=2
        autocmd filetype javascript setlocal tabstop=2
        autocmd filetype javascript setlocal expandtab
    augroup END

    augroup type_haskell
        autocmd!
        autocmd filetype haskell compiler ghc
        autocmd filetype haskell setlocal shiftwidth=2
        autocmd filetype haskell setlocal expandtab
        autocmd filetype haskell let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
        autocmd filetype haskell let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
        autocmd filetype haskell let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
        autocmd filetype haskell let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
        autocmd filetype haskell let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
        autocmd filetype haskell let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
        autocmd filetype haskell let g:haskell_backpack = 1                " to enable highlighting of backpack keywords
    augroup END

    augroup type_python
        autocmd!
        autocmd filetype python setlocal expandtab
        autocmd filetype python setlocal softtabstop=4
        autocmd filetype python setlocal shiftwidth=4
        autocmd filetype python setlocal tabstop=4
    augroup END

    augroup type_json
        autocmd!
        autocmd filetype json setlocal equalprg=python\ -m\ json.tool
    augroup END

    augroup bundle_rmarkdown
        autocmd!
        autocmd filetype Rmd setlocal expandtab
        autocmd filetype Rmd setlocal softtabstop=4
        autocmd filetype Rmd setlocal shiftwidth=4
        autocmd filetype Rmd setlocal tabstop=4
    augroup END

    augroup pencil
        autocmd!
        autocmd filetype markdown,mkd call pencil#init()
                    \ | call lexical#init()
                    \ | call litecorrect#init()
                    \ | setl spell spl=en_us fdl=4 noru nonu nornu
                    \ | setl fdo+=search
    augroup END

    augroup mycolors
        autocmd!
        autocmd ColorScheme * call MyHighlights()
    augroup END

endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""" SETTINGS """""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" General Lets {{{
let g:mapleader = ','
let b:match_ignorecase = 1
" }}}

" miscelanious settings {{{
filetype plugin indent on       " Automatically detect file types.
syntax on                       " Syntax highlighting
set encoding=utf-8
scriptencoding utf-8
" }}}


" Indent Guides {{{
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup = 0
" }}}

" Pencil / Writing Controls {{{
let g:pencil#wrapModeDefault = 'soft'
let g:pencil#textwidth = 74
let g:pencil#joinspaces = 0
let g:pencil#cursorwrap = 1
let g:pencil#conceallevel = 3
let g:pencil#concealcursor = 'c'
let g:pencil#softDetectSample = 20
let g:pencil#softDetectThreshold = 130
" }}}

" GitGutter Customization {{{
let g:gitgutter_sign_added = '●'
let g:gitgutter_sign_modified = '●'
let g:gitgutter_sign_modified_first_line = '●'
let g:gitgutter_sign_removed = '●'
let g:gitgutter_sign_removed_first_line = '●'
" }}}

" Local vimrc loading {{{
let g:localvimrc_sandbox=0
let g:localvimrc_ask=0
" }}}

" Limelight {{{
let g:limelight_default_coefficient = 0.5
" }}}

" Ack.vim {{{
let g:ackprg = 'ag --vimgrep'
" }}}

" Ale {{{
let g:ale_javascript_prettier_options = '--single-quote --trailing-comma es5 --no-semi'
let g:ale_javascript_prettier_use_local_config = 1
" }}}

" sets {{{
set autoindent                  " Indent at the same level of the previous line
set backspace=indent,eol,start  " Backspace for dummies
set backup                      " Backups are nice ...
set clipboard^=unnamed,unnamedplus
set colorcolumn=80
set cursorline                  " Highlight current line
set expandtab
set fileencoding=utf-8
set foldlevelstart=20
set foldmethod=manual
set hidden                      " Allow buffer switching without saving
set history=1000                " Store a ton of history (default is 20)
set hlsearch                    " Highlight search terms
set ignorecase                  " Case insensitive search
set incsearch                   " Find as you type search
set lazyredraw
set linespace=0                 " No extra spaces between rows
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace
set mouse=                      " Automatically disable mouse usage
set mousehide                   " Hide the mouse cursor while typing
set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
set noshowcmd                   " Don't show the current command
set nowrap                      " Do not wrap long lines
set relativenumber              " Use relative line numbers
set scrolljump=5                " Lines to scroll when cursor leaves screen
set scrolloff=3                 " Minimum lines to keep above and below cursor
set shiftwidth=2
set shortmess+=aoOtTI           " Abbrev. of messages (avoids 'hit enter')
set showmatch                   " Show matching brackets/parenthesis
set showmode                    " Display the current mode
set softtabstop=2
set splitbelow                  " Puts new split windows to the bottom of the current
set splitright                  " Puts new vsplit windows to the right of the current
set tabpagemax=15               " Only show 15 tabs
set tags=./tags,tags;$HOME
set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
set virtualedit=onemore         " Allow for cursor beyond last character
set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
set wildmenu
set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
set winminheight=0              " Windows can be 0 line high

if has('nvim-0.1.5')            " True color in neovim wasn't added until 0.1.5
    set termguicolors
endif

let base16colorspace=256        " enable emulation of 256 colors before
colorscheme base16-default-dark " inheriting colorscheme from base16

" }}}

" conditional settings {{{
if has('persistent_undo')
    set undofile                " So is persistent undo ...
    set undolevels=1000         " Maximum number of changes that can be undone
    set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
endif
" }}}

" Statusline {{{
if has('statusline')
    set laststatus=2

    set statusline=
    set statusline+=%#Search#\ %n\ 
    set statusline+=%#PmenuSel#
    set statusline+=%#CursorLine#
    set statusline+=\ %f\ 
    set statusline+=%h%m%r%w
    set statusline+=%=
    set statusline+=\ %y\ 
    set statusline+=%#Menu#
    set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
    set statusline+=\ [%{&fileformat}\]\ 
    set statusline+=%#PmenuSel#
    set statusline+=\ %p%%
    set statusline+=\ %l:%c
    set statusline+=\ 
endif
" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""" MAPPINGS """""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Tweak existing keys for more natural operation {{{
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap Y y$
xnoremap < <gv
xnoremap > >gv
xnoremap . :normal .<CR>
" }}}

" Delete and put with black hole register {{{
xnoremap <Leader>p "_dP
nnoremap <Leader>d "_d
xnoremap <Leader>d "_d
set pastetoggle=<Leader>z
" }}}

" Plugin mappings {{{
nnoremap <Leader>gy :Goyo<CR>
nnoremap <Leader>ll :Limelight!!<CR>
nnoremap <Leader>gr :ScrollDown<CR>

nnoremap ; :Buffers<CR>
nnoremap <Leader>gl :PencilOff<CR>:set tw=9999<CR>
nnoremap <Leader>gm :PencilHard<CR>:set tw=66<CR>
nnoremap <Leader>w :bd<CR>
nnoremap <Leader>t :GFiles<CR>
nnoremap <Leader>T :Files<CR>
nnoremap <Leader>r :Tags<CR>
nnoremap <S-Left> :SidewaysLeft<cr>
nnoremap <S-Right> :SidewaysRight<cr>
xnoremap <Enter> <Plug>(EasyAlign)
" }}}

" Insert Date/Timestamp for notes {{{
nnoremap gs :pu! =strftime('%Y-%m-%d %H:%M')<cr>A<space>
" }}}

" Move blocks up and down {{{
xnoremap <C-Up> xkP`[V`]
xnoremap <C-Down> xp`[V`]
nnoremap <C-Up> ddkP
nnoremap <C-Down> ddp
" }}}

" Create blank lines {{{
nnoremap <silent> <Leader>o o<Esc>
nnoremap <silent> <Leader>O O<Esc>
" }}}

" Fold selection {{{
nnoremap <Leader><space> za
xnoremap <Leader><Space> zf
" }}}

" Splits {{{
nnoremap <Leader>\| :vsp<CR>
nnoremap <Leader>- :sp<CR>
nnoremap <Leader>j <C-W><C-J>
nnoremap <Leader>k <C-W><C-K>
nnoremap <Leader>l <C-W><C-L>
nnoremap <Leader>h <C-W><C-H>
nnoremap <Leader>J :resize +5<CR>
nnoremap <Leader>K :resize -5<CR>
nnoremap <Leader>H :vertical resize -5<CR>
nnoremap <Leader>L :vertical resize +5<CR>
" }}}

" File actions {{{
cnoremap %% <C-R>=expand('%:h').'/'<CR>
" }}}

" Diff conflict actions {{{
nnoremap <Leader>cn ]cn                 " next conflict
nnoremap <Leader>cN [c                  " prev conflict
nnoremap <Leader>cc :diffupdate<CR>     " update diffs
nnoremap <Leader>ch :diffget //2<CR>    " keep local contents (left)
nnoremap <Leader>cl :diffget //3<CR>    " use merge contents (right)
" }}}

" command mode helpers {{{
cnoremap w!! w !sudo tee % >/dev/null
cnoremap cd. lcd %:p:h
" }}}

" clear search results {{{
nnoremap <silent> <Leader>/ :nohlsearch<CR>
" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""" LOCAL OVERRIDES """""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if filereadable(expand('~/.vimrc.local'))
    source ~/.vimrc.local
endif

" vim: set sw=4 sts=4 et tw=78 nospell:
