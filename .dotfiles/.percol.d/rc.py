# Run command file for percol
from percol.key import SPECIAL_KEYS


# prompt
percol.view.PROMPT  = ur"<green>Input:</green> %q"
percol.view.RPROMPT = ur"[%i/%I]"


# keymap
SPECIAL_KEYS.update({
    27: '<ESC>',
    219: '['
})

percol.import_keymap({
    "C-f" : lambda percol: percol.command.forward_char(),
    "C-b" : lambda percol: percol.command.backward_char(),
    "C-p" : lambda percol: percol.command.select_previous(),
    "C-n" : lambda percol: percol.command.select_next(),
    "C-h" : lambda percol: percol.command.delete_backward_char(),
    "C-d" : lambda percol: percol.command.delete_forward_char(),
    "C-k" : lambda percol: percol.command.kill_end_of_line(),
    "C-a" : lambda percol: percol.command.beginning_of_line(),
    "C-e" : lambda percol: percol.command.end_of_line(),
    "C-v" : lambda percol: percol.command.select_next_page(),
    "M-v" : lambda percol: percol.command.select_previous_page(),
    "C-j" : lambda percol: percol.finish(),
    "C-[" : lambda percol: percol.cancel(),
    "<ESC>" : lambda percol: percol.cancel(),
})
