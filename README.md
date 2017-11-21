# Development Base PHP Docker Image

This repository serves as base for PHP image.

## Getting Started

### Prerequisites

```
Docker
Patience
```

### Building

1. Install Docker
2. Start PowerShell and go inside this project's root directory
3. Run `docker build . -t php:<php_version> --no-cache` in current directory

## Running the tests

This repository contains `test.php`, which runs testing automatically on build. 
This tests whether all dependencies were installed and whether is composer initialized or not.

## Built With

* [PHP 7.1.11-alpine](https://github.com/docker-library/php/blob/903540ea7918b5cabed6b32e81f8518f9e6f204f/7.1.11/alpine/Dockerfile) - PHP 7.1.11 alpine image
* [RedisPHP 3.1.2](https://github.com/phpredis/phpredis/tree/3.1.2) - Redis extension for PHP
* [Composer](https://getcomposer.org/) - Latest composer package manager
* [PCNTL](http://php.net/manual/en/book.pcntl.php) - Process control extension for PHP

## Contributing

Please contact [Adrián Paníček](mailto:adrian@panicek.sk) for contribution on this project

## Versioning

I use Semantic Versioning without meta tags. Versioning format **major.minor.hotfix**.

Sample versioning: **3.1.0**

Major version changes are NOT backward compatible ! 
Minor version changes are backward compatible within the same Major Version

## Changelog

0.0.1 - Basic initialization of project