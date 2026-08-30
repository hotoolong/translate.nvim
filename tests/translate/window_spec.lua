local window = require('translate.window')

describe('window.calc_config', function()
  it('行数を高さにする', function()
    assert.are.equal(3, window.calc_config('a\nb\nc').height)
  end)

  it('最も長い行の表示幅を幅にする', function()
    assert.are.equal(5, window.calc_config('ab\nabcde\nabc').width)
  end)

  it('全角文字を2幅として数える', function()
    assert.are.equal(14, window.calc_config('ホットウーロン').width)
  end)

  it('末尾の改行を行数に数えない', function()
    assert.are.equal(2, window.calc_config('a\nb\n').height)
  end)

  it('中間の空行は行数に数える', function()
    assert.are.equal(3, window.calc_config('a\n\nb').height)
  end)

  it('カーソル相対の最小スタイルで開く設定を返す', function()
    local config = window.calc_config('a')
    assert.are.equal('cursor', config.relative)
    assert.are.equal('minimal', config.style)
    assert.are.equal(1, config.row)
    assert.are.equal(1, config.col)
  end)
end)
