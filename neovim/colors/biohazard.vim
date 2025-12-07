" Name:         biohazard
" Description:  A high-contrast, industrial-themed color scheme
" Author:       AI Assistant
" Maintainer:   AI Assistant
" License:      MIT
" Last Updated: 2025-01-01

" Boilerplate to clear existing settings
hi clear
if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "biohazard"

" Set background to dark, a prerequisite for the deep charcoal background
set background=dark

" Enable true color support in the terminal if possible
if (has("termguicolors"))
  set termguicolors
endif

" Define the palette using highlight groups linked to standard names
" cterm colors correspond to the 0-15 ANSI color codes set in your terminal emulator
" gui colors use the exact hex codes

" Base Colors (Dim)
" Black: #141414 (c0) | Red: #A1262D (c1) | Green: #41FF00 (c2) | Yellow: #FF6600 (c3)
" Blue: #004873 (c4) | Magenta: #993366 (c5) | Cyan: #007373 (c6) | White: #F0F0F0 (c7)

" Bright Colors
" Bright Black: #888888 (c8) | Bright Red: #FF0000 (c9) | Bright Green: #88FF88 (c10) | Bright Yellow: #FFC200 (c11)
" Bright Blue: #0b89d5 (c12) | Bright Magenta: #FF00FF (c13) | Bright Cyan: #88FFFF (c14) | Bright White: #FFFFFF (c15)


" --- Standard Highlight Groups ---

" Normal text and background
hi Normal       guifg=#41FF00   guibg=#141414   ctermfg=2       ctermbg=0   gui=NONE cterm=NONE

" Cursor
hi Cursor       guifg=#141414   guibg=#FF6600   ctermfg=0       ctermbg=3   gui=NONE cterm=NONE
hi CursorLine   guibg=#1A1A1A   ctermbg=8       gui=NONE cterm=NONE

" Line numbers
hi LineNr       guifg=#007373   guibg=#141414   ctermfg=6       ctermbg=0   gui=NONE cterm=NONE
hi CursorLineNr guifg=#FF6600   guibg=#141414   ctermfg=3       ctermbg=0   gui=bold cterm=bold

" Status line
hi StatusLine   guifg=#141414   guibg=#FF6600   ctermfg=0       ctermbg=3   gui=bold cterm=bold
hi StatusLineNC guifg=#888888   guibg=#1A1A1A   ctermfg=8       ctermbg=0   gui=NONE cterm=NONE

" Visual mode selection
hi Visual       guifg=NONE      guibg=#004873   ctermfg=NONE    ctermbg=4   gui=reverse cterm=reverse

" Splits
hi VertSplit    guifg=#007373   guibg=#007373   ctermfg=6       ctermbg=6   gui=NONE cterm=NONE

" Diffs
hi DiffAdd      guifg=#88FF88   guibg=#007373   ctermfg=10      ctermbg=6
hi DiffChange   guifg=#FFC200   guibg=#004873   ctermfg=11      ctermbg=4
hi DiffDelete   guifg=#FF0000   guibg=#A1262D   ctermfg=9       ctermbg=1
hi DiffText     guifg=#FF6600   guibg=#A1262D   ctermfg=3       ctermbg=1   gui=bold cterm=bold

" Whitespace/non-text chars
hi NonText      guifg=#004873   guibg=#141414   ctermfg=4       ctermbg=0

" --- Syntax Highlighting Groups ---

" Comments (Muted secondary text)
hi Comment      guifg=#007373   ctermfg=6       gui=italic cterm=italic

" Constants (numbers, strings, booleans)
hi Constant     guifg=#FF6600   ctermfg=3
hi String       guifg=#FF6600   ctermfg=3
hi Number       guifg=#FFC200   ctermfg=11
hi Boolean      guifg=#FFC200   ctermfg=11

" Identifiers (function names, variables)
hi Identifier   guifg=#88FF88   ctermfg=10

" Statements (if, for, return, etc.)
hi Statement    guifg=#FF0000   ctermfg=9       gui=bold cterm=bold

" Types (int, void, classes, etc.)
hi Type         guifg=#0b89d5   ctermfg=12      gui=bold cterm=bold

" Preprocessor, special keywords
hi PreProc      guifg=#993366   ctermfg=5
hi Keyword      guifg=#FF0000   ctermfg=9
hi Special      guifg=#FF00FF   ctermfg=13

" Underlined (links)
hi Underlined   guifg=#0b89d5   ctermfg=12      gui=underline cterm=underline

" Errors and Warnings
hi Error        guifg=#FF0000   guibg=#A1262D   ctermfg=9       ctermbg=1   gui=bold cterm=bold
hi WarningMsg   guifg=#FF6600   ctermfg=3       gui=bold cterm=bold

" Todo marks
hi Todo         guifg=#141414   guibg=#FFC200   ctermfg=0       ctermbg=11  gui=bold cterm=bold

" End of colorscheme definition

