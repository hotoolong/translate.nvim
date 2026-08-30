local request = require('translate.request')

describe('request.build_payload', function()
  it('builds an en to ja payload for English text', function()
    assert.are.same(
      { source = 'en', target = 'ja', text = 'hello' },
      request.build_payload('hello')
    )
  end)

  it('builds a ja to en payload for text containing Japanese', function()
    assert.are.same(
      { source = 'ja', target = 'en', text = 'ホットウーロンです' },
      request.build_payload('ホットウーロンです')
    )
  end)

  it('carries the source text through unchanged, newlines included', function()
    assert.are.equal('hello\nworld', request.build_payload('hello\nworld').text)
  end)
end)
