""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""" BUNDLES """""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

filetype off

call plug#begin('~/.vim/plugged')

" Global
Plug 'embear/vim-localvimrc'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Styling
Plug 'reedes/vim-colors-pencil'           " A soft, pretty theme

" Writing/Authoring Tools
Plug 'reedes/vim-pencil'                  " Super-powered writing things
Plug 'tpope/vim-abolish'                  " Fancy abbreviation replacements
Plug 'junegunn/limelight.vim'             " Highlights only active paragraph
Plug 'junegunn/goyo.vim'                  " Full screen writing mode
Plug 'reedes/vim-lexical'                 " Better spellcheck mappings
Plug 'reedes/vim-litecorrect'             " Better autocorrections
Plug 'reedes/vim-textobj-sentence'        " Treat sentences as text objects
Plug 'reedes/vim-wordy'                   " Weasel words and passive voice
Plug 'nelstrom/vim-markdown-folding'      " Smart folding for markdown

" Development Tools
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }                                   " Language Server Protocol
Plug 'neitanod/vim-clevertab'             " simple tab chains
Plug 'tpope/vim-commentary'               " gcc to toggle comments
Plug 'airblade/vim-gitgutter'             " git changes
Plug 'tpope/vim-fugitive'                 " git wrapper
Plug 'w0rp/ale'                           " linting
Plug 'othree/yajs.vim'                    " javascript syntax
Plug 'othree/es.next.syntax.vim'          " es.next support
Plug 'posva/vim-vue'                      " vue specific syntax support
Plug 'https://gitlab.com/jamestomasino/vim-conceal.git' " conceal formatting for js/py
Plug 'leafgarland/typescript-vim'         " typescript syntax
Plug 'junegunn/vim-easy-align'            " align code on characters

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
    if !&binary && &filetype != 'diff'
        normal mz
        normal Hmy
        %s/\s\+$//e
        normal 'yz<CR>
        normal `z
    endif
endfunction

function! MyHighlights() abort
    highlight clear SignColumn      " SignColumn should match background
    highlight clear LineNr          " Current line number row will have same background color in relative mode
endfunction

function! Print()
    let &printheader = " "
    hardcopy > %:r.ps
    !ps2pdf %:r.ps
    !rm %:r.ps
endfunction

function! LinterStatus() abort
   let l:counts = ale#statusline#Count(bufnr(''))
   return l:counts.total == 0 ? '' : printf(
   \ ' %d ',
   \ l:counts.total
   \)
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""" AUTOCMD """""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if has('autocmd')

    autocmd BufReadPost * if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

    augroup fzf
        autocmd! FileType fzf
        autocmd  FileType fzf set laststatus=0 noshowmode noruler | autocmd BufLeave <buffer> set laststatus=2 showmode ruler
    augroup END

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
        autocmd filetype javascript setlocal foldmethod=syntax
    augroup END

    augroup type_vue
        autocmd!
        autocmd filetype vue syntax sync fromstart
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

    augroup type_make
        autocmd!
        autocmd filetype make setlocal noexpandtab
        autocmd filetype make setlocal softtabstop=4
        autocmd filetype make setlocal shiftwidth=4
        autocmd filetype make setlocal tabstop=4
    augroup END

    augroup bundle_rmarkdown
        autocmd!
        autocmd filetype Rmd setlocal expandtab
        autocmd filetype Rmd setlocal softtabstop=4
        autocmd filetype Rmd setlocal shiftwidth=4
        autocmd filetype Rmd setlocal tabstop=4
    augroup END

    augroup bundle_php
        autocmd!
        autocmd filetype php setlocal expandtab
        autocmd filetype php setlocal softtabstop=2
        autocmd filetype php setlocal shiftwidth=2
        autocmd filetype php setlocal tabstop=2
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

" vue {{{
let g:vue_disable_pre_processors=1
" }}}

" Ale {{{
let g:ale_linter_aliases = {'vue': ['vue', 'javascript']}
let b:ale_linters = {'javascript': ['eslint']}
let b:ale_linters = {'scss': ['stylelint']}
let g:ale_linters = {'vue': ['eslint', 'vls']}
let g:ale_fixers = {'*': ['remove_trailing_lines', 'trim_whitespace']}
let b:ale_fixers = {'scss': ['stylelint']}
let g:ale_fix_on_save = 1
let g:ale_lint_on_text_changed = 'always'
let g:ale_lint_delay = 1000
let g:ale_sign_error = '×'
let g:ale_sign_warning = '-'
" }}}

" LSP {{{
let g:LanguageClient_serverCommands = {
    \ 'javascript': ['javascript-typescript-stdio'],
    \ 'javascript.jsx': ['tcp://127.0.0.1:2089'],
    \ 'python': ['pyls'],
    \ 'sh': ['bash-language-server', 'start'],
    \ 'html': ['html-languageserver', '--stdio'],
    \ 'scss': ['css-languageserver --stdio'],
    \ }
nnoremap <F5> :call LanguageClient_contextMenu()<CR>
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
" }}}

" ag support {{{
if executable("ag")
    set grepprg=ag\ --ignore\ --nogroup\ --nocolor\ --ignore-case\ --column
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif
" }}}

" sets {{{
set autoindent                  " Indent at the same level of the previous line
set backspace=indent,eol,start  " Backspace for dummies
set background=dark             " Use dark theme
set backup                      " Backups are nice ...
set clipboard^=unnamed,unnamedplus
set colorcolumn=80
set completeopt=noinsert,menuone,noselect
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
set relativenumber number       " Use relative line numbers
set scrolljump=5                " Lines to scroll when cursor leaves screen
set scrolloff=3                 " Minimum lines to keep above and below cursor
set shiftwidth=2
set shortmess+=caoOtTI           " Abbrev. of messages (avoids 'hit enter')
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
colorscheme pencil              " super sexy colorscheme

" }}}

" conditional settings {{{
if has('persistent_undo')
    set undofile                " So is persistent undo ...
    set undolevels=1000         " Maximum number of changes that can be undone
    set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
endif
" }}}

" Statusline {{{
au InsertEnter * hi statusline guifg=black guibg=#d7afff ctermfg=black ctermbg=magenta
au InsertLeave * hi statusline guifg=black guibg=#8fbfdc ctermfg=black ctermbg=cyan
hi statusline guifg=black guibg=#8fbfdc ctermfg=black ctermbg=cyan

set laststatus=2
set noshowmode
set statusline=
set statusline+=%0*\ %n\                                    " Buffer number
set statusline+=%1*\ %<%F%m%r%h%w\                          " File path, modified, readonly, helpfile, preview
set statusline+=%3*│                                        " Separator
set statusline+=%5*%{LinterStatus()}
set statusline+=%3*│                                        " Separator
set statusline+=%=                                          " Right Side
set statusline+=%2*%y                                       " FileType
set statusline+=\ [%{&ff}:                                  " FileFormat (dos/unix..)
set statusline+=%2*%{''.(&fenc!=''?&fenc:&enc).''}]         " Encoding
set statusline+=%3*│                                        " Separator
set statusline+=%1*\ %02v×%02l/%L\                          " Column×Line Number/Total Lines

hi User1 ctermfg=007 ctermbg=239 guibg=#4e4e4e guifg=#adadad
hi User2 ctermfg=007 ctermbg=236 guibg=#303030 guifg=#adadad
hi User3 ctermfg=236 ctermbg=236 guibg=#303030 guifg=#303030
hi User4 ctermfg=239 ctermbg=239 guibg=#4e4e4e guifg=#4e4e4e
hi User5 ctermfg=255 ctermbg=009 guibg=#e10000 guifg=#ffffff
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

" Buffers {{{
nnoremap <Leader>a :Files<CR>
nnoremap <Leader>A :GFiles<CR>
nnoremap <Leader>b :Buffers<CR>
nnoremap <Leader>s :b#<CR>
nnoremap <leader>w :bd<CR>
" }}}

" TabChain {{{
inoremap <silent><tab> <c-r>=CleverTab#Complete('start')<cr>
                      \<c-r>=CleverTab#Complete('tab')<cr>
                      \<c-r>=CleverTab#Complete('omni')<cr>
                      \<c-r>=CleverTab#Complete('ultisnips')<cr>
                      \<c-r>=CleverTab#Complete('keyword')<cr>
                      \<c-r>=CleverTab#Complete('stop')<cr>
inoremap <silent><s-tab> <c-r>=CleverTab#Complete('prev')<cr>
let g:UltiSnipsExpandTrigger="<leader>u"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
" }}}

" Make {{{
nnoremap <Leader>m :make<CR>
" }}}

" Gophermap mappings {{{
nnoremap <Leader>gl :PencilOff<CR>:set tw=9999<CR>
nnoremap <Leader>gm :PencilHard<CR>:set tw=66<CR>
" }}}

" Plugin mappings {{{
xnoremap <Enter> <Plug>(EasyAlign)
" }}}

" Insert Date/Timestamp for notes {{{
nnoremap <Leader>gs :pu! =strftime('%Y-%m-%d %H:%M')<CR>A<space>
" }}}

" Move blocks up and down {{{
xnoremap <C-Up> xkP`[V`]
xnoremap <C-Down> xp`[V`]
nnoremap <C-Up> ddkP
nnoremap <C-Down> ddp
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

" easy-align {{{
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""" LOCAL OVERRIDES """""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if filereadable(expand('~/.vimrc.local'))
    source ~/.vimrc.local
endif

" vim: set sw=4 sts=4 et tw=78 nospell:
