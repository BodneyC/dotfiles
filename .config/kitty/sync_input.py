def main(args):
   # this is the main entry point of the kitten, it will be executed in
   # the overlay window when the kitten is launched
   # whatever this function returns will be available in the
   # handle_result() function
   return ""

def handle_result(args, answer, target_window_id, boss):
   # get the kitty window into which to paste answer
   w = boss.window_id_map.get(target_window_id)
   cwd = "cd " + str(w.cwd_of_child) + "\r"
   if w is not None:
      w.paste_bytes(cwd)
