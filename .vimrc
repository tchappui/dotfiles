" ==================================================================== 
" File: .vimrc
" Description: Basic vim configuration file for python and i
" web development
" Author: Thierry Chappuis
" Date: 2017-05-17
" =====================================================================

" ---------------------------------------------------------------------
" Vundle section
" ---------------------------------------------------------------------
set nocompatible	" required for vundle
filetype off		" required for vundle

" Set the runtime path to include Vundle and initialize
" set rtp+=~/vimfiles/b undle/Vundle.vim/	" For windows
" call vundle#begin('~/vimfiles/bundle/')	" For windows

set rtp+=~/.vim/bundle/Vundle.vim			" for Posix
call vundle#begin()							" for Posix

" Let Vundle manage itself (required)
Plugin 'VundleVim/Vundle.vim'

" All the plugins must be added after the present line
Plugin 'tomasr/molokai'
Plugin 'scrooloose/nerdtree'
Plugin 'fatih/vim-go'
Plugin 'mattn/emmet-vim'
Plugin 'mileszs/ack.vim'  
Plugin 'wincent/command-t'
Plugin 'shougo/unite.vim'
Plugin 'shougo/vimshell.vim'
Plugin 'nelsyeung/twig.vim'
Plugin 'vim-scripts/LustyExplorer'
" Plugin 'cohama/lexima.vim'  
Plugin 'jiangmiao/auto-pairs'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'joonty/vdebug'
Plugin 'ain/vim-npm'
Plugin 'christoomey/vim-tmux-navigator'

" All the plugins must be added before the present line
call vundle#end()

syntax on
filetype plugin indent on   " required

" --------------------------------------------------------------------- 
" Basic setup
" ---------------------------------------------------------------------
set hlsearch		" hightlight search matches
set incsearch		" activates incremental search
set ignorecase      " ingnore case when searching
set tabstop=4	    " how many columns a tab counts for
set noexpandtab	    " tabs will not be replaced by spaces in i-mode
set shiftwidth=4    " indentation spaces inserted by >> and cindent
set softtabstop=4   " spaces inserted when tab is hit in i-mode
set smartindent		" smart indentation
set autoread		" Reloads files changed outside vim
set splitbelow		" :split opens new buffer below the current one
set splitright		" :vplit opens new buffer on the right of the 
" one
set ruler			" displays the line and col numbers in the status
set backspace=indent,eol,start	" fi the default behaviour fo the 
" backspace key
set matchpairs+=<:>	" match angle brackets with the % key
set wildmenu		" enhanced mode for command-line completion	
set wildmode=full
set number			" display line numbers
set relativenumber	" display relative line numbers
set term=screen-256color
set background=dark
colorscheme molokai " choice of colorsheme
set hidden

" ---------------------------------------------------------------------
" Convenient mappings
" ---------------------------------------------------------------------

" Remap of map leader key
let mapleader="é"
let maplocalleader="à"

" Transform the previous word to uppercase in insert mode
inoremap <leader>u <esc>viwU<esc>ea
" Transform the actual word to uppercases in normal mode
nnoremap <leader>u viwU<esc>e

" Remapping the Esc key for faster access in insert mode
inoremap jk <esc>
vnoremap jk <esc>

inoremap jl <esc>A

" Map up/down arrows to move paragraph
nnoremap <up> {
nnoremap <down> }

" Some remaps for windows navigation 
nnoremap <C-j> <C-W><C-J>
nnoremap <C-k> <C-W><C-K>
nnoremap <C-l> <C-W><C-L>
nnoremap <C-h> <C-W><C-H>
nnoremap <leader>y <c-w>3+
nnoremap <leader>< <c-w>3-
nnoremap <leader><< <c-w>3<
nnoremap <leader>yy <c-w>3> 
nnoremap <leader>t <c-]>
inoremap <leader>oo <esc>o
inoremap <leader>OO <esc>O
inoremap <leader>$$ <esc>$a
nnoremap <leader>$$ $a
inoremap <leader>__ <esc>_i
nnoremap <leader>__ _i

" Some remaps for tabs navigation
nnoremap <leader>fd :tabprevious<cr>
nnoremap <leader>df :tabnext<cr>
nnoremap <leader>gg :tabnew<cr>

" Some remaps to move tabs around
nnoremap <leader>er :tabm +1<cr> " move tab to the right 
nnoremap <leader>re :tabm -1<cr> " move tab to the left

nnoremap <leader>bb :Breakpoint
nnoremap <leader>cc <f10>

" Remaps for LustyExporer
nnoremap <leader>/ :LustyBufferGrep<cr>

" Map a command to execute NERDTree
map <leader>nt :NERDTree<CR>

nnoremap <leader>nn :w<cr>:Npm run build<cr>

" Map a command to execute a python script
map <leader>py :w<CR>:!py %<CR>

" ---------------------------------------------------------------------     
" .vimrc management section
" ---------------------------------------------------------------------

" mapping to quickly edit and source .vimrc
nnoremap <leader>ev	:tabnew $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" Auto-relaod my .vimrc configuration file when new changes are saved
augroup reload_vimrc
	autocmd!
	autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END

" --------------------------------------------------------------------
" Help configuration
" -------------------------------------------------------------------

" Open help files in a new tab
augroup HelpInTabs
	autocmd!
	autocmd BufEnter *.txt call HelpInNewTab()
augroup END

function! HelpInNewTab()
	if &buftype == 'help'
		" Convet the help window to a tab
		exe "normal \<C-W>T"
	endif
endfunction

" Helper mappings to navigate through :helpgrep results
nnoremap <silent> <right>			:cnext<cr>
nnoremap <silent> <right><right>	:cnfile<cr>
nnoremap <silent> <left>			:cprev<cr>
noremap <silent> <left><left>		:cpfile<cr>

" ---------------------------------------------------------------------
" Filetype configuration
"---------------------------------------------------------------------
autocmd FileType python setl ts=4 sts=4 sw=4 et
autocmd FileType html setl ts=2 sts=2 sw=2 noet

" --------------------------------------------------------------------
" Setting project root automatically
" --------------------------------------------------------------------

" follow symlinked file
function! FollowSymlink()
	let current_file = expand('%:p')
	" check if file type is a symlink
	if getftype(current_file) == 'link'
		" if it is a symlink resolve to the actual file path
		"   and open the actual file
		let actual_file = resolve(current_file)
		silent! execute 'file ' . actual_file
	end
endfunction

" set working directory to git project root
" or directory of current file if not git project
function! SetProjectRoot()
	" default to the current file's directory
	lcd %:p:h
	let git_dir = system("git rev-parse --show-toplevel")
	" See if the command output starts with 'fatal' (if it does, not in a git repo)
	let is_not_git_dir = matchstr(git_dir, '^fatal:.*')
	" if git project, change local directory to git project root
	if empty(is_not_git_dir)
		lcd `=git_dir`
	endif
endfunction

" follow symlink and set working directory
autocmd BufEnter *
			\ call FollowSymlink() |
			\ call SetProjectRoot()

" ---------------------------------------------------------------------
" VimShell configuration
" ---------------------------------------------------------------------
let g:vimshell_prompt = "tchappui@macos% "
let vimshell_split_command = 'tabnew'
let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
map <leader>st :tabnew<cr>:VimShellCurrentDir<cr>
map <leader>ss :split<cr>:VimShellCurrentDir<CR>
map <leader>sv :vsplit<cr>:VimShellCurrentDir<CR>
map <leader>nst :tabnew<cr>:VimShellCreate<CR>
map <leader>nss :split<cr>:VimShellCreate<cr>
map <leader>nsv :vsplit<cr>:VimShellCreate<cr>
map <leader>nbt :VimShellInteractive bash<cr>cd<esc><cr>i

" ---------------------------------------------------------------------
" Emmet config
" ---------------------------------------------------------------------

let g:user_emmet_settings = {
\	'html': {
\		'snippets': {	
\			'essai': 'html:5'
\		}
\	}
\}

" --------------------------------------------------------------------
" Toggle between relative and normal line numbers
" --------------------------------------------------------------------

function! NumberToggle()
	if(&relativenumber == 1)
		set norelativenumber
		set number
	else
		set number
		set relativenumber
	endif
endfunc

nnoremap <C-n> :call NumberToggle()<cr>

" --------------------------------------------------------------------
" Ack mappings
" -------------------------------------------------------------------
nnoremap <leader>ga :tab :split<cr> :Ack ""<Left>
nnoremap <leader>gs :tab :split<cr> :Ack <c-r><c-w><cr>

" --------------------------------------------------------------------
" CTAGS configuration
" --------------------------------------------------------------------

" Take case into account when matching a tag, even if noic is activated
function! MatchCaseTag()
	let ic = &ic
	set noic
	try
		exe 'tjump ' . expand('<cword>')
	finally
		let &ic = ic
	endtry
endfunction
nnoremap <silent> <c-]> :call MatchCaseTag()<CR>

function! PythonTags(mods)
	if a:mods ==? "all"	
		:!ctags -R --fields=+l --languages=python -f ./tags $(python -c "import os, sys; print(' '.join('{}'.format(d) for d in sys.path if os.path.isdir(d)))")
	else
		:!ctags -R --fields=+l --languages=python  -f ./tags ./
	endif
endfunction
command! Pyt :call PythonTags("")
command! Pytall :call PythonTags("all")

function! LeaveCurrentPairFunc()
	let hls = &hls
	set nohls
	try
		exe "normal! /\\v[\"')}\\]]\<cr>"
	finally
		let &hls = hls
	endtry
endfunction
command! LeaveCurrentPair :call LeaveCurrentPairFunc()
inoremap <leader>jl <esc>:LeaveCurrentPair<cr>a

nnoremap <leader>cc O/***/<esc>hhi<cr>

" --------------------------------------------------------------------
" Omnicompletion
" -------------------------------------------------------------------
set omnifunc=htmlcomplete#CompleteTags

" --------------------------------------------------------------------
"  Vdebug configuration
"  ------------------------------------------------------------------
let g:vdebug_options= {
    \    "port" : 9090,
    \    "server" : 'localhost',
    \    "timeout" : 20,
    \    "on_close" : 'detach',
    \    "break_on_open" : 1,
    \    "ide_key" : '',
    \    "path_maps" : {},
    \    "debug_window_level" : 0,
    \    "debug_file_level" : 0,
    \    "debug_file" : "",
    \    "watch_window_style" : 'expanded',
    \    "marker_default" : '⬦',
    \    "marker_closed_tree" : '▸',
    \    "marker_open_tree" : '▾'
    \}
