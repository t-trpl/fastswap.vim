" Tyler Triplett
" fastswap.vim

let g:fastSwapBuffs = []

function s:ValidBuffer(ft)
    return a:ft !=# 'netrw' && 
                \ a:ft !=# 'nerdtree' &&
                \ a:ft !=# ''
endfunction

function s:VerifyBuffers() abort
  let g:fastSwapBuffs = filter(
        \ g:fastSwapBuffs,
        \ 'bufexists(v:val) && s:ValidBuffer(getbufvar(v:val, "&filetype"))'
        \ )
endfunction

function s:SaveTwoRecent()
    let currBufNum = bufnr('%')
    if !s:ValidBuffer(&ft)
        return
    endif
    call filter(g:fastSwapBuffs, 'v:val !=# currBufNum')
    call add(g:fastSwapBuffs, currBufNum)
    if len(g:fastSwapBuffs) > 2 
        call remove(g:fastSwapBuffs, 0)
    endif
endfunction

function FastSwap()
    if !s:ValidBuffer(&ft)
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
augroup END
