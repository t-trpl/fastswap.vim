" Tyler Triplett
" fastswap.vim

let g:fastSwapBuffs = []

function s:ValidBuffer(buff)
    let ft = getbufvar(a:buff, "&filetype")
    return ft !=# 'netrw' && 
                \ ft !=# 'nerdtree' &&
                \ !isdirectory(bufname(a:buff))
endfunction

function s:VerifyBuffers() abort
  let g:fastSwapBuffs = filter(
        \ g:fastSwapBuffs,
        \ 'bufexists(v:val) && s:ValidBuffer(v:val)'
        \ )
endfunction

function s:SaveTwoRecent()
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

function FastSwap()
    let currBufNum = bufnr('%')
    if !s:ValidBuffer(currBufNum)
        echo "INVALID BUFFER"
        return
    endif
    let buffSize = len(g:fastSwapBuffs)
    if buffSize == 0
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
