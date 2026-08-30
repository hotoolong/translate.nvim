std = 'luajit'
read_globals = { 'vim' }
globals = { 'vim.g' }
max_line_length = 120

files['tests/**/*_spec.lua'] = {
  read_globals = { 'describe', 'it', 'before_each', 'after_each' },
}
