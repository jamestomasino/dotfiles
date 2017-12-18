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
Plug 'romainl/Apprentice'

" Writing/Authoring Tools
Plug 'reedes/vim-pencil'                  " Super-powered writing things
Plug 'tpope/vim-abolish'                  " Fancy abbreviation replacements
Plug 'junegunn/limelight.vim'             " Highlights only active paragraph
Plug 'junegunn/goyo.vim'                  " Full screen writing mode
Plug 'reedes/vim-lexical'                 " Better spellcheck mappings
Plug 'reedes/vim-litecorrect'             " Better autocorrections
Plug 'reedes/vim-textobj-sentence'        " Treat sentences as text objects
Plug 'reedes/vim-wordy'                   " Weasel words and passive voice

" Development Tools
Plug 'airblade/vim-gitgutter'             " git changes
Plug 'mileszs/ack.vim'                    " helpful search things
Plug 'tpope/vim-fugitive'                 " git wrapper
Plug 'w0rp/ale'                           " linting
Plug 'sheerun/vim-polyglot'               " syntax for lots of things

call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""" FUNCTIONS """"""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! InitializeDirectories()
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
call InitializeDirectories()

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

function! ALEGetError()
    let l:res = ale#statusline#Status()
    if l:res ==# 'OK'
        return ''
    else
        let l:e_w = split(l:res)
        if len(l:e_w) == 2 || match(l:e_w, 'E') > -1
            return ' -' . matchstr(l:e_w[0], '\d\+') . ' '
        endif
    endif
endfunction

function! ALEGetWarning()
    let l:res = ale#statusline#Status()
    if l:res ==# 'OK'
        return ''
    else
        let l:e_w = split(l:res)
        if len(l:e_w) == 2
            return ' -' . matchstr(l:e_w[1], '\d\+')
        elseif match(l:e_w, 'W') > -1
            return ' -' . matchstr(l:e_w[0], '\d\+')
        endif
    endif
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""" AUTOCMD """""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if has('autocmd')

    augroup func_whitespace
        au!
        au FileType c,markdown,cpp,java,go,php,javascript,python,twig,text,xml,yml autocmd BufWritePre <buffer> call StripTrailingWhitespace()
    augroup END

    augroup type_gitcommit
        au!
        au FileType gitcommit call setpos('.', [0, 1, 1, 0])
        au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])
    augroup END

    augroup type_javascript
        au filetype javascript setlocal tabstop=4
        au filetype javascript setlocal shiftwidth=4
        au FileType javascript setlocal softtabstop=4
        au filetype javascript setlocal noexpandtab
    augroup END

    augroup type_haskell
        au FileType haskell compiler ghc
        au filetype haskell setlocal tabstop=2
        au filetype haskell setlocal shiftwidth=2
        au filetype haskell setlocal expandtab
        au filetype haskell let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
        au filetype haskell let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
        au filetype haskell let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
        au filetype haskell let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
        au filetype haskell let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
        au filetype haskell let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
        au filetype haskell let g:haskell_backpack = 1                " to enable highlighting of backpack keywords
    augroup END

    augroup type_python
        au!
        au FileType python setlocal expandtab
        au FileType python setlocal tabstop=4
        au FileType python setlocal softtabstop=4
        au FileType python setlocal shiftwidth=4
    augroup END

    augroup type_json
        au!
        au FileType json setlocal equalprg=python\ -m\ json.tool
    augroup END

    augroup bundle_rmarkdown
        au FileType Rmd setlocal expandtab
        au FileType Rmd setlocal tabstop=4
        au FileType Rmd setlocal softtabstop=4
        au FileType Rmd setlocal shiftwidth=4
    augroup END

    augroup pencil
        au!
        au FileType markdown,mkd call pencil#init()
                    \ | call lexical#init()
                    \ | call litecorrect#init()
                    \ | setl spell spl=en_us fdl=4 noru nonu nornu
                    \ | setl fdo+=search
    augroup END

    augroup gophermap
        au!
        au VimEnter * if @% == 'gophermap' | set textwidth=66 | endif
        au VimEnter * if @% == 'gophermap' | set expandtab | endif
        au VimEnter * if @% == 'gophermap' | set tabstop=2 | endif
        au VimEnter * if @% == 'gophermap' | set softtabstop=2 | endif
        au VimEnter * if @% == 'gophermap' | set shiftwidth=2 | endif
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

" highlight {{{
highlight clear SignColumn      " SignColumn should match background
highlight clear LineNr          " Current line number row will have same background color in relative mode
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

" sets {{{
set nobomb
set background=dark             " Assume a dark background
set mouse=                      " Automatically disable mouse usage
set mousehide                   " Hide the mouse cursor while typing
set shortmess+=aoOtTI           " Abbrev. of messages (avoids 'hit enter')
set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
set foldmethod=manual
set foldlevelstart=20
set virtualedit=onemore         " Allow for cursor beyond last character
set history=1000                " Store a ton of history (default is 20)
set nospell                     " Spell checking off
set hidden                      " Allow buffer switching without saving
set backup                      " Backups are nice ...
set tabpagemax=15               " Only show 15 tabs
set showmode                    " Display the current mode
set noshowcmd                   " Don't show the current command
set cursorline                  " Highlight current line
set backspace=indent,eol,start  " Backspace for dummies
set linespace=0                 " No extra spaces between rows
set relativenumber              " Use relative line numbers
set showmatch                   " Show matching brackets/parenthesis
set incsearch                   " Find as you type search
set hlsearch                    " Highlight search terms
set winminheight=0              " Windows can be 0 line high
set ignorecase                  " Case insensitive search
set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
set wildmenu
set lazyredraw
set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
set scrolljump=5                " Lines to scroll when cursor leaves screen
set scrolloff=3                 " Minimum lines to keep above and below cursor
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace
set nowrap                      " Do not wrap long lines
set autoindent                  " Indent at the same level of the previous line
set shiftwidth=2
set tabstop=2
set softtabstop=2
set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
set splitright                  " Puts new vsplit windows to the right of the current
set splitbelow                  " Puts new split windows to the bottom of the current
set clipboard^=unnamed,unnamedplus
set fileencoding=utf-8
set expandtab
set noerrorbells
set colorcolumn=80
set tags=./tags,tags;$HOME

colorscheme apprentice
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
vnoremap < <gv
vnoremap > >gv
vnoremap . :normal .<CR>
" }}}

" Delete and put with black hole register {{{
xnoremap <Leader>p "_dP
nnoremap <Leader>d "_d
vnoremap <Leader>d "_d
set pastetoggle=<Leader>z
" }}}

" Plugin mappings {{{
nnoremap <Leader>gy :Goyo<CR>
nnoremap <Leader>ll :Limelight!!<CR>
nnoremap ; :Buffers<CR>
nnoremap <Leader>w :bd<CR>
nnoremap <Leader>t :GFiles<CR>
nnoremap <Leader>T :Files<CR>
nnoremap <Leader>r :Tags<CR>
nnoremap <Leader>PH :PencilHard<CR>
nnoremap <Leader>PO :PencilOff<CR>
nnoremap <Leader>PT :PencilToggle<CR>
nnoremap <S-Left> :SidewaysLeft<cr>
nnoremap <S-Right> :SidewaysRight<cr>
vmap <Enter> <Plug>(EasyAlign)
" }}}

" Insert Date/Timestamp for notes {{{
nnoremap gs :pu! =strftime('%Y-%m-%d %H:%M')<cr>A<space>
" }}}

" Move blocks up and down {{{
vmap <C-Up> xkP`[V`]
vmap <C-Down> xp`[V`]
nnoremap <C-Up> ddkP
nnoremap <C-Down> ddp
" }}}

" Create blank lines {{{
nnoremap <silent> <Leader>o o<Esc>
nnoremap <silent> <Leader>O O<Esc>
" }}}

" Fold selection {{{
nnoremap <Leader><space> za
vnoremap <Leader><Space> zf
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
cmap w!! w !sudo tee % >/dev/null
cmap cd. lcd %:p:h
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

" vim: set sw=4 ts=4 sts=4 et tw=78 nospell:
