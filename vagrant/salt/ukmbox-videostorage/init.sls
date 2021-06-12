{% set mysql = pillar.get('mysql') %}
{% set videoconverter = pillar.get('videoconverter', {}) %}

include:
    - apache
    - composer
    - ssl
    - ukmlib.config
    - ukmlib.files

box-videostorage-vhost:
    file.managed:
        - name: /etc/apache2/sites-enabled/videostorage.dev.conf
        - source: salt://apache/files/vhost.conf
        - template: jinja
        - defaults:
            hostname: videostorage.ukm.dev
            document_root: videostorage/
        - require:
            - pkg: apache
        - watch_in:
            - service: apache

videoconverter-deps:
    pkg.installed:
        - pkgs:
            - git
            - php7.2-curl

https://github.com/UKMNorge/videostorage.git:
    git.latest:
        - name: https://github.com/UKMNorge/videostorage.git
        - target: /var/www/videostorage