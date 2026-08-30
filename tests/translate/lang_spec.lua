local lang = require('translate.lang')

describe('lang.is_english', function()
  it('treats a string of only letters and spaces as English', function()
    assert.is_true(lang.is_english('hello my name is hotoolong'))
  end)

  it('does not treat a Japanese string as English', function()
    assert.is_false(lang.is_english('ホットウーロンです'))
  end)

  it('does not treat English mixed with Japanese as English', function()
    assert.is_false(lang.is_english('hello ホットウーロン'))
  end)

  it('treats English containing symbols and digits as English', function()
    assert.is_true(lang.is_english("It's a hotoolong (2026)."))
  end)

  it('treats multi-line English as English', function()
    assert.is_true(lang.is_english('hello\nworld'))
  end)
end)
