syn region Mdlatexinline start="\$" end="\$"
syn region Mdlatexblock start="\$\$" end="\$\$"

highlight def link Mdlatexinline Constant
highlight def link Mdlatexblock Identifier
