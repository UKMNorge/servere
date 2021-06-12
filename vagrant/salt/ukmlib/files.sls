## PHP LIBRARIES
ukmlib-includes-deps:
    file.directory:
        - name: /etc/php-libraries
        - user: root
        - group: www-data
        - mode: 755
            
## PHP INCLUDES
https://github.com/UKMNorge/UKMapi.git:
    git.latest:
        - target: /etc/php-includes/UKM
        - require:
            - ukmlib-includes-deps

/etc/php-includes/UKM:
    composer.installed:
        - no_dev: false
        - require:
            - cmd: install-composer
            - git: https://github.com/UKMNorge/UKMapi.git