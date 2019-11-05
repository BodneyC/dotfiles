[[ "$TERMTHEME" == "light" ]] \
	&& export BAT_THEME="GitHub"
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git --exclude node_modules --exclude vendor"
export FZF_PREVIEW_COMMAND="bat --style=numbers --color=always {} || highlight -O ansi -l {} || coderay {} || rougify {} || cat {}"
