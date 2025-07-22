" Tyler Triplett
" fastswap.vim
" This does slightly more than :b#, as you can ignore defined filetypes.

let g:fastSwapBuffs = []

function s:ValidBuffer(bufn) abort
    let ft = getbufvar(a:bufn, "&filetype")
    return ft !=# 'netrw' && 
                \ ft !=# 'nerdtree' &&
                \ !isdirectory(bufname(a:bufn))
endfunction

function s:VerifyBuffers() abort
  let g:fastSwapBuffs = filter(
        \ g:fastSwapBuffs,
        \ 'bufexists(v:val) && s:ValidBuffer(v:val)'
        \ )
endfunction

function s:SaveTwoRecent() abort
    let currBufNum = bufnr('%')
    if !s:ValidBuffer(currBufNum)
        return
    endif
    call filter(g:fastSwapBuffs, 'v:val !=# currBufNum')
    call add(g:fastSwapBuffs, currBufNum)
    if len(g:fastSwapBuffs) > 2 
        call remove(g:fastSwapBuffs, 0)
    endif
endfunction

function FastSwap() abort
    let currBufNum = bufnr('%')
    let buffSize = len(g:fastSwapBuffs)
    if !s:ValidBuffer(currBufNum)
        echo "INVALID BUFFER"
    elseif buffSize == 0
        echo "NO BUFFERS"
    elseif buffSize == 1
        echo "NO OTHER BUFFERS"
    else
        execute 'buffer' g:fastSwapBuffs[0]
    endif
endfunction

augroup FastSwapGroup
    autocmd!
    autocmd VimEnter * call timer_start(100, {-> s:VerifyBuffers()})
    autocmd BufEnter * call s:VerifyBuffers()
    autocmd BufEnter * call s:SaveTwoRecent()
augroup EN
