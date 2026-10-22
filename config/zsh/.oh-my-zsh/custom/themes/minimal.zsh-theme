# Minimal theme: diretório atual, branch git e um prompt que muda de cor com o status do último comando.

ZSH_THEME_GIT_PROMPT_PREFIX=" %F{8}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%f"
ZSH_THEME_GIT_PROMPT_DIRTY="%F{3}*%f"
ZSH_THEME_GIT_PROMPT_CLEAN=""

PROMPT='%F{4}%1~%f$(git_prompt_info) %(?.%F{5}.%F{1})❯%f '
RPROMPT=''
