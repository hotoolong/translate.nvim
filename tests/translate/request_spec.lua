local request = require('translate.request')

describe('request.build_payload', function()
  it('英文を en から ja へ翻訳するペイロードにする', function()
    assert.are.same(
      { source = 'en', target = 'ja', text = 'hello' },
      request.build_payload('hello')
    )
  end)

  it('日本語を含む文を ja から en へ翻訳するペイロードにする', function()
    assert.are.same(
      { source = 'ja', target = 'en', text = 'ホットウーロンです' },
      request.build_payload('ホットウーロンです')
    )
  end)

  it('改行を含む原文をそのまま載せる', function()
    assert.are.equal('hello\nworld', request.build_payload('hello\nworld').text)
  end)
end)
