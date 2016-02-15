"============================================================
"                    Vim Markdown Preview
"   git@github.com:JamshedVesuna/vim-markdown-preview.git
"============================================================

let s:OSNAME = 'Unidentified'

if has('win32')
" Not yet used
let s:OSNAME = 'win32'
endif
if has('unix')
let s:OSNAME = 'unix'
endif
if has('mac')
let s:OSNAME = 'mac'
endif

if !exists("g:vim_markdown_preview_browser")
  if s:OSNAME == 'mac'
    let g:vim_markdown_preview_browser = 'Safari'
  else
    let g:vim_markdown_preview_browser = 'Google Chrome'
  endif
endif

if !exists("g:vim_markdown_preview_temp_file")
  let g:vim_markdown_preview_temp_file = 0
endif

if !exists("g:vim_markdown_preview_toggle")
  let g:vim_markdown_preview_toggle = 0
endif

if !exists("g:vim_markdown_preview_github")
  let g:vim_markdown_preview_github = 0
endif

if !exists("g:vim_markdown_preview_use_xdg_open")
    let g:vim_markdown_preview_use_xdg_open = 0
endif

if !exists("g:vim_markdown_preview_hotkey")
    let g:vim_markdown_preview_hotkey='<C-p>'
endif

function! Vim_Markdown_Preview()

  let curr_file = expand('%:p')

  if g:vim_markdown_preview_github == 1
    call system('grip "' . curr_file . '" --export /tmp/vim-markdown-preview.html')
  else
    call system('markdown "' . curr_file . '" > /tmp/vim-markdown-preview.html')
  endif

  if s:OSNAME == 'unix'
    let chrome_wid = system("xdotool search --name 'vim-markdown-preview.html - " . g:vim_markdown_preview_browser . "'")
    if !chrome_wid
      if g:vim_markdown_preview_use_xdg_open == 1
        call system('xdg-open /tmp/vim-markdown-preview.html &> /dev/null &')
      else
        call system('see /tmp/vim-markdown-preview.html &> /dev/null &')
      endif
    else
      let curr_wid = system('xdotool getwindowfocus')
      call system('xdotool windowmap ' . chrome_wid)
      call system('xdotool windowactivate ' . chrome_wid)
      call system("xdotool key 'ctrl+r'")
      call system('xdotool windowactivate ' . curr_wid)
    endif
  endif

  if s:OSNAME == 'mac'
    call system('open -a "' . g:vim_markdown_preview_browser . '" -g /tmp/vim-markdown-preview.html')
  endif

  if g:vim_markdown_preview_temp_file == 1
    sleep 200m
    call system('rm /tmp/vim-markdown-preview.html')
  endif
endfunction


"Renders html locally and displays images
function! Vim_Markdown_Preview_Local()

  let curr_file = expand('%:p')

  if g:vim_markdown_preview_github == 1
    call system('grip "' . curr_file . '" --export "' . curr_file . '".html')
  else
    call system('markdown "' . curr_file . '" > "' . curr_file . '".html')
  endif

  if s:OSNAME == 'unix'
    let chrome_wid = system("xdotool search --name '". curr_file . ".html - " . g:vim_markdown_preview_browser . "'")
    if !chrome_wid
      if g:vim_markdown_preview_use_xdg_open == 1
        call system('xdg-open /tmp/vim-markdown-preview.html &> /dev/null &')
      else
        call system('see /tmp/vim-markdown-preview.html &> /dev/null &')
      endif
    else
      let curr_wid = system('xdotool getwindowfocus')
      call system('xdotool windowmap ' . chrome_wid)
      call system('xdotool windowactivate ' . chrome_wid)
      call system("xdotool key 'ctrl+r'")
      call system('xdotool windowactivate ' . curr_wid)
    endif
  endif

  if s:OSNAME == 'mac'
    call system('open -a "' . g:vim_markdown_preview_browser . '" -g "' . curr_file . '".html')
  endif

  if g:vim_markdown_preview_temp_file == 1
    sleep 200m
    call system('rm "' . curr_file . '".html')
  endif
endfunction

if g:vim_markdown_preview_toggle == 0
  "Maps vim_markdown_preview_hotkey to Vim_Markdown_Preview()
  :exec 'autocmd Filetype markdown,md map <buffer> ' . g:vim_markdown_preview_hotkey . ' :call Vim_Markdown_Preview()<CR>'
elseif g:vim_markdown_preview_toggle == 1
  "Display images - Maps vim_markdown_preview_hotkey to Vim_Markdown_Preview_Local() - saves the html file locally
  "and displays images in path
  :exec 'autocmd Filetype markdown,md map <buffer> ' . g:vim_markdown_preview_hotkey . ' :call Vim_Markdown_Preview_Local()<CR>'
elseif g:vim_markdown_preview_toggle == 2
  "Display images - Automatically call Vim_Markdown_Preview_Local() on buffer write
  autocmd BufWritePost *.markdown,*.md :call Vim_Markdown_Preview_Local()
elseif g:vim_markdown_preview_toggle == 3
  "Automatically call Vim_Markdown_Preview() on buffer write
  autocmd BufWritePost *.markdown,*.md :call Vim_Markdown_Preview()
endif
