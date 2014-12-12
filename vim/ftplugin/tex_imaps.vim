" ==============================================================================
" mappings
" ==============================================================================
" {{{
" calculate the mapleader character.
let s:ml = '<Leader>'
let g:Tex_Leader = '`'

if !exists('s:doneMappings')
	let s:doneMappings = 1
	" short forms for latex formatting and math elements. {{{
	" taken from auctex.vim or miktexmacros.vim
	"call IMAP ('__', '_{<++>}<++>', "tex")
	"call IMAP ('()', '(<++>)<++>', "tex")
	"call IMAP ('[]', '[<++>]<++>', "tex")
	"call IMAP ('{}', '{<++>}<++>', "tex")
	"call IMAP ('^^', '^{<++>}<++>', "tex")
	"call IMAP ('$$', '$<++>$<++>', "tex")
	call IMAP ('==', '&=& ', "tex")
	call IMAP ('~~', '&\approx& ', "tex")
	call IMAP ('=~', '\approx', "tex")
	call IMAP ('::', '\dots', "tex")
	"call IMAP ('((', '\left( <++> \right)<++>', "tex")
	"call IMAP ('[[', '\left[ <++> \right]<++>', "tex")
	"call IMAP ('{{', '\left\{ <++> \right\}<++>', "tex")
	call IMAP (g:Tex_Leader.'^', '\hat{<++>}', "tex")
	call IMAP (g:Tex_Leader.'_', '\bar{<++>}', "tex")
	call IMAP (g:Tex_Leader.'6', '\partial', "tex")
	call IMAP (g:Tex_Leader.'8', '\infty', "tex")
	call IMAP (g:Tex_Leader.'/', '\frac{<++>}{}', "tex")
	call IMAP (g:Tex_Leader.'%', '\frac{<++>}{}', "tex")
	call IMAP (g:Tex_Leader.'@', '\circ', "tex")
	call IMAP (g:Tex_Leader.'0', '^\circ', "tex")
	call IMAP (g:Tex_Leader.'=', '\equiv', "tex")
	call IMAP (g:Tex_Leader."\\",'\setminus', "tex")
	call IMAP (g:Tex_Leader.'.', '\cdot', "tex")
	call IMAP (g:Tex_Leader.'*', '\times', "tex")
	call IMAP (g:Tex_Leader.'&', '\wedge', "tex")
	call IMAP (g:Tex_Leader.'-', '\bigcap', "tex")
	call IMAP (g:Tex_Leader.'+', '\bigcup', "tex")
	call IMAP (g:Tex_Leader.'M', '\sum_{<++>}^{}', 'tex')
	call IMAP (g:Tex_Leader.'S', '\sum_{<++>}^{}', 'tex')
	call IMAP (g:Tex_Leader.'(', '\subset', "tex")
	call IMAP (g:Tex_Leader.')', '\supset', "tex")
	call IMAP (g:Tex_Leader.'<', '\langle', "tex")
	call IMAP (g:Tex_Leader.'>', '\rangle', "tex")
	call IMAP (g:Tex_Leader.',', '\nonumber', "tex")
	call IMAP (g:Tex_Leader.'~', '\tilde{}', "tex")
	call IMAP (g:Tex_Leader.';', '\dot{<++>}', "tex")
	call IMAP (g:Tex_Leader.':', '\ddot{<++>}', "tex")
	call IMAP (g:Tex_Leader.'2', '\sqrt{<++>}', "tex")
	call IMAP (g:Tex_Leader.'|', '\Big|', "tex")
	call IMAP (g:Tex_Leader.'I', "\\int_{<++>}^{}", 'tex')
	" Custom Mappings
	call IMAP (g:Tex_Leader.'A', "\\forall", 'tex')
	call IMAP (g:Tex_Leader.'E', "\\exists", 'tex')
	" }}}
	" Greek Letters {{{
	call IMAP(g:Tex_Leader.'a', '\alpha', 'tex')
	call IMAP(g:Tex_Leader.'b', '\beta', 'tex')
	call IMAP(g:Tex_Leader.'c', '\chi', 'tex')
	call IMAP(g:Tex_Leader.'d', '\delta', 'tex')
	call IMAP(g:Tex_Leader.'e', '\varepsilon', 'tex')
	call IMAP(g:Tex_Leader.'f', '\varphi', 'tex')
	call IMAP(g:Tex_Leader.'g', '\gamma', 'tex')
	call IMAP(g:Tex_Leader.'h', '\eta', 'tex')
	call IMAP(g:Tex_Leader.'i', '\iota', 'tex')
	call IMAP(g:Tex_Leader.'k', '\kappa', 'tex')
	call IMAP(g:Tex_Leader.'l', '\lambda', 'tex')
	call IMAP(g:Tex_Leader.'m', '\mu', 'tex')
	call IMAP(g:Tex_Leader.'n', '\nu', 'tex')
	call IMAP(g:Tex_Leader.'p', '\pi', 'tex')
	call IMAP(g:Tex_Leader.'q', '\theta', 'tex')
	call IMAP(g:Tex_Leader.'r', '\rho', 'tex')
	call IMAP(g:Tex_Leader.'s', '\sigma', 'tex')
	call IMAP(g:Tex_Leader.'t', '\tau', 'tex')
	call IMAP(g:Tex_Leader.'u', '\upsilon', 'tex')
	call IMAP(g:Tex_Leader.'v', '\varsigma', 'tex')
	call IMAP(g:Tex_Leader.'w', '\omega', 'tex')
	call IMAP(g:Tex_Leader.'x', '\xi', 'tex')
	call IMAP(g:Tex_Leader.'y', '\psi', 'tex')
	call IMAP(g:Tex_Leader.'z', '\zeta', 'tex')
	" not all capital greek letters exist in LaTeX!
	" reference: http://www.giss.nasa.gov/latex/ltx-405.html
	call IMAP(g:Tex_Leader.'D', '\Delta', 'tex')
	call IMAP(g:Tex_Leader.'F', '\Phi', 'tex')
	call IMAP(g:Tex_Leader.'G', '\Gamma', 'tex')
	call IMAP(g:Tex_Leader.'Q', '\Theta', 'tex')
	call IMAP(g:Tex_Leader.'L', '\Lambda', 'tex')
	call IMAP(g:Tex_Leader.'X', '\Xi', 'tex')
	call IMAP(g:Tex_Leader.'Y', '\Psi', 'tex')
	call IMAP(g:Tex_Leader.'S', '\Sigma', 'tex')
	call IMAP(g:Tex_Leader.'U', '\Upsilon', 'tex')
	call IMAP(g:Tex_Leader.'W', '\Omega', 'tex')
	" }}}
	" ProtectLetters: sets up indentity maps for things like ``a {{{
	" " Description: If we simply do
	" 		call IMAP('`a', '\alpha', 'tex')
	" then we will never be able to type 'a' after a tex-quotation. Since
	" IMAP() always uses the longest map ending in the letter, this problem
	" can be avoided by creating a fake map for ``a -> ``a.
	" This function sets up fake maps of the following forms:
	" 	``[aA]  -> ``[aA]    (for writing in quotations)
	" 	\`[aA]  -> \`[aA]    (for writing diacritics)
	" 	"`[aA]  -> "`[aA]    (for writing german quotations)
	" It does this for all printable lower ascii characters just to make sure
	" we dont let anything slip by.
	function! s:ProtectLetters(first, last)
		let i = a:first
		while i <= a:last
			if nr2char(i) =~ '[[:print:]]'
				call IMAP('``'.nr2char(i), '``'.nr2char(i), 'tex')
				call IMAP('\`'.nr2char(i), '\`'.nr2char(i), 'tex')
				call IMAP('"`'.nr2char(i), '"`'.nr2char(i), 'tex')
			endif
			let i = i + 1
		endwhile
	endfunction 
	call s:ProtectLetters(32, 127)
	" }}}
	" vmaps: enclose selected region in brackets, environments {{{ 
	" The action changes depending on whether the selection is character-wise
	" or line wise. for example, selecting linewise and pressing \v will
	" result in the region being enclosed in \begin{verbatim}, \end{verbatim},
	" whereas in characterise visual mode, the thingie is enclosed in \verb|
	" and |.
	exec 'vnoremap <silent> '.g:Tex_Leader."( \<C-\\>\<C-N>:call VEnclose('\\left( ', ' \\right)', '\\left(', '\\right)')\<CR>"
	exec 'vnoremap <silent> '.g:Tex_Leader."[ \<C-\\>\<C-N>:call VEnclose('\\left[ ', ' \\right]', '\\left[', '\\right]')\<CR>"
	exec 'vnoremap <silent> '.g:Tex_Leader."{ \<C-\\>\<C-N>:call VEnclose('\\left\\{ ', ' \\right\\}', '\\left\\{', '\\right\\}')\<CR>"
	exec 'vnoremap <silent> '.g:Tex_Leader."$ \<C-\\>\<C-N>:call VEnclose('$', '$', '\\[', '\\]')\<CR>"
	" }}}
end

" }}}

