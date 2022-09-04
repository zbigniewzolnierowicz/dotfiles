.PHONY : astro neovim zsh asdf
install : astro neovim zsh asdf

clean : astro-delete neovim-delete zsh-delete asdf-delete

astro :
	zsh ./deps/install_astronvim.zsh

neovim :
	stow -S neovim

zsh :
	stow -S zsh

astro-delete :
	rm -rf "${HOME}/.config/nvim"

neovim-delete :
	-stow -D neovim 2> /dev/null

zsh-delete :
	-stow -D zsh 2> /dev/null

asdf :
	zsh ./deps/install_asdf.zsh

asdf-delete :
	rm -rf "${HOME}/.asdf"
