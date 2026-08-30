local window = require('translate.window')

describe('window.calc_config', function()
  it('uses the line count as the height', function()
    assert.are.equal(3, window.calc_config('a\nb\nc').height)
  end)

  it('uses the display width of the longest line as the width', function()
    assert.are.equal(5, window.calc_config('ab\nabcde\nabc').width)
  end)

  it('counts a full-width character as two columns', function()
    assert.are.equal(14, window.calc_config('ホットウーロン').width)
  end)

  it('does not count a trailing newline as a line', function()
    assert.are.equal(2, window.calc_config('a\nb\n').height)
  end)

  it('counts a blank line between two lines as a line', function()
    assert.are.equal(3, window.calc_config('a\n\nb').height)
  end)

  it('returns a cursor-relative config in the minimal style', function()
    local config = window.calc_config('a')
    assert.are.equal('cursor', config.relative)
    assert.are.equal('minimal', config.style)
    assert.are.equal(1, config.row)
    assert.are.equal(1, config.col)
  end)
end)
