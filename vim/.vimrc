set nocompatible

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""" BUNDLES """""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

filetype off

call plug#begin('~/.vim/plugged')

" Global
Plug 'embear/vim-localvimrc'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-eunuch'
Plug 'roryokane/detectindent'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'

" Styling
Plug 'romainl/Apprentice'
Plug 'jamestomasino/eleline.vim'
Plug 'ywjno/vim-tomorrow-theme'

" Writing/Authoring Tools
Plug 'reedes/vim-pencil'
Plug 'tpope/vim-abolish'
Plug 'junegunn/limelight.vim'
Plug 'junegunn/goyo.vim'
Plug 'mattly/vim-markdown-enhancements'
Plug 'nelstrom/vim-markdown-folding'
Plug 'reedes/vim-lexical'
Plug 'reedes/vim-litecorrect'
Plug 'reedes/vim-textobj-sentence'
Plug 'reedes/vim-wordy'

" Development Tools
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-surround'
Plug 'sjl/gundo.vim'
Plug 'mbbill/undotree'
Plug 'mileszs/ack.vim'
Plug 'ajh17/VimCompletesMe'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'w0rp/ale'
Plug 'sheerun/vim-polyglot'

call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""" FUNCTIONS """"""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

silent function! OSX()
    return has('macunix')
endfunction

silent function! LINUX()
    return has('unix') && !has('macunix') && !has('win32unix')
endfunction

silent function! WINDOWS()
    return  (has('win16') || has('win32') || has('win64'))
endfunction

function! InitializeDirectories()
    let parent = $HOME
    let prefix = 'vim'
    let dir_list = {
                \ 'backup': 'backupdir',
                \ 'views': 'viewdir',
                \ 'swap': 'directory' }

    if has('persistent_undo')
        let dir_list['undo'] = 'undodir'
    endif

    let common_dir = parent . '/.' . prefix

    for [dirname, settingname] in items(dir_list)
        let directory = common_dir . dirname . '/'
        if exists("*mkdir")
            if !isdirectory(directory)
                call mkdir(directory)
            endif
        endif
        if !isdirectory(directory)
            echo "Warning: Unable to create backup directory: " . directory
            echo "Try: mkdir -p " . directory
        else
            let directory = substitute(directory, " ", "\\\\ ", "g")
            exec "set " . settingname . "=" . directory
        endif
    endfor
endfunction

function! StripTrailingWhitespace()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " do the business:
    %s/\s\+$//e
    " clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

function! s:btags_source()
  let lines = map(split(system(printf('ctags -f - --sort=no --fields=nKs --excmd=pattern --language-force=%s %s', &filetype, expand('%:S'))), "\n"), 'split(v:val, "\t")')
  if v:shell_error
    throw 'failed to extract tags'
  endif
  return map(s:align_lists(lines), 'join(v:val, "\t")')
endfunction

function! s:btags_sink(line)
  let lines = split(a:line, "\t")
  for line in lines
      let arr = split(line, ":")
      if arr[0] == "line"
          exec arr[-1]
      endif
  endfor
  sil! norm! zvzz
endfunction

function! s:btags()
  try
    call fzf#run({'source':  s:btags_source(),
                 \'down':    '50%',
                 \'options': '+m -d "\t" --with-nth 4,1',
                 \'sink':    function('s:btags_sink')})
  catch
    echohl WarningMsg
    echom v:exception
    echohl None
  endtry
endfunction

command! BTags call s:btags()

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

call InitializeDirectories()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""" AUTOCMD """""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if has("autocmd")

    augroup general_buffer
        au!
        au BufReadPost setlocal nobomb
        au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
        au BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
    augroup END

    augroup func_whitespace
        au!
        au FileType c,markdown,cpp,java,go,php,javascript,python,twig,text,xml,yml autocmd BufWritePre <buffer> call StripTrailingWhitespace()
    augroup END

    augroup type_text
        au!
        au FileType text setlocal expandtab
        au filetype text setlocal tabstop=4
        au FileType text setlocal softtabstop=4
        au filetype text setlocal shiftwidth=4
    augroup END

    augroup type_gitcommit
        au!
        au FileType gitcommit call setpos('.', [0, 1, 1, 0])
        au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])
    augroup END

    augroup type_lisp
        au filetype lisp,scheme setlocal equalprg=scmindent
        au filetype lisp,scheme setlocal tabstop=2
        au filetype lisp,scheme setlocal shiftwidth=2
        au filetype lisp,scheme setlocal expandtab
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
let g:indent_guides_enable_on_vim_startup = 1
" }}}

" Pencil / Writing Controls {{{
let g:pencil#wrapModeDefault = 'soft'
let g:pencil#textwidth = 74
let g:pencil#joinspaces = 0
let g:pencil#cursorwrap = 1
let g:pencil#conceallevel = 3
let g:pencil#concealcursor = 'c'
let g:airline_section_x = '%{PencilMode()}'
let g:pencil#softDetectSample = 20
let g:pencil#softDetectThreshold = 130
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
setglobal nobomb
set nobomb
set background=dark             " Assume a dark background
set mouse=                      " Automatically disable mouse usage
set mousehide                   " Hide the mouse cursor while typing
set shortmess+=aoOtTI           " Abbrev. of messages (avoids 'hit enter')
set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
set foldmethod=syntax
set foldlevelstart=20
set virtualedit=onemore         " Allow for cursor beyond last character
set history=1000                " Store a ton of history (default is 20)
set nospell                     " Spell checking off
set hidden                      " Allow buffer switching without saving
set backup                      " Backups are nice ...
set tabpagemax=15               " Only show 15 tabs
set showmode                    " Display the current mode
set cursorline                  " Highlight current line
set backspace=indent,eol,start  " Backspace for dummies
set linespace=0                 " No extra spaces between rows
set number                      " Line numbers on
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
set shiftwidth=2                " Use indents of 4 spaces
set tabstop=2                   " An indentation every four columns
set softtabstop=2               " Let backspace delete indent
set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
set splitright                  " Puts new vsplit windows to the right of the current
set splitbelow                  " Puts new split windows to the bottom of the current
set fileencoding=utf-8
set expandtab
set noerrorbells
set colorcolumn=80
set tags=./tags,tags;$HOME
" }}}

" Global abbreviations {{{
:iab <expr> dts strftime("%Y-%m-%d")
" }}}

" conditional settings {{{
if has('persistent_undo')
    set undofile                " So is persistent undo ...
    set undolevels=1000         " Maximum number of changes that can be undone
    set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
endif
" }}}

" CMDLine {{{
if has('cmdline_info')
    set ruler                   " Show the ruler
    set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
    set showcmd                 " Show partial commands in status line and selected characters/lines in visual mode
endif
" }}}

" Statusline {{{
if has('statusline')
    set laststatus=2
endif
" }}}

" Clipboard {{{
if has('clipboard')
    if LINUX()
        set clipboard=unnamedplus
    else
        set clipboard=unnamed
    endif
endif
" }}}

" GUI {{{
if has('gui_running')
    set guioptions-=T
    set lines=40
    set transparency=0
    syntax enable
    set background=dark
    colorscheme apprentice
else
    let g:indent_guides_enable_on_vim_startup = 0
    set t_Co=256
    syntax enable
    set background=dark
    colorscheme apprentice
endif
" }}}

" Windows {{{
if WINDOWS()
    set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
    if has('multi_byte')
        set termencoding=cp850
        setglobal fileencoding=utf-8
        set fileencodings=ucs-bom,utf-8,utf-16le,cp1252,iso-8859-15
    endif
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
nmap ; :Buffers<CR>
nmap <Leader>w :bd<CR>
nmap <Leader>t :GFiles<CR>
nmap <Leader>T :Files<CR>
nmap <Leader>r :Tags<CR>
nnoremap <Leader>PH :PencilHard<CR>
nnoremap <Leader>PO :PencilOff<CR>
nnoremap <Leader>PT :PencilToggle<CR>
nnoremap <Leader>u :GundoToggle<CR>
nnoremap <S-Left> :SidewaysLeft<cr>
nnoremap <S-Right> :SidewaysRight<cr>
vmap <Enter> <Plug>(EasyAlign)
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

" Highlight recent visual selections {{{
nnoremap <Leader>V `[v`]
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

" Linting actions {{{
nnoremap <Leader>ln :lnext<CR>          " Next linting error
nnoremap <Leader>lN :lprev<CR>          " Previous linting error
" }}}

" command mode helpers {{{
cmap w!! w !sudo tee % >/dev/null
cmap cd. lcd %:p:h
" }}}

" clear search results {{{
nmap <silent> <Leader>/ :nohlsearch<CR>
" }}}

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""" LOCAL OVERRIDES """""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if filereadable(expand("~/.vimrc.local"))
    source ~/.vimrc.local
endif

" vim: set sw=4 ts=4 sts=4 et tw=78 nospell:
