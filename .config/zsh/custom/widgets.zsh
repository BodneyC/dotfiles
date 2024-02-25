#!/usr/bin/env zsh

# Adapted from:
#  https://github.com/zsh-users/zsh/blob/master/Functions/Zle/backward-kill-word-match
#
# The purpose of this widget is to allow me to C-w through a command
#  line based on my WORDCHARS var (select-word-style normal) which is empty
#  but not skip non-whitespace which are also non-alphanumeric
#
# For an example, the default behaviour is:
#
#   command subcommand --option # hit C-w
#   command subcommand --       # hit C-w
#   command                     # both '--' and 'subcommand' are deleted
#
# With this:
#
#   command subcommand --option # hit C-w
#   command subcommand --       # hit C-w
#   command subcommand          # only '--' is deleted

backward-kill-word-include-multi-char-ws() {
  emulate -L zsh
  setopt extendedglob

  autoload match-words-by-style

  local ws_after_last_word word lbuffer
  local -a matched_words

  match-words-by-style

  # # NOTE: Keeping for debugging purposes, some of the names are "wrong" in
  # #  the context of WORDCHARS (normal) it seems
  # echo
  # echo "start              '$matched_words[0]'"
  # echo "word-before-cursor '$matched_words[1]'" # phrase before the last word
  # echo "ws-before-cursor   '$matched_words[2]'" # last word before the cursor
  # echo "ws-after-cursor    '$matched_words[3]'" # whitespace after last word
  # echo "word-after-cursor  '$matched_words[4]'"
  # echo "ws-after-word      '$matched_words[5]'"
  # echo "end                '$matched_words[6]'"
  # echo "is-word-start      '$matched_words[7]'"

  ws_after_last_word="$matched_words[3]"
  # If the whitespace after the end of the previous word (bad naming) contains
  #  more than just spaces...
  if [[ -n ${ws_after_last_word// /} ]]; then
    # ... the word we'd like to delete is just that whitespace (e.g. ' --')
    word="$ws_after_last_word"
    lbuffer="$matched_words[1]$matched_words[2]"
  else
    word="$matched_words[2]$ws_after_last_word"
    lbuffer=$matched_words[1]
  fi

  if [[ -n $word ]]; then
    if [[ $LASTWIDGET == *kill* ]]; then
      CUTBUFFER="$word$CUTBUFFER"
    else
      zle copy-region-as-kill -- "$word"
    fi
    LBUFFER="$lbuffer"
  else
    # If there's no word then the phrase in lbuffer is all non-word
    LBUFFER=''
  fi

  zle -f 'kill'
}
zle -N backward-kill-word-include-multi-char-ws
