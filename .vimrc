set mouse=a
set ttymouse=xterm2
set number

" Note: Skip initialization for vim-tiny or vim-small.
if 0 | endif

if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=~/.vim/bundle/neobundle.vim/

" Required:
call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'Shougo/unite.vim.git'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'Shougo/vimproc.vim'
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'szw/vim-tags'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'violetyk/cake.vim'
NeoBundle 'majutsushi/tagbar'
NeoBundle 'osyo-manga/vim-anzu'
NeoBundle 'Shougo/unite.vim.git'
NeoBundle 'soramugi/auto-ctags.vim'
NeoBundle 'elzr/vim-json'

call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck

" disable elzr/vim-json syntax_conceal
let g:vim_json_syntax_conceal = 0

" spell check
set spell
set spelllang=en,cjk

" カラーシンタックスを有効にする
syntax on

" クリップボード
set clipboard=unnamed,autoselect

" escが遠いので代用する。
noremap <C-j> <esc>
noremap! <C-j> <esc>

" tabをスペース4つに
set tabstop=4
set autoindent
set expandtab
set shiftwidth=4

" :の入れ替え(US配列用)
nnoremap ' :

" ステータスラインを常に表示
set laststatus=2

" カラーのテーマを指定
set background=dark
colorscheme solarized

"" unite.vim 関係
" 入力モードで開始する
let g:unite_enable_start_insert=1
" バッファ一覧
nnoremap <C-k>b :<C-u>Unite buffer<CR>
" ファイル一覧
nnoremap <C-k>f :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
" レジスタ一覧
nnoremap <C-k>r :<C-u>Unite -buffer-name=register register<CR>
" 最近使用したファイル一覧
nnoremap <C-k>m :<C-u>Unite file_mru<CR>
" 常用セット
nnoremap <C-k>u :<C-u>Unite buffer file_mru<CR>
" 全部乗せ
nnoremap <C-k>a :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>
" ウィンドウを分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-v> unite#do_action('split')
au FileType unite inoremap <silent> <buffer> <expr> <C-v> unite#do_action('split')
" ウィンドウを縦に分割して開く
au FileType unite nnoremap <silent> <buffer> <expr> <C-h> unite#do_action('vsplit')
au FileType unite inoremap <silent> <buffer> <expr> <C-h> unite#do_action('vsplit')
"unite.vimを開いている間のキーマッピング
autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()"{{{
    " ESCでuniteを終了
    nmap <buffer> <ESC><ESC> <Plug>(unite_exit)
endfunction"}}}

" バックスペースが効かなくなる問題を解決
set backspace=indent,eol,start

" ファイル保存時にtagsファイルの作成
let g:auto_ctags = 1
" tagsファイルの保存先
let g:auto_ctags_directory_list = ['.git', '.svn']
set tags+=.svn/tags
" tagsファイルの命名設定
let g:auto_ctags_filetype_mode = 1
" tagsジャンプの時に複数ある時は一覧表示
nnoremap <C-]> g<C-]>

"" lightline
let g:lightline = {
            \ 'colorscheme': 'default',
            \ 'mode_map': {'c': 'NORMAL'},
            \ 'active': {
            \   'left': [ ['mode', 'paste'], ['fugitive', 'filename', 'cakephp', 'currenttag', 'anzu'] ]
            \ },
            \ 'component': {
            \   'lineinfo': ' %3l:%-2v',
            \ },
            \ 'component_function': {
            \   'modified': 'MyModified',
            \   'readonly': 'MyReadonly',
            \   'fugitive': 'MyFugitive',
            \   'filename': 'MyFilename',
            \   'fileformat': 'MyFileformat',
            \   'filetype': 'MyFiletype',
            \   'fileencoding': 'MyFileencoding',
            \   'mode': 'MyMode',
            \   'anzu': 'anzu#search_status',
            \   'currenttag': 'MyCurrentTag',
            \   'cakephp': 'MyCakephp',
            \ }
            \ }

function! MyModified()
    return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
    return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? ' ' : ''
endfunction

function! MyFilename()
    return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
                \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
                \  &ft == 'unite' ? unite#get_status_string() :
                \  &ft == 'vimshell' ? vimshell#get_status_string() :
                \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
                \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFugitive()
    try
        if &ft !~? 'vimfiler\|gundo' && exists('*fugitive#head') && strlen(fugitive#head())
            return ' ' . fugitive#head()
        endif
    catch
    endtry
    return ''
endfunction

function! MyFileformat()
    return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! MyFiletype()
    return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
    return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyMode()
    return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! MyCurrentTag()
    return tagbar#currenttag('%s', '')
endfunction

function! MyCakephp()
    return exists('*cake#buffer') ? cake#buffer('type') : ''
endfunction

"" tab関連
"常にタブラインを表示
set showtabline=2

" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]
" Tab jump
" t1で1番左のタブ、t2で1番左から2番目のタブにジャンプ
for n in range(1, 9)
    execute 'nnoremap <silent> [Tag]'.n ':<C-u>tabnext'.n.'<CR>'
endfor

" tc 新しいタブを一番右に作る
map <silent> [Tag]c :tablast <bar> tabnew<CR>
" tx タブを閉じる
map <silent> [Tag]x :tabclose<CR>
" tn 次のタブ
map <silent> [Tag]n :tabnext<CR>
" tp 前のタブ
map <silent> [Tag]p :tabprevious<CR>
