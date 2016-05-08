HUGO:=$(shell which hugo)

# https://github.com/digitalcraftsman/hugo-material-docs
THEME_AUTHOR=digitalcraftsman
THEME=hugo-material-docs

.PHONY: help build clean watch

help:
	@awk 'BEGIN {FS = ":.*?## "} /^[\$$\(\)a-zA-Z_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build: themes/$(THEME) ## Build there

themes/$(THEME):
	git clone https://github.com/$(THEME_AUTHOR)/$(THEME) themes/$(THEME)
	rm -rf themes/$(THEME)/.git

clean: ## Clean build artifacts
	rm -rf themes/$(THEME)

watch: ## Watch filesystem for changes and recreate as needed
	-$(HUGO) server --buildDrafts --theme=$(THEME)
