"------------------------------------------------------------------------------
" Create by yangrz, 2009-2-15
"------------------------------------------------------------------------------

"------------------------------------------------------------------------------
" 描述: 在文件头添加注释
"------------------------------------------------------------------------------
function AddFileHeadComment()
    let author = g:author
    if has('win32')
        let timestr = strftime("%x", localtime())
    else
        let timestr = strftime("%F", localtime())
    endif
    let bufname = bufname("%")
    let basename = strpart(bufname, strridx(bufname, '\')+1)
    let basename = strpart(basename, strridx(basename, '/')+1)
    let suffix = strpart(basename, strridx(basename, '.')+1)
    let lnum = 1
    let col  = 1
    if &fileencoding != "" 
        let fencvar = &fileencoding
    else
        let fencvar = &encoding
    endif


    let head=[]
    if &filetype == "c" || &filetype == "cpp"
        " '/* vim:set ts=4 et sts=4 sw=4 fenc=' . fencvar . ': */',
        let head = [ '/**-----------------------------------------------------------------------------',
                   \ ' * @file     ' . basename,
                   \ ' *',
                   \ ' * @author   ' . author,
                   \ ' *',
                   \ ' * @date     ' . timestr,
                   \ ' *',
                   \ ' * @brief    ',
                   \ ' *',
                   \ ' * @version  ',
                   \ ' *',
                   \ ' *----------------------------------------------------------------------------*/' ]
        
        let lnum = len(head) + 1

    elseif &filetype == 'dosbatch'
        let head = [ '@echo off',
                   \ '@rem Create by ' . author . ', ' . timestr ]
        let lnum = len(head) + 1

    elseif &filetype == "vim"
        let head = [ '" Create by ' . author . ', ' . timestr ]
        let lnum = len(head) + 1

    elseif &filetype == "sh"
        let head = [ '#!/bin/sh',
                   \ '#-------------------------------------------------------------------------------',
                   \ '# Create by ' . author . ', ' . timestr,
                   \ '#-------------------------------------------------------------------------------' ]
        let lnum = len(head) + 1

    elseif &filetype == "python"
        let head = [ '#!/usr/bin/env python',
                   \ '#-------------------------------------------------------------------------------',
                   \ '# Create by ' . author . ', ' . timestr,
                   \ '#-------------------------------------------------------------------------------' ]
        let lnum = len(head) + 1

    elseif &filetype == "perl"
        let head = [ '#!/usr/bin/env perl',
                   \ '#-------------------------------------------------------------------------------',
                   \ '# Create by ' . author . ', ' . timestr,
                   \ '#-------------------------------------------------------------------------------',
                   \ 'use warnings;',
                   \ 'use strict;' ]
        let lnum = len(head) + 1

    elseif &filetype == "make"
        if suffix != "pro"
            let head = [ '#-------------------------------------------------------------------------------',
                       \ '# Create by ' . author . ', ' . timestr,
                       \ '#-------------------------------------------------------------------------------' ]
            let lnum = len(head) + 1
        else
            let head = [ '#-------------------------------------------------------------------------------',
                       \ '# Create by ' . author . ', ' . timestr,
                       \ '#-------------------------------------------------------------------------------',
                       \ 'SOURCES = ',
                       \ 'HEADERS = ',
                       \ 'SUBDIRS = ',
                       \ 'CONFIG -= qt',
                       \ 'INCLUDEPATH = ',
                       \ 'RESOURCES = ',
                       \ 'win32 {',
                       \ '    DEFINES -= UNICODE',
                       \ '    CONFIG += console',
                       \ '    DEFINES = _CRT_SECURE_NO_WARNINGS',
                       \ '    LIBS += $${QMAKE_LIBS_GUI}',
                       \ '    POST_TARGETDEPS +=',
                       \ '}',
                       \ 'unix {',
                       \ '    LIBS +=',
                       \ '    POST_TARGETDEPS +=',
                       \ '}' ]
            let lnum = 4
            let col = 11
        endif

    endif
                  
    if ( len(head) > 0 )
        call append(0, head)
        call cursor(lnum, col)
    endif
endfunction

"------------------------------------------------------------------------------
"------------------------------------------------------------------------------
let s:PosList_curPos = -1
let s:PosList = []

"------------------------------------------------------------------------------
" 描述: 添加当前位置到列表中
"------------------------------------------------------------------------------
function PosList_Add()
    let filename = bufname("%")
    let curpos = getpos(".")
    let line = curpos[1]
    let col = curpos[2]
    if s:PosList_curPos >= 0
        let prevItem = s:PosList[s:PosList_curPos]
        if prevItem[0] == filename && prevItem[1] == line
            return
        endif
    endif
    let s:PosList_curPos = s:PosList_curPos + 1
    if s:PosList_curPos  < len(s:PosList)
        let nextItem = s:PosList[s:PosList_curPos]
        if nextItem[0] == filename && nextItem[1] == line
            return
        endif
        call remove(s:PosList, s:PosList_curPos, len(s:PosList) - 1)
    endif

    call add(s:PosList, [filename, line, col])
endfunction

"------------------------------------------------------------------------------
" 描述: 后退
"------------------------------------------------------------------------------
function PosList_Back()
    if s:PosList_curPos > 0
        let s:PosList_curPos = s:PosList_curPos - 1
        let curItem = s:PosList[s:PosList_curPos]
        if curItem[0] != bufname("%")
            exe 'edit ' . curItem[0]
        endif
        call cursor(curItem[1], curItem[2])
    elseif s:PosList_curPos == 0
        let s:PosList_curPos = -1
    endif
endfunction

"------------------------------------------------------------------------------
" 描述: 前进
"------------------------------------------------------------------------------
function PosList_Forward()
    if (s:PosList_curPos + 1) < len(s:PosList)
        let s:PosList_curPos = s:PosList_curPos + 1
        let curItem = s:PosList[s:PosList_curPos]
        if curItem[0] != bufname("%")
            exe 'edit ' . curItem[0]
        endif
        call cursor(curItem[1], curItem[2])
    endif
endfunction

"------------------------------------------------------------------------------
" 描述: 输出列表
"------------------------------------------------------------------------------
function PosList_Echo()
    let myMsg =" #\tLine\tFile"
    let i = 0
    if s:PosList_curPos == -1
        let myMsg = myMsg . "\n>"
    endif
    while i < len(s:PosList)
        if s:PosList_curPos == i
            let myMsg = myMsg . "\n>"
        else
            let myMsg = myMsg . "\n "
        endif
        let curItem = s:PosList[i]
        let myMsgItem = printf("%d\t%d\t%s", i+1, curItem[1], curItem[0])
        let myMsg = myMsg . myMsgItem

        let i = i + 1
    endwhile
    echo myMsg
endfunction

"------------------------------------------------------------------------------
command -nargs=* Plist :call PosList_Echo(<f-args>)
