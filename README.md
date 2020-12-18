# Composer Docker with PHP

This is used to run latest and previous Version of Composer with different PHP Versions.
Script has been modified to be used on MacOSX. See `Notes` at the end of README.md

## Tags

| Composer | PHP 7.2 | PHP 7.3 | PHP 7.4 |
|----------|------------------------|------------------------|------------------------|
| latest (2.0.8) | thanathros/composer:latest-php7.2 | thanathros/composer:latest-php7.3 | thanathros/composer:latest-php7.4 |
| 2.0.8 | thanathros/composer:2.0.8-php7.2 | thanathros/composer:2.0.8-php7.3 | thanathros/composer:2.0.8-php7.4 |
| 1.10.19 | thanathros/composer:1.10.19-php7.2 | thanathros/composer:1.10.19-php7.3 | thanathros/composer:1.10.19-php7.4 |
| 1.9.3 | thanathros/composer:1.9.3-php7.2 | thanathros/composer:1.9.3-php7.3 | thanathros/composer:1.9.3-php7.4 |

## How to Update

To update the repository you easily change the Makefile on top of the file.

### Change the latest Version

To Change the latest Version of Composer change the value of "LATEST_COMPOSER" and add the new Version
at the end to "COMPOSER_BRANCHES". After any change of a Version (Composer or PHP) don't forgot to
run "make all".

#### Example

Old Version
```
# Example
LATEST_COMPOSER = 1.9.0
COMPOSER_BRANCHES = 1.8.6 1.9.0
...
```
New Version
```
LATEST_COMPOSER = 1.9.1
COMPOSER_BRANCHES = 1.8.6 1.9.0 1.9.1
...
```

### Remove old Version

If there is a Version of Composer which is older then the time self, remove if from "COMPOSER_BRANCHES".

### Add or Remove a PHP Version

Yes, PHP Versions getting end of life, so we have to remove some of them time by time. To do this, remove or add the PHP Version
in Makefile variable "PHP_VERSIONS". 

```
...
PHP_VERSIONS = 7.1 7.2 7.3

COMPOSER_INSTALLER_URL ?= https://raw.github...
...
```

## Use Make / Makefile

| Command | Description |
|---------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| make all | Runs all steps in Makefile in the order "template", "build" and "test" |
| make template | Removes all directories which created by Composer include subdirectories and recreated all needed Dockerfiles new. If you remove a Composer Version, you may have to delete the comparing Directory manually.  |
| make build | Runs docker build for every Composer Version with all PHP Versions to build the Docker Images |
| make test | Test all created Docker-Images by running the Docker Image created before |

## Notes
| Short Note | Meaning / Description |  
|------------|-----------------------|
| gsed instead of sed | sed on MacOSX is not GNU-compliant. Therefore make all fails on usage. To circumvent this issue, you have to install gsed; it's available with `brew install gsed` for MacOSX users. Alternatively create a symlink from sed to gsed: `cd /bin && ln -s sed gesd`. |  

## Sources

More Information of Composer can be find of [Composer Website](https://getcomposer.org)  
Based on [Composer Docker](https://github.com/composer/docker)
