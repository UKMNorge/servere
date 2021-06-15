{% set ukm = pillar.get('ukm', {}) %}

include:
    - apache
    - ssl
    - composer
    - ukmlib.files
    - ukmlib.config
    - ukmlib.database
    - ukmlib.includes

ukmlib:
    pkg.installed:
        - pkgs:
            - git
            - php7.2-curl
            - unzip
    file.directory:
        - name: /etc/php-includes