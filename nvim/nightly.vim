call plug#begin('~/.vim/plugged')

" Plug 'jpalardy/vim-slime'
Plug 'machakann/vim-sandwich'
Plug 'tpope/vim-commentary'
Plug 'justinmk/vim-dirvish'
Plug 'justinmk/vim-sneak'
Plug 'junegunn/fzf.vim'
Plug 'nvim-treesitter/nvim-treesitter'
" Plug 'yuki-ycino/fzf-preview.vim'
" Plug 'psliwka/vim-smoothie'
" Plug 'sirver/ultisnips'
" Plug 'brennier/quicktex'

call plug#end()

" Automatically add cfilter 
" packadd cfilter

"====================plugin settings==================
"Enable fzf
set rtp+=~/Downloads/.fzf
set rtp+=~/repos/todolist.nvim

lua <<EOF
require 'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
    },
}
EOF

let g:todo_keywords = ["TODO", "ON-HOLD", "WAITING", "IN-PROGRESS", "DONE"]
let g:todo_tags = ["home", "school", "work", "appointment"]

map s <Plug>Sneak_s
map S <Plug>Sneak_S

omap z <Plug>Sneak_s
omap Z <Plug>Sneak_S

let g:fzf_preview_window = 'right:70%'

" manually configure sandwich mappings so they don't collide with vim-sneak
let g:sandwich_no_default_key_mappings=1
let g:operator_sandwich_no_default_key_mappings=1

nmap gs <Plug>(operator-sandwich-add)
nmap ds <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
nmap cs  <Plug>(operator-sandwich-replace)<Plug>(textobj-sandwich-query-a)

vmap gs <Plug>(operator-sandwich-add)
" vmap ds <Plug>(operator-sandwich-delete)
" vmap rs <Plug>(operator-sandwich-replace)

let g:tex_flavor="latex"

let g:slime_target="tmux"
let g:slime_default_config = {"socket_name": get(split($TMUX, ","), 0), "target_pane": ":.1"}
nmap <c-c><c-p> <Plug>SlimeParagraphSend
nmap <c-c><c-c> <Plug>SlimeLineSend

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

"====================autocomands and language specific stuff=============================
au BufRead,BufNewFile *.tex :call SetLatexSettings()
au BufRead,BufNewFile *.md :call SetLatexMarkdown()
au BufRead,BufNewFile *.md execute 'set makeprg=pandoc\ \-o\ \%:r.pdf\ \%'

" vim doesn't recognize julia files yet
au BufRead *.jl set ft=julia

" Remove line numbers in terminal mode
autocmd TermOpen * setlocal nonumber norelativenumber

"Configure fzf appearance
augroup fzf
autocmd!
autocmd FileType fzf setlocal noshowmode noruler norelativenumber nonumber
autocmd FileType fzf tnoremap <esc> <esc>
augroup END

"Latex stuff
"` is our insert mode leader

function! SetLatexSettings()
    nnoremap <buffer> <leader>init<cr> :0r /home/tony/.config/nvim/init.tex<cr>
	execute 'setlocal tabstop=2 shiftwidth=2 softtabstop=2'
    execute 'setlocal norelativenumber'
    execute 'setlocal errorformat=%f:%l:\ %m'
    execute 'setlocal makeprg=rubber\ -d\ %'
    inoremap <buffer> <leader>bb <esc>yiWi\begin{<esc>ea}<cr>\end{"}<esc>o<++><esc>kO
    inoremap <buffer> _{ _{}<++><esc>4<left>i
    inoremap <buffer> ^{ _{}<++><esc>4<left>i
    nnoremap <buffer><silent> <leader>m :call AsyncMake()<cr>
endfunc

function! SetLatexMarkdown()
	inoremap <leader>te \text{}<++><esc>4<left>i
	inoremap <leader>su \sum_{}^{<++>}<++><esc>11<left>i
	inoremap <leader>pr \prod_{}^{<++>}<++><esc>11<left>i
	inoremap <leader>fr \frac{}{<++>}<++><esc>10<left>i
	inoremap <leader>li \lim_{}<++><esc>4<left>i
    inoremap <leader>int \int_{}^{<++>}<++><esc>11<left>i
	inoremap <leader>b \mathbb{}<++>4<left>i
	inoremap <leader>bb <esc>yiWi\begin{<esc>Ea}<cr>\end{<esc>pa}<space><esc>kEa
endfunc

"====================syntax and highlights====================
syntax enable 
set background=dark
colorscheme wal

"====================variable declarations====================
filetype plugin indent on "load filetype-specific indent files and turns on filetype detection
set tabstop=4 "number of spaces per tab
set softtabstop=4 "number of spaces per tab when editing
set shiftwidth=4 "set shift width to four spaces
set autoindent "pressing enter keeps tab spacing instead of moving cursor to beginning of line
set expandtab

" set showtabline=2

set splitbelow splitright "Change how splits open

set lazyredraw "Run faster

set hidden "switch between buffers without saving

set statusline=%t\ " filename
set statusline+=%m\ " modified
set statusline+=%r\ " readonly flag
set statusline+=[b%n]\ %<" buffer number
set statusline+=%=%y\ "filetype
set statusline+=%l/%L\ "line fraction
set statusline+=[col\ %v]\ "column number
" set statusline+=%p%% "percent

"always set status line
set laststatus=2

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

set completeopt=menu,preview,menuone,noselect

"Make Y yank to EOL
nnoremap Y y$

let mapleader=","
" set showmatch "highlight matching parentheses

set number "this turns on line numbering
set relativenumber "turns on relative line numbering
set showcmd "show last command entered

set showmode

set shortmess+=c " don't print ugly completion messages

"remap left and right keys so they wrap around lines
set whichwrap+=<,>

"make it so you can go one char past the end of line in normal mode
set virtualedit=onemore

"make it so backspace can skip across lines
set backspace=indent,eol,start

set wildcharm=<c-z>

" Use ripgrep as the grepprg
set grepprg=rg\ --vimgrep\ -S\ $*\ >\ /dev/null

" cursor
set guicursor=n-v-sm:block,i-c-ci-ve:ver25,r-cr-o:hor20

"====================key mappings====================
"remap the vertical movements to work by visual lines
nnoremap <expr> j (v:count == 0 ? 'gj' : "m'" . v:count . 'j')
nnoremap <expr> k (v:count == 0 ? 'gk' : "m'" . v:count . 'k')

nnoremap <c-d> m'<c-d>
nnoremap <c-u> m'<c-u>

vnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
vnoremap <expr> k (v:count == 0 ? 'gk' : 'k')

" onoremap i_ :<c-u>norm! T_vt_<cr>

" better completion options
" enter to select
inoremap <expr> <cr> pumvisible() ? '<c-y>' : '<cr>'

" escape to not accept match
" inoremap <expr> <esc> pumvisible() ? '<c-e><esc>' : '<esc>'


" define this wildcard operator
inoremap `` <++>
inoremap <leader><leader> <esc>/<++><cr>"_ca<<c-o>:nohl<cr>

" basic emacs keys that I've gotten used to having
inoremap <c-f> <right>
inoremap <c-b> <left>

" look at buffers
nnoremap <leader>x :b <C-z><s-tab>

" save
nnoremap <space> :w<cr>

" paste with indentation on following line
nnoremap ]P o<c-o>]p<esc>k"_dd

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
" nnoremap <leader>f :Files<cr>
" nnoremap <leader>b :Buffers<cr>
" nnoremap <leader>/ :BLines<cr>
nnoremap <leader>f :FzfPreviewProjectFiles<cr>
nnoremap <leader>b :FzfPreviewBuffers<cr>
nnoremap <leader>/ :FzfPreviewBufferLines<cr>
nnoremap <leader><leader>m :Marks<cr>
nnoremap <leader>h :History<cr>

nnoremap <leader><leader>i :e ~/.config/nvim/init.vim<cr>

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

"exit terminal mode with esc
tnoremap <esc> <c-\><c-n>

"open quickix window
nnoremap <leader>c :copen<cr>

nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>p "+p
vnoremap <leader>p "+p

"open pdf viewer for latex and md
nnoremap <leader>o :! setsid zathura %:r.pdf<cr>

"move around on command line faster
cnoremap <c-a> <home>
cnoremap <c-f> <right>
cnoremap <c-b> <left>
cnoremap <a-f> <s-right>
cnoremap <a-b> <s-left>

" <c-f> allows editing of commands in a separate buffer
cnoremap <c-l> <c-f>

"c-r in insert mode fucks up indentation
inoremap <c-r> <c-r><c-p>

" search with word boundaries
cnoremap <c-k> <home>\<<end>\>

nnoremap <leader>gw :silent lgrep! <c-r><c-w><cr>:lopen<cr>
nnoremap <leader>gr :silent lgrep! 
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
    " call jobstart(["rubber", "-d", expand("%")], g:callbacks)
    call jobstart(map(split(&makeprg), {_, v -> expand(v)}), g:callbacks)
endfunction

