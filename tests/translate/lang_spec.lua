local lang = require('translate.lang')

describe('lang.is_english', function()
  it('英字と空白だけの文字列を英語と判定する', function()
    assert.is_true(lang.is_english('hello my name is hotoolong'))
  end)

  it('日本語を含む文字列を英語と判定しない', function()
    assert.is_false(lang.is_english('ホットウーロンです'))
  end)

  it('英語に日本語が混ざった文字列を英語と判定しない', function()
    assert.is_false(lang.is_english('hello ホットウーロン'))
  end)

  it('記号と数字を含む英文を英語と判定する', function()
    assert.is_true(lang.is_english("It's a hotoolong (2026)."))
  end)

  it('複数行の英文を英語と判定する', function()
    assert.is_true(lang.is_english('hello\nworld'))
  end)
end)
