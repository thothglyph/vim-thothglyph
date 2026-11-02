" Guard: 二重読み込み防止
if exists('g:loaded_symbol_replacer')
  finish
endif
let g:loaded_symbol_replacer = 1

setlocal softtabstop=2

" 1. 置換対象の記号と、置換後の文字列のマップ定義
let g:symbol_replacer_map = get(g:, 'symbol_replacer_map', {
      \ '%%%': '🙾🙾🙾',
      \ '@@@': '⏸⏸⏸',
      \ '```': '⸌⸌⸌',
      \ '%%': '🙾🙾',
      \ '@1': '🔴',
      \ '@2': '🟡',
      \ '@3': '🟢',
      \ '@4': '🔵',
      \ '@5': '🟣',
      \ '%': '🙾',
      \ '#': '▮',
      \ '@': '⏸',
      \ '`': '⸌',
      \ '*': '•',
      \ '+': '꓾',
      \ ':': 'ᛝ',
      \ '-': '𐬹',
      \ '=': '◃',
      \ '\': '⊹',
      \ '⊹': '↲',
      \ '[': '⟦',
      \ ']': '⟧',
      \ '(': '⸨',
      \ ')': '⸩',
      \ '{': '⦃',
      \ '}': '⦄',
      \ '⟦': '⁅',
      \ '⟧': '⁆',
      \ '<': '⏴',
      \ '>': '⏵',
      \ '^': '⏶',
      \ '~': '⏷',
      \ '•': '⬮',
      \ '/': '🙼',
      \ '_': '‗',
      \ '◃': '¬',
      \ '⏶': '⌃',
      \ '⏷': '⌄',
      \ '🙼': '⁒',
      \ ';': '⟠',
      \ })

" 2. 置換処理のコア関数
function! s:ReplaceSymbolLeft() abort
  let l:line_str = getline('.')
  let l:col = col('.') " 1-indexed (カーソル位置)
  
  " インサートモード中はカーソルが「次に文字を入力する位置」にあるため、
  " 判定の基準点を左に1ずらす（ノーマルモード時はそのまま）
  let l:col = l:col - 1
  " if mode() =~# '^i'
  " if mode() =~# '^n'
  "   let l:col = l:col + 1
  " endif

  " 置換対象のキーを長い順（3文字→2文字→1文字）にソートして判定
  let l:sorted_keys = sort(keys(g:symbol_replacer_map), {a, b -> len(b) - len(a)})

  for l:key in l:sorted_keys
    let l:key_len = len(l:key)
    
    " カーソル位置（インサート時は直前の文字）を終端として、左側へ戻った開始インデックスを計算
    let l:start_idx = (l:col - 1) - (l:key_len - 1)
    let l:end_idx = l:col - 1
    
    " 行頭（0未満）を越えていないかチェック
    if l:start_idx >= 0
      let l:current_part = l:line_str[l:start_idx : l:end_idx]
      
      " 完全一致するか判定
      if l:current_part ==# l:key
        let l:replacement = g:symbol_replacer_map[l:key]
        let l:line_len = len(l:line_str)
        
        " 新しい行の文字列を構築
        let l:before = l:start_idx > 0 ? l:line_str[0 : l:start_idx - 1] : ''
        let l:after  = l:end_idx + 1 < l:line_len ? l:line_str[l:end_idx + 1 : -1] : ''
        let l:new_line = l:before . l:replacement . l:after
        
        " 行を更新
        call setline('.', l:new_line)
        
        " 【カーソル位置の調整】
        " 置換後の文字列の「直後」にカーソルを移動させます
        " インサートモードの継続を考慮して、次の文字の位置（+1）にセット
        let l:new_col = len(l:before) + len(l:replacement) + 1
        call cursor('.', l:new_col)
        return
      endif
    endif
  endfor
endfunction

" 3. キーマッピングの設定
" --- ノーマルモード用 ---
" 元のデフォルト機能（特に何もなし、または他プラグイン等のバインド）を上書きしてOFFにします
nnoremap <silent> <Plug>(SymbolReplacerN) :<C-u>call <SID>ReplaceSymbolLeft()<CR>
nmap <C-Space> <Plug>(SymbolReplacerN)

" --- インサートモード用 ---
" デフォルトの <C-Space>（直前入力の再挿入: <C-@> と同等）の機能を上書きして無効化します
inoremap <silent> <Plug>(SymbolReplacerI) <C-o>:call <SID>ReplaceSymbolLeft()<CR>
imap <C-Space> <Plug>(SymbolReplacerI)
