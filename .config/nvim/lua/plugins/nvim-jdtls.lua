return {
  {
    'mfussenegger/nvim-jdtls',
    ft = { 'java' },
    config = function()
      local jdtls = require 'jdtls'

      local home = os.getenv 'HOME'
      local workspace_dir = home .. '/.local/share/eclipse/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

      local config = {
        cmd = {
          'jdtls',
          '-data',
          workspace_dir,
        },
        root_dir = require('jdtls.setup').find_root { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' },
        settings = {
          java = {
            signatureHelp = { enabled = true },
            contentProvider = { preferred = 'fernflower' },
            completion = {
              favoriteStaticMembers = {
                'org.hamcrest.MatcherAssert.assertThat',
                'org.hamcrest.Matchers.*',
                'org.hamcrest.CoreMatchers.*',
                'org.junit.jupiter.api.Assertions.*',
                'java.util.Objects.requireNonNull',
                'java.util.Objects.requireNonNullElse',
                'org.mockito.Mockito.*',
              },
            },
            sources = {
              organizeImports = {
                starThreshold = 9999,
                staticStarThreshold = 9999,
              },
            },
            codeGeneration = {
              toString = {
                template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
              },
            },
          },
        },
        init_options = {
          bundles = {},
        },
      }

      jdtls.start_or_attach(config)
    end,
  },
}
