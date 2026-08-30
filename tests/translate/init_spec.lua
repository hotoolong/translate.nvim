local translate = require('translate')

describe('translate._get_text', function()
  before_each(function()
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { 'first line', 'second line', 'third line' })
  end)

  it('引数が空なら指定範囲の行を改行で連結する', function()
    assert.are.equal('first line\nsecond line', translate._get_text(1, 2, {}))
  end)

  it('引数が空なら単一行も取得できる', function()
    assert.are.equal('third line', translate._get_text(3, 3, {}))
  end)

  it('引数があれば範囲を無視して引数を連結する', function()
    assert.are.equal('hello world', translate._get_text(1, 3, { 'hello world' }))
  end)

  it('引数が nil でも範囲から取得する', function()
    assert.are.equal('first line', translate._get_text(1, 1, nil))
  end)
end)
