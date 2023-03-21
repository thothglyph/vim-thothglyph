setlocal softtabstop=2

inoremap <buffer> %% ⑇
inoremap <buffer> ## ▮
inoremap <buffer> @@ ¤
inoremap <buffer> @@@ ¤¤¤
inoremap <buffer> `` ⸌
inoremap <buffer> ``` ⸌⸌⸌
inoremap <buffer> ** •
inoremap <buffer> ++ ꓾
inoremap <buffer> :: ᛝ
inoremap <buffer> -- ◃
inoremap <buffer> [[ ⟦
inoremap <buffer> ]] ⟧
inoremap <buffer> (( ⸨
inoremap <buffer> )) ⸩
inoremap <buffer> {{ ⁅
inoremap <buffer> }} ⁆
inoremap <buffer> << ⏴
inoremap <buffer> >> ⏵
inoremap <buffer> ^^ ⏶
inoremap <buffer> ~~ ⏷
inoremap <buffer> %<Space> ⑇
inoremap <buffer> /<Space> ⁒
inoremap <buffer> *<Space> ⋄
inoremap <buffer> _<Space> ‗
inoremap <buffer> -<Space> ¬
inoremap <buffer> ^<Space> ⌃
inoremap <buffer> ~<Space> ⌄
inoremap <buffer> `<Space> ⸌
inoremap <buffer> :<Space> ⫶

augroup no_map_chords
  autocmd!
  autocmd BufEnter <buffer> let g:bak_timeoutlen = &timeoutlen | set timeoutlen=350
  autocmd BufLeave <buffer> let &timeoutlen = g:bak_timeoutlen | unlet g:bak_timeoutlen
augroup END
