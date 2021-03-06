#===============================================================================
# Search and execute command from shell history file
#===============================================================================

hiss() {
  eval $( history 1 \
    | fzf +s --tac \
    | sed 's/ *[0-9]* *//' \
  )
}
