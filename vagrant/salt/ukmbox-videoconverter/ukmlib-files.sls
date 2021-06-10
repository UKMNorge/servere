https://github.com/UKMNorge/UKMapi.git:
    git.latest:
        - target: /etc/php-includes/UKM
        
/etc/php-includes/UKM:
    composer.installed:
        - no_dev: false
        - require:
            - cmd: install-composer
            - git: https://github.com/UKMNorge/UKMapi.git