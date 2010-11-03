VERSION = `git tag | sort -r| head -n1`

zip:
	git archive --format=zip HEAD plugin/* doc/* > /tmp/vim-refact-$(VERSION).zip
install:
	cp -v plugin/* ~/.vim/plugin/
	cp -v doc/* ~/.vim/doc/
