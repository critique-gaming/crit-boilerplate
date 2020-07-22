project = 'Crit Boilerplate'
package = 'crit'
title = 'Crit Boilerplace Reference'
file = { '.', exclude = { 'build', 'dist', '.internal' } }
format = 'discount'
style='docs'
readme = 'README.md'

add_language_extension('.script', 'lua')
add_language_extension('.gui_script', 'lua')
add_language_extension('.render_script', 'lua')
add_language_extension('.editor_script', 'lua')