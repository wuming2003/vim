" vim:set ts=4 et sts=4 sw=4 ft=vim:
" -------------------------------------------------------------------------------------------------
" Create by yangrz
" -------------------------------------------------------------------------------------------------
if has('unix')
    set runtimepath-=/usr/share/vim/vimfiles
    set runtimepath-=/usr/share/vim/vimfiles/after
    set nocompatible
    source $VIMRUNTIME/vimrc_example.vim
endif

" -------------------------------------------------------------------------------------------------
" pack manager
" -------------------------------------------------------------------------------------------------
execute pathogen#infect('bundle/default/{}')
if v:version >= 800
    execute pathogen#infect('bundle/vim8/{}')
else
    execute pathogen#infect('bundle/vim7/{}')
endif
syntax on
filetype plugin indent on

" -------------------------------------------------------------------------------------------------
" global configure
" -------------------------------------------------------------------------------------------------
set vb t_vb=
set mouse=
if has("gui_running")
    set mouse=a
endif
"  ���ع�����
set guioptions-=T      

" ��root��modeline, ���ܴ��ڰ�ȫ����
set modeline

if has('win32')
    set encoding=utf-8
    set langmenu=zh_CN.UTF-8
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim
    language messages zh_CN.utf-8
    let &termencoding=&encoding
    set fileencoding=cp936
endif

if has('unix')
    source $VIMRUNTIME/ftplugin/man.vim
    nmap K :Man <cword><CR>
endif

if has('win32')
    source $VIMRUNTIME/ftplugin/man.vim
    nmap K :Man <cword><CR>
endif

" �������
if has('win32')
    au GUIEnter * simalt ~x
endif

" -------------------------------------------------------------------------------------------------
" plugin configure
" -------------------------------------------------------------------------------------------------
" Gitv configure
let g:Gitv_OpenHorizontal = 1

" ale configure
let g:ale_lint_on_enter = 0
let g:ale_set_signs = 0
let g:ale_set_quickfix = 1
" let g:ale_linters = {
" \   'c++': ['clang'],
" \   'c': ['clang'],
" \   'python': ['pylint'],
" \}
 let g:ale_linters = {
 \   'python': ['flake8'],
 \}


function! GnomeMaxWindow()
    exe 'silent !wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz'
endfun
if has('unix')
    au GUIEnter * call GnomeMaxWindow()
endif

" ��������
if has('unix')
    set gfn=courier\ 10\ pitch\ 13
    set gfw=simsun\ 13
    set gfs=simsun\ 12
endif

" ����Ĭ���۵���
au GUIEnter * set foldcolumn=4

" �ı���ɫ����
colorscheme yangrz

let g:author="yangrz@centerm.com"

" taglist�������
let Tlist_Exit_OnlyWindow=1
let Tlist_Show_One_File=1
let Tlist_Use_Right_Window=1
let Tlist_File_Fold_Auto_Close=1
let Tlist_Enable_Fold_Column=0
" ���ô�taglist�Ŀ�ݽ�
noremap <F8> :TlistToggle<CR>

" �ر��Զ����ɱ����ļ��Ĺ���
set nobackup
set noundofile
set nowritebackup

" �л����ڵĿ�ݽ�
noremap <TAB> <C-W><C-W>
" ����һ���ᵼ��copen����ENTER���޷�ʹ��
" noremap <C-M> <TAB>

function! FTabToSpace()
    let times = 0
    while search('\t', 'w') > 0
        let buf = getline(".")
        let col = stridx(buf, "\t")
        let str = strpart(buf, 0, col)

        let num_of_chars        = strlen(substitute(str, ".", "x", "g"))
        let a = substitute(str, '[^\x00-\x7f]', '', "g")
        let num_of_ansii_chars  = strlen(a)
        let num_of_not_ansii_chars = num_of_chars - num_of_ansii_chars

        let display_col = num_of_ansii_chars + num_of_not_ansii_chars * 2

        let tabToSpace = ''
        let tabstopLen = eval(&tabstop)
        let tabstopLen = tabstopLen - display_col % tabstopLen
        for i in range(tabstopLen)
            let tabToSpace = tabToSpace . ' '
        endfor

        exec "s/\t/" . tabToSpace . "/"
        let times = times + 1
    endwhile
    echomsg "Replace " . times . " times"
endfun

" ��tab�滻Ϊ�ո�Ŀ�ݼ�
function! MyTabToSpace()
    let tabToSpace = ''
    let tabstopLen = eval(&tabstop) 
    for i in range(tabstopLen)
        let tabToSpace = tabToSpace . ' '
    endfor
    return tabToSpace
endfun

noremap  <F2> me:exe FTabToSpace()<CR>'e

" ����ļ�ͷ
command! -nargs=0 Header :call AddFileHeadComment()
" noremap <silent> <C-H> :call AddFileHeadComment()<CR>

" ������Сд����
set ignorecase smartcase

" �ı���뷽ʽ
if has('unix')
    set encoding=utf-8
    set fileencoding=utf-8
    set fileencodings=ucs-bom,utf-8,cp936
    set ambiwidth=double
endif

" ����tabҳ����ʾ�ı�
set guitablabel=%t
if has('gui_running') && has('unix')
    set showtabline=2
endif

" ����ȫ����ɵĿ�ݼ�
imap <C-j> <C-X><C-O>

"------------------------------------------------------------------------------
" �ʼ�д
"------------------------------------------------------------------------------
if has('win32')
    iabbrev <silent> $C$ Change by yangrz, <C-R>=strftime("%x", localtime())<CR>
    iabbrev <silent> $A$ Add by yangrz, <C-R>=strftime("%x", localtime())<CR>
    iabbrev <silent> $DATE$ <C-R>=strftime("%x", localtime())<CR>
else
    iabbrev <silent> $C$ Change by yangrz, <C-R>=strftime("%F", localtime())<CR>
    iabbrev <silent> $A$ Add by yangrz, <C-R>=strftime("%F", localtime())<CR>
    iabbrev <silent> $DATE$ <C-R>=strftime("%F", localtime())<CR>
endif

iabbrev $//$ <ESC>ddO//------------------------------------------------------------------------------

"------------------------------------------------------------------------------
" ���ú���
"------------------------------------------------------------------------------
fun! s:FileTabChange()
    setl tabstop=4
    setl shiftwidth=4
    setl sts=4
    setl et
endfun

" C,C++�۵�����ʾ�ı�
function! MyCFoldText()
    let line = getline(v:foldstart)
    let tabToSpace = MyTabToSpace()
    let sub = substitute(line, '\t', tabToSpace, 'g')
    let sub = substitute(sub, '\(.\{-}\)\s*$', '\1', 'g')
    let sub = sub . " ... }"
    return sub
endfunction

fun! s:FoldMethod(type, b_chagne_text)
    exec "setl foldmethod=" . a:type
    setl fillchars=fold:\ ,
    if ( a:b_chagne_text )
        setl foldtext=MyCFoldText()
    endif
    normal zR
endfun

"------------------------------------------------------------------------------
" c ���Բ���
"------------------------------------------------------------------------------

" �Ƿ�ı�tab����
let s:CChangeTabConfig = 1

" �ر�ע���۵�
let c_no_comment_fold = 1
" �ر�if0�۵�
let c_no_if0_fold = 1

function! s:CFileConfig()
    " �޸�tab������
    if s:CChangeTabConfig
        call s:FileTabChange()
    endif

    " �Զ����
    setlocal completeopt=menu

    " �۵�
    call s:FoldMethod("syntax", 1)

    " �����ʽ���Ŀ�ݼ�
    if has('win32')
        noremap <buffer> <F10> me:%!vindent.bat<CR>'e
        vnoremap <buffer> <F10> :!vindent.bat<CR>
    elseif has('unix')
        noremap <buffer> <F10> me:%!vindent.sh<CR>'e
        vnoremap <buffer> <F10> :!vindent.sh<CR>
    endif

    " ��Ӻ���ͷע�͵Ŀ�ݼ�
    noremap <buffer> <silent> <C-F> :Dox<CR>

endfun

" cscope����
set csto=0
set nocsverb
set cscopequickfix=s-,c-,d-,i-,t-,e-,g-
set timeoutlen=10000

au filetype c,cpp call s:CFileConfig()
au filetype iss call s:FileTabChange()

"------------------------------------------------------------------------------
" python
"------------------------------------------------------------------------------
function! s:PythonConfig() 
    call s:FileTabChange()
    call s:FoldMethod("indent", 0)
    let g:jedi#auto_vim_configuration = 0
    setlocal completeopt=menu
    let g:jedi#show_call_signatures_delay = 50
endfun

au filetype python     call s:PythonConfig()

"------------------------------------------------------------------------------
" To html
"------------------------------------------------------------------------------
command! -nargs=0 Htlm :source $VIMRUNTIME/syntax/2html.vim

"------------------------------------------------------------------------------
" vim
"------------------------------------------------------------------------------
function! s:VimConfig()
    call s:FileTabChange()
    call s:FoldMethod("indent", 0)
endfun

au filetype vim        call s:VimConfig()

"------------------------------------------------------------------------------
" perl
"------------------------------------------------------------------------------
let g:perldoc_program="perldoc"
let perl_include_pod = 1
let perl_extended_vars = 1
let perl_fold=1
let perl_fold_blocks=1

function! s:PerlConfig()
    " set encoding=utf-8
    " set fileencodings=ucs-bom,utf-8,cp936
    " set ambiwidth=double
    " if has('win32')
    "     language message zh_CN.UTF-8
    "     source $VIMRUNTIME\delmenu.vim
    "     source $VIMRUNTIME\menu.vim 
    " endif
    call s:FileTabChange()
    call s:FoldMethod("syntax", 1)
    let g:perl_compiler_force_warnings = 0
    setl autoindent
    nnoremap K :Perldoc -f <cword><CR>
    compiler perl
endfun

au filetype perl        call s:PerlConfig()

"------------------------------------------------------------------------------
" sh
"------------------------------------------------------------------------------
function! s:ShConfig()
    call s:FileTabChange()
    call s:FoldMethod("indent", 0)
    setlocal makeprg=bash\ -n\ %
    setlocal errorformat=%f:\ line\ %l:\ %m
endfun

au filetype sh         call s:ShConfig()

if v:version >= 703
    " set cc=80
endif
