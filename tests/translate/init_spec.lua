local translate = require('translate')

describe('translate._get_text', function()
  before_each(function()
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { 'first line', 'second line', 'third line' })
  end)

  it('joins the lines in the given range with newlines when no argument is passed', function()
    assert.are.equal('first line\nsecond line', translate._get_text(1, 2, {}))
  end)

  it('reads a single line when the range covers one line', function()
    assert.are.equal('third line', translate._get_text(3, 3, {}))
  end)

  it('joins the arguments and ignores the range when arguments are passed', function()
    assert.are.equal('hello world', translate._get_text(1, 3, { 'hello world' }))
  end)

  it('falls back to the range when the arguments are nil', function()
    assert.are.equal('first line', translate._get_text(1, 1, nil))
  end)
end)
