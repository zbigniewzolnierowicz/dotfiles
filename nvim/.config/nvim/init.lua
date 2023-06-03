-- Proudly stolen from Mark McDonnell
-- https://github.com/Integralist/nvim

-- Set up leader
vim.g.mapleader = " "

-- Set up tab width
vim.o.expandtab = true
vim.o.shiftwidth = 4

-- Set up line numbers
vim.o.number = true
vim.o.relativenumber = true

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- set GUI font
vim.opt.guifont = { "PragmataPro Liga", ":h16" }

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")
require("mappings")