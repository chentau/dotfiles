set nocompatible
call plug#begin('~/.vim/plugged')

Plug 'jpalardy/vim-slime'
Plug 'machakann/vim-sandwich'
Plug 'tpope/vim-commentary'
Plug 'justinmk/vim-dirvish'
Plug 'justinmk/vim-sneak'
Plug 'junegunn/fzf.vim'
Plug 'psliwka/vim-smoothie'
" Plug 'sirver/ultisnips'
Plug 'brennier/quicktex'

call plug#end()

" Automatically add cfilter 
packadd cfilter
"====================plugin settings==================
"Enable fzf
set rtp+=~/.fzf
set rtp+=~/repos/todolist.nvim

let g:todo_keywords = ["TODO", "ON-HOLD", "WAITING", "DONE"]
let g:todo_tags = ["home", "school", "work", "appointment"]

"Enable autocomplete
set omnifunc=syntaxcomplete#Complete

map s <Plug>Sneak_s
map S <Plug>Sneak_S

omap z <Plug>Sneak_s
omap Z <Plug>Sneak_S

" manually configure sandwich mappings so they don't collide with vim-sneak
let g:sandwich_no_default_key_mappings=1
let g:operator_sandwich_no_default_key_mappings=1

nmap gs <Plug>(operator-sandwich-add)
nmap gd <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
nmap gr <Plug>(operator-sandwich-replace)<Plug>(textobj-sandwich-query-a)

vmap gs <Plug>(operator-sandwich-add)
vmap gd <Plug>(operator-sandwich-delete)
vmap gr <Plug>(operator-sandwich-replace)

let g:tex_flavor="latex"

let g:slime_target="tmux"
let g:slime_python_ipython=1
let g:slime_default_config = {"socket_name": get(split($TMUX, ","), 0), "target_pane": ":.1"}
nmap <c-c><c-p> <Plug>SlimeParagraphSend
nmap <c-c><c-c> <Plug>SlimeLineSend

set conceallevel=0

set mouse=

" ultisnips
" let g:UltiSnipsSnippetDirectories=["/home/tony/.config/nvim/UltiSnips/"]
" let g:UltiSnipsExpandTrigger="<tab>"

let g:quicktex_trigger = " "
let g:quicktex_tex = {
            \'zm': '\[<+++>\]<++>',
            \'zb': '\textbf{<+++>}<++>'
            \}

let g:quicktex_math = {
            \'fr': '\frac{<+++>}{<++>}<++>',
            \'df': '\dfrac{<+++>}{<++>}<++>',
            \'ovl': '\overline{<+++>}{<++>}<++>',
            \'hat': '\widehat{<+++>}{<++>}<++>',
            \'zx': '\text{<+++>}<++>',
            \'su': '\sum_{<+++>}^{<++>}<++>',
            \'prod': '\prod_{<+++>}^{<++>}<++>',
            \'int': '\int_{<+++>}^{<++>}<++>',
            \'de': '\frac{d}{d<+++>}<++>',
            \'inv': '^{-1}(<+++>)<++>',
            \'diff': '^{(<+++>)}(<++>)<++>',
            \'star': '^*',
            \'bb': '\mathbb{<+++>}',
            \'cal': '\mathcal{<+++>}',
            \}

let g:quicktex_python = {
            \'ifmain': "if __name__ == \"__main__\":\<cr><+++>",
            \}

"====================autocomands and language specific stuff=============================
au BufRead,BufNewFile *.tex :call SetLatexSettings()
"Re-compile on save
au BufRead,BufNewFile *.md execute 'set makeprg=pandoc\ \-o\ \%:r.pdf\ \%'
au BufRead,BufNewFile *.md :call SetLatexMarkdown()

" Prevent auto insertion of comments on new line
" autocmd BufNewFile,BufRead,BufEnter * setlocal formatoptions-=cro

" Remove line numbers in terminal mode
autocmd TermOpen * setlocal nonumber norelativenumber

"Configure fzf appearance
autocmd FileType fzf setlocal laststatus=0 noshowmode noruler norelativenumber nonumber

"Latex stuff
"` is our insert mode leader

function! SetLatexSettings()
    nnoremap <buffer> <leader>init<cr> :0r /home/tony/.config/nvim/init.tex<cr>
	execute 'setlocal tabstop=2 shiftwidth=2 softtabstop=2'
    execute 'setlocal norelativenumber'
    execute 'setlocal errorformat=%f:%l:\ %m'
    inoremap <buffer> <leader>bb <esc>yiWi\begin{<esc>ea}<cr>\end{"}<esc>o<++><esc>kO
    inoremap <buffer> _{ _{}<++><esc>4<left>i
    inoremap <buffer> ^{ _{}<++><esc>4<left>i
    nnoremap <buffer><silent> <leader>m :call AsyncMake()<cr>
endfunc

function! SetLatexMarkdown()
	inoremap <leader>bf <esc>Bi\textbf{<esc>Ea}<++><esc>4<left>i
	inoremap <leader>mf <esc>Bi\mathbf{<esc>Ea}<++><esc>4<left>i
	inoremap <leader>it <esc>Bi\textit{<esc>Ea}<++><esc>4<left>i
	inoremap <leader>ve <esc>Bi\vec{<esc>Ea}<++><esc>4<left>i
	inoremap <leader>ba <esc>Bi\overline{<esc>Ea}<++><esc>4<left>i
	inoremap <leader>ha <esc>Bi\hat{<esc>Ea}<++><esc>4<left>i
	inoremap <leader>te <esc>Bi\text{<esc>Ea}<++><esc>4<left>i
	inoremap <leader>su \sum_{}^{<++>}<++><esc>11<left>i
	inoremap <leader>pr \prod_{}^{<++>}<++><esc>11<left>i
	inoremap <leader>fr \frac{}{<++>}<++><esc>10<left>i
	inoremap <leader>li \lim_{}<++><esc>4<left>i
	inoremap <leader>sq \sqrt{}<++><esc>4<left>i
	inoremap <leader>ee \mathbb{E}
	inoremap <leader>bb <esc>yiWi\begin{<esc>Ea}<cr>\end{<esc>pa}<space><esc>kEa
endfunc

"====================initialization====================
syntax enable 
set background=dark
colorscheme wal

" Set background color to be same as terminal
highlight Normal ctermbg=none guibg=none
highlight NonText ctermbg=none guibg=none
highlight LineNr ctermbg=none guibg=none
highlight SignColumn ctermbg=none guibg=none

"====================variable declarations====================
filetype plugin indent on "load filetype-specific indent files and turns on filetype detection
set tabstop=4 "number of spaces per tab
set softtabstop=4 "number of spaces per tab when editing
set shiftwidth=4 "set shift width to four spaces
set autoindent "pressing enter keeps tab spacing instead of moving cursor to beginning of line
set expandtab

" set termguicolors "Beautiful colors
" set showtabline=2

set splitbelow splitright "Change how splits open

set lazyredraw "Run faster

set hidden "switch between buffers without saving

set statusline=%f\ " filename
set statusline+=%m\ " modified
set statusline+=%r\ " readonly flag
set statusline+=[b%n]\ %<" buffer number
set statusline+=%=%y\ "filetype
set statusline+=%l/%L\ "line fraction
set statusline+=[col\ %v]\ "column number
set statusline+=%p%% "percent

"always set status line one
set laststatus=0

set hlsearch
set incsearch
set smartcase
set ignorecase

set wildmenu
set wildmode=longest:full,full
set wildignore=*.pyc,*.swp,*.class,*.aux,*.bbl,*.blg,*.fls,*.fdb_latexmk,.git,.git/*

" set scrolloff=3 "Start scrolling 3 lines from border

" incremental search and replace - nvim only
set inccommand=nosplit

"Make Y yank to EOL
nnoremap Y y$

let mapleader=","
" set showmatch "highlight matching parentheses

set number "this turns on line numbering
set relativenumber "turns on relative line numbering
set showcmd "show last command entered

set showmode "Redundant, now that I have a statusline plugin

"remap left and right keys so they wrap around lines
set whichwrap+=<,>

"make it so you can go one char past the end of line in normal mode
set virtualedit=onemore

"make it so backspace can skip across lines
set backspace=indent,eol,start

set wildcharm=<c-z>

" Use ripgrep as the grepprg
set grepprg=rg\ --vimgrep\ -S\ $*\ >\ /dev/null

"====================key mappings====================
" bring up my todo list
nnoremap <silent> <leader>t :lua require'todo'.popup_todo_file("~/wiki/todo.adoc")<cr>

"remap the vertical movements so they don't skip over a wrapped line
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')

vnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
vnoremap <expr> k (v:count == 0 ? 'gk' : 'k')

"Strip trailing whitespace - useful for python
nnoremap <leader><leader>s :%s/\s\+$//n<cr>

" define this wildcard operator
inoremap `` <++>
inoremap <leader><leader> <esc>/<++><cr>"_ca<<c-o>:nohl<cr>

" basic emacs keys that I've gotten used to having
inoremap <c-f> <right>
inoremap <c-b> <left>

" insert just one character
nnoremap <c-p> i_<esc>r

" look at buffers
nnoremap <leader>x :ls<cr> :b <C-z><s-tab>

"I make this typo too much - remap it to what I mean when I type this
cnoreabbrev Wq wq
cnoreabbrev WQ wq
cnoreabbrev Q q
cnoreabbrev Q! q!
cnoreabbrev W w
cnoreabbrev E e

"control l redraws the screen and removes search highlighting
nnoremap <silent><c-l> :nohl<cr><c-l>

" make # and * search for highlighted word under cursor
vnoremap # y?<c-r>"<cr>
vnoremap * y/<c-r>"<cr>

" switch between buffers
nnoremap <leader>l :b#<cr>

" FZF mappings
nnoremap <leader>f :Files<cr>
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>/ :BLines<cr>
nnoremap <leader><leader>m :Marks<cr>
nnoremap <leader>h :History:

nnoremap <leader><leader>i :e ~/.init.vim<cr>

"switch between buffers and quickfix
nnoremap [b :bnext<cr>
nnoremap ]b :bprev<cr>

nnoremap ]c :cnext<cr>
nnoremap [c :cprev<cr>

nnoremap ]l :lnext<cr>
nnoremap [l :lprev<cr>

nnoremap ]t :tabnext
nnoremap [t :tabprev

" quick insert of space
nnoremap <leader><space> i<space><esc>

"Copy and pasting to clipboard
vnoremap <leader>y "+y
nnoremap <leader>y "+y
nnoremap <leader>p "+p
nnoremap <leader>yy "+yy

"exit terminal mode with esc
tnoremap <esc> <c-\><c-n>

"open quickix window
nnoremap <leader>c :copen<cr>

"open pdf viewer for latex and md
nnoremap <leader>o :! setsid zathura %:r.pdf<cr>

cnoremap <c-a> <home>
cnoremap <c-f> <right>
cnoremap <c-b> <left>

nnoremap <c-g> 2<c-g>
" ----------------functions----------------------

" these functions turn off the highlighting
noremap <expr> <Plug>(StopHL) execute('nohlsearch')[-1]
noremap! <expr> <Plug>(StopHL) execute('nohlsearch')[-1]

func! HlSearch()
    " This function is called after the cursor moves - see the augroup
    "
    " match gets the index of the match between the text on the current line and the
    " previous search pattern, starting from our current column 
    " if there is no match, returns -1
    let l:pos = match(getline('.'), @/, col('.') - 1) + 1
    " If even after the cursor move, the index of the match is the same as our current column,
    " that means that we have simply jumped to the next match. in that case,
    " keep the highlighting; if we have moved away from the search pattern,
    " then clear the highlighting.
    if l:pos != col('.')
        call StopHL()
    endif
endfunc

func! StopHL()
    if !v:hlsearch || mode() isnot 'n'
        return
    else
        " calls the functions to clear highlighting
        sil call feedkeys("\<Plug>(StopHL)", 'm')
    endif
endfunc

augroup SearchHighlight
au!
    au CursorMoved * call HlSearch()
    au InsertEnter * call StopHL()
augroup end

function! OnEvent(jobid, data, event)
    " handle any stderr from shell command
    if a:event == "stderr"
        call setqflist([], "a", {"lines": a:data})
    endif
endfunction

let g:callbacks = {
\ "on_stdout": function("OnEvent"),
\ "on_stderr": function("OnEvent"),
\ "on_exit": function("OnEvent")
\ }

function! AsyncMake()
    w
    call setqflist([], "r")
    call jobstart(["rubber", "-d", expand("%")], g:callbacks)
endfunction
