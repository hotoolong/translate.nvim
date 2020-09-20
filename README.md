# translate.nvim

Translate between Japanese English and English Japanese

# Requirement
- curl
- neovim 0.4.0 or above

# Installtion
You can use the plugin manager or Vim8 package manager.

eg: dein.vim

```toml
[[plugins]]
repo = 'hotoolong/translate.nvim'
```

Plugin

```vim
Plug 'hotoolong/translate.nvim'
```

# Usage

Converts Japanese to English and English to Japanese.

The language code is bellow.

https://cloud.google.com/translate/docs/languages

Translate current line
```vim
:Translate
```

Translate specified words
```vim
" result: こんにちは私の名前はホットウーロンです
:Translate hello my name is hotoolong
```

Reverse between resource and target to translate when using "!"
```vim
" result: It's a hotoolong
:Translate! ホットウーロンです
```

Translate selected lines
```vim
:'<,'>Translate
```

You can use below options
```vim
let g:translate_source = "en"
let g:translate_target = "ja"
let g:translate_popup_window = 0 " if you want use popup window, set value 1
let g:translate_winsize = 10 " set buffer window height size if you doesn't use popup window
```

You can also set key mappings.

```vim
nmap gr <Plug>(Translate)
vmap t <Plug>(VTranslate)
```

# Homage

https://github.com/skanehira/translate.vim

