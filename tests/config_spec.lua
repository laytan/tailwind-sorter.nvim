describe(
  'config', function()
    it(
      'returns the default config', function()
        local Config = require('tailwind-sorter.config')

        assert.truthy(Config:get().on_save_pattern)
      end
    )

    it(
      'can have configuration applied', function()
        local Config = require('tailwind-sorter.config')
        Config:apply({ test = 'test' })

        assert.equals(Config:get().test, 'test')
      end
    )

    it(
      'can override the default config with apply', function()
        local Config = require('tailwind-sorter.config')
        Config:apply({ on_save_pattern = { '*.html', '*.test' } })

        assert.same(Config:get().on_save_pattern, { '*.html', '*.test' })
      end
    )

    it(
      'can call apply with no arguments', function()
        local Config = require('tailwind-sorter.config')
        Config:apply()
        assert.truthy(Config:get().on_save_pattern)
      end
    )

    it(
      'can copy the config with an empty with call', function()
        local Config = require('tailwind-sorter.config')
        local Copy = Config:with()
        Config:apply({ test = 'config' })
        Copy:apply({ test = 'copy', testcopy = 'test' })

        assert.falsy(Config:get().testcopy)
        assert.equals(Config:get().test, 'config')
        assert.equals(Copy:get().test, 'copy')
      end
    )

    it(
      'can copy with overwrites', function()
        local Config = require('tailwind-sorter.config')
        local Copy = Config:with(
          { on_save_pattern = { '*.test' }, test = 'test' }
        )

        assert.same(Copy:get().on_save_pattern, { '*.test' })
        assert.equals(Copy:get().test, 'test')
      end
    )
  end
)
