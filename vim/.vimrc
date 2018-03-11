" This is the oh my vim directory
let $OH_MY_VIM="/home/grigoriev/.oh-my-vim"
let &runtimepath=substitute(&runtimepath, '^', $OH_MY_VIM.",", 'g')

" Select the packages you need
let g:oh_my_vim_packages=[
            \'vim',
            \'basic',
            \'code', 
            \'text', 
            \'grep', 
            \'searching', 
            \'registers', 
            \'navigation', 
            \'files', 
            \'git', 
            \'python', 
            \'web',
            \'tools', 
            \'markdown', 
            \'bookmarks', 
            \'sessions', 
            \'spelling',
            \'neobundle', 
            \'golang'
            \]

exec ':so ' $OH_MY_VIM."/vimrc"



" hotkeys
nnoremap <F10> :qa<CR>                                                          

" command line height is 2 lines
set cmdheight=2 

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %


let g:monokai_original = 1

set textwidth=0

" highlight Normal ctermbg=none
"highlight nonText ctermbg=none
" highlight Comment ctermbg=none

