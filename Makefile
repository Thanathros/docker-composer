LATEST_COMPOSER = 2.0.8
COMPOSER_BRANCHES = 1.9.3 1.10.19 2.0.8
PHP_VERSIONS = 7.2 7.3 7.4
REPO_NAME = "Thanathros/composer"

COMPOSER_INSTALLER_URL ?= https://raw.githubusercontent.com/composer/getcomposer.org/e3e43bde99447de1c13da5d1027545be81736b27/web/installer 
COMPOSER_INSTALLER_HASH ?= 756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3

.PHONY = all build test template

all: template build test tag

build:
	@for branch in $(COMPOSER_BRANCHES); do \
	    for php in $(PHP_VERSIONS); do \
	        dir=$$branch/php$$php; \
	        if [ $$branch = $(LATEST_COMPOSER) ]; then \
	            docker build --tag composer:$$branch-php$$php --tag composer:latest-php$$php $$dir; \
	        else \
	            docker build --tag composer:$$branch-php$$php $$dir; \
	        fi \
	    done \
	done \

test:
	@for branch in $(COMPOSER_BRANCHES); do \
	    for php in $(PHP_VERSIONS); do \
	        if [ $$branch = $(LATEST_COMPOSER) ]; then \
	            echo "Test latest Composer $$branch for PHP $$php"; \
	            docker run --rm --tty composer:latest-php$$php --no-ansi | grep "Composer version $$branch"; \
	        else \
	            echo "Test Composer $$branch for PHP $$php"; \
	            docker run --rm --tty composer:$$branch-php$$php --no-ansi | grep "Composer version $$branch"; \
	        fi \
	    done \
	done \

tag:
	@for branch in $(COMPOSER_BRANCHES); do \
	    for php in $(PHP_VERSIONS); do \
	        dir=$$branch/php$$php; \
	        if [ $$branch = $(LATEST_COMPOSER) ]; then \
	            docker tag composer:$$branch-php$$php $(REPO_NAME):$$branch-php$$php; \
	            docker push $(REPO_NAME):$$branch-php$$php; \
	            docker tag composer:latest-php$$php $(REPO_NAME):latest-php$$php; \
	            docker push $(REPO_NAME):latest-php$$php; \
	        else \
	            docker tag composer:$$branch-php$$php $(REPO_NAME):$$branch-php$$php; \
	            docker push $(REPO_NAME):$$branch-php$$php; \
	        fi \
	    done \
	done \

template:
	@for branch in $(COMPOSER_BRANCHES); do \
	    rm -R ./$$branch; \
	    for php in $(PHP_VERSIONS); do \
	        echo "Create Dockerfile for Composer $$branch with PHP $$php"; \
	        dir=$$branch/php$$php; \
	        mkdir -p $$dir; \
	        cp docker-entrypoint.sh $$dir; \
	        cp Dockerfile.template $$dir/Dockerfile; \
	        gsed -i --expression 's@%PHP_VERSION%@'$$php'@' \
	             --expression 's@%COMPOSER_VERSION%@'$$branch'@' \
               --expression 's@%COMPOSER_INSTALLER_URL%@$(COMPOSER_INSTALLER_URL)@' \
               --expression 's@%COMPOSER_INSTALLER_HASH%@$(COMPOSER_INSTALLER_HASH)@' \
               $$dir/Dockerfile; \
	    done \
	done \

clear:
	@for branch in $(COMPOSER_BRANCHES); do \
	    rm -R ./$$branch; \
	done \
