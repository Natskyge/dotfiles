"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=/home/natskyge/.config/nvim/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('/home/natskyge/.config/nvim/dein')
  call dein#begin('/home/natskyge/.config/nvim/dein')

  " Let dein manage dein
  " Required:
  call dein#add('/home/natskyge/.config/nvim/dein/repos/github.com/Shougo/dein.vim')

  " Plugins
  call dein#add('Shougo/deoplete.nvim')
  call dein#add('raimondi/delimitmate')
  call dein#add('scrooloose/nerdtree')
  call dein#add('junegunn/fzf', { 'build': './install --all', 'merged': 0 }) 
  call dein#add('junegunn/fzf.vim', { 'depends': 'fzf' })
  call dein#add('ap/vim-buftabline')
  call dein#add('justinmk/vim-sneak')
  call dein#add('w0rp/ale')
  call dein#add('hkupty/iron.nvim')
  call dein#add('junegunn/rainbow_parentheses.vim')
  call dein#add('NLKNguyen/c-syntax.vim')
  call dein#add('chriskempson/base16-vim')
  call dein#add('arcticicestudio/nord-vim')
  call dein#add('lervag/vimtex')
  call dein#add('junegunn/goyo.vim')
  call dein#add('vim-pandoc/vim-pandoc')

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" Install on startup
if dein#check_install()
  call dein#install()
endif

"End dein Scripts-------------------------

"Plugin setup-----------------------------

"Deoplete
"call deoplete#enable()
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
let g:deoplete#enable_at_startup = 1


"FZF
let g:fzf_action = {
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit'
      \ }
let $FZF_DEFUALT_COMMAND='ag --depth 10 --hiden --ignore .git -f -g ""'
au FileType fzf tnoremap <nowait><buffer> <esc> <c-g>

"Delimitmate
au FileType c let b:delimitMate_expand_cr = 1

"Vim sneak
map f <Plug>Sneak_s
map F <Plug>Sneak_S

"Buftabline
let g:buftabline_numbers=2

"LaTeX
let g:nofrils_heavylinenumbers=1
let g:nofrils_strbackgrounds=1
let g:nofrils_heavycomments=1 
let g:tex_fast = "bMpr"

"End plugin setup-------------------------



"Keybindings------------------------------

" Set <leader> to SPC
let mapleader=" "

" Buffers, use <leader>b + key too:
  "n - Switch to the next buffer
  nnoremap <leader>bn :bnext<CR>
  "p - Switch to the previouse buffer
  nnoremap <leader>bp :bprev<CR>
  "<number> - Switch to buffer with number <number>
  nmap <leader>b1 <Plug>BufTabLine.Go(1)
  nmap <leader>b2 <Plug>BufTabLine.Go(2)
  nmap <leader>b3 <Plug>BufTabLine.Go(3)
  nmap <leader>b4 <Plug>BufTabLine.Go(4)
  nmap <leader>b5 <Plug>BufTabLine.Go(5)
  nmap <leader>b6 <Plug>BufTabLine.Go(6)
  nmap <leader>b7 <Plug>BufTabLine.Go(7)
  nmap <leader>b8 <Plug>BufTabLine.Go(8)
  nmap <leader>b9 <Plug>BufTabLine.Go(9)
  nmap <leader>b0 <Plug>BufTabLine.Go(10)
  "d - kill current buffer
  nnoremap <leader>bd :bd<CR>
  nnoremap <leader>bD :bd!<CR>

" Windows, use <leader>w + key too:
  set splitbelow
  set splitright
  "v - Opens a veritcal split on the right
  nnoremap <leader>wv :vsp<cr>
  nnoremap <leader>wV :vsp!<cr>
  "s - Opens a horizontal split below
  nnoremap <leader>ws :split<cr>
  nnoremap <leader>wS :split!<cr>
  "d - Close split
  nnoremap <leader>wd :close<cr>
  nnoremap <leader>wD :close!<cr>
  "h/j/k/l - Navigate among windows
  nnoremap <leader>wk :wincmd k<CR>
  nnoremap <leader>wj :wincmd j<CR>
  nnoremap <leader>wh :wincmd h<CR>
  nnoremap <leader>wl :wincmd l<CR>

" Files, use <leader>f + key too:
  "f - Opens a buffer to search for files in the current directory.
  nnoremap <leader>ff :FZF<cr>
  nnoremap <leader>fF :FZF!<cr>
  "h - Opens a buffer to search for files in the home directory.
  nnoremap <leader>fh :FZF ~/<cr>
  nnoremap <leader>fH :FZF! ~/<cr>
  "s - Save the current file
  nnoremap <leader>fs :w<CR>
  nnoremap <leader>fS :w!<CR>
  "x - Save the current file and quit
  nnoremap <leader>fx :x<CR>
  nnoremap <leader>fX :x!<CR>
  "n - Create new file
  nnoremap <leader>fn :e 
  nnoremap <leader>fN :e! 
  "t - Open tree file browser
  nnoremap <leader>ft :NERDTreeToggle<CR>
  nnoremap <leader>fT :NERDTreeToggle!<CR>

" The init.vim file
  "<leader> f e d - Open your init.vim
  nnoremap <leader>fed :e ~/.config/nvim/init.vim<cr>
  nnoremap <leader>feD :e! ~/.config/nvim/init.vim<cr>

" Quit with <leader> q + key
  " Soft quit
  nnoremap <leader>qq :q<CR>
  nnoremap <leader>qQ :q!<CR>

" Open command line with <leader><leader>
  nnoremap <leader><leader> :

" Use <leader> l + letter to turn grammar checking on
  "d - Turn on danish grammar checking
  nnoremap <leader>lda :set spell spelllang=da<CR>
  "e - Turn on english grammar checking
  nnoremap <leader>len :set spell spelllang=en_us<CR>
  "n - Turn of grammar checking
  nnoremap <leader>lno :set spell spelllang=""<CR>

" Use <Esc> to exit terminal mode
  tnoremap <Esc> <C-\><C-n>

" Iron.vim keybindings, use <leader> r + letter to:
  "s - Start repl
  nnoremap <leader>rs :IronRepl<CR><C-\><C-N>:resize 10<CR>a

" Terminal
  nnoremap <leader>t <esc>:split<CR>:resize 10<CR>:term<CR>

"End keybindings--------------------------


"Colorscheme------------------------------

"hi  Normal ctermbg=none
set termguicolors
set cursorline
set background=dark
colorscheme base16-material

" Solarized
"hi BufTabLineActive  guibg=#073642 guifg=#839496
"hi BufTabLineCurrent guibg=#002b36 guifg=#839496
"hi BufTabLineHidden  guibg=#073642 guifg=#839496
"hi BufTabLineFill    guibg=#073642 guifg=#073642

set listchars=tab:│\ ,nbsp:␣,trail:∙,extends:>,precedes:<,eol:¬
set fillchars=vert:\│

"End colorscheme--------------------------


"Misc-------------------------------------

"Set number linee
set nu

"Set hidden
set hidden

" Set width to 80 and highlight text a columne 81
set textwidth=80
2mat ErrorMsg '\%81v.'

"Set unicode encoding, just to be sure
set encoding=utf-8

set wildignore+=.git,.hg,.svn
set wildignore+=*.aux,*.out,*.toc
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest,*.rbc,*.class
set wildignore+=*.ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp
set wildignore+=*.avi,*.divx,*.mp4,*.webm,*.mov,*.m2ts,*.mkv,*.vob,*.mpg,*.mpeg
set wildignore+=*.mp3,*.oga,*.ogg,*.wav,*.flac
set wildignore+=*.eot,*.otf,*.ttf,*.woff
set wildignore+=*.doc,*.pdf,*.cbr,*.cbz
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz,*.kgb
set wildignore+=*.swp,.lock,.DS_Store,._*

set shiftwidth=4     " indent = 4 spaces
set noexpandtab      " tabs are tabs
set tabstop=4        " tab = 4 spaces
set softtabstop=4    " backspace through spaces

" Fold
set foldmethod=marker

"End misc---------------------------------
