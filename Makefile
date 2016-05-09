HUGO:=$(shell which hugo)
HUGO_VERSION=0.15

# https://github.com/digitalcraftsman/hugo-material-docs
THEME_AUTHOR=digitalcraftsman
THEME=hugo-material-docs

GIT_REMOTE=origin
CURRENT_BRANCH=$(shell git branch | sed -n -e 's/^\* \(.*\)/\1/p')
DEPLOY_BRANCH=gh-pages


.PHONY: help build clean watch

help:
	@awk 'BEGIN {FS = ":.*?## "} /^[\$$\(\)a-zA-Z_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build: themes/$(THEME) ## Build there
	$(HUGO) --theme=$(THEME)

themes/$(THEME):
	git clone https://github.com/$(THEME_AUTHOR)/$(THEME) themes/$(THEME)
	rm -rf themes/$(THEME)/.git

clean: ## Clean build artifacts
	rm -rf themes/$(THEME)

watch: ## Watch filesystem for changes and recreate as needed
	-$(HUGO) server --buildDrafts --theme=$(THEME)

deploy: ## Deploy to site
	git checkout -B $(DEPLOY_BRANCH)
	git reset --hard $(CURRENT_BRANCH)
	git add -f public
	git commit -m "site generation"
	#git push $(GIT_REMOTE) $$(git subtree split --prefix public/ $(GIT_REMOTE)):$(DEPLOY_BRANCH) --force
	-git push $(GIT_REMOTE) :$(DEPLOY_BRANCH)
	git subtree push --prefix public $(GIT_REMOTE) $(DEPLOY_BRANCH)
