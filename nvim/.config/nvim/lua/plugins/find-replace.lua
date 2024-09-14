return {
  {
    'MagicDuck/grug-far.nvim',
    config = function()
      require('grug-far').setup({
        engine = "ripgrep",
        engines = {
          rg = {
            extraArgs = "--hidden"
          }
        }
      });
    end
  },
}
