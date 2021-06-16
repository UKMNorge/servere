{% set mysql = pillar.get('mysql') %}
{% set videoconverter = pillar.get('videoconverter', {}) %}

include:
    - apache
    - composer
    - ssl
    - mysql
    - ffmpeg
    - ukmlib.config
    - ukmlib.files
    - ukmbox-videoconverter.database

box-videoconverter-www-folder:
    file.directory:
        - name: /var/www/videoconverter

box-videconverter-vhost:
    file.managed:
        - name: /etc/apache2/sites-enabled/videoconverter.dev.conf
        - source: salt://apache/files/vhost.conf
        - template: jinja
        - defaults:
            hostname: videoconverter.ukm.dev
            document_root: videoconverter/
        - require:
            - pkg: apache
        - watch_in:
            - service: apache

videoconverter-deps:
    pkg.installed:
        - pkgs:
            - git
            - php7.2-curl
            #- libav-tools # Contains qt-faststart # libav-tools is obsolete, and replaced by ffmpeg proper

videoconverter:
    git.latest:
        - name: https://github.com/UKMNorge/videoconverter.git
        - target: /var/www/videoconverter
        - force_clone: true
        - require:
            - pkg: videoconverter-deps

apache-headers:
    cmd.run:
        - name: a2enmod headers
        - unless: test -f /etc/apache2/mods-enabled/headers.load
        - require:
            - pkg: apache

{% for cron_target in ['convert_first','convert_second','convert_archive', 'store', 'archive'] %}
videoconverter-cron-{{ cron_target }}:
    cron.present:
        - name: wget -O - http://localhost/cron/{{ cron_target }}.cron.php
        - identifier: {{ cron_target }}
{% endfor %}


{% for dir in [
    'temp_storage',
    'log'
    ] %}
videoconverter-dir-{{ dir }}:
    file.directory:
        - name: /var/www/videoconverter/{{ dir }}
        - mode: 775
{% endfor %}


{% for dir in [
    'convert',
    'converted',
    'log',
    'inbox',
    'store',
    'uploaded',
    'x264',
    ] %}
videoconverter-temp-storage-dir-{{ dir }}:
    file.directory:
        - name: /var/www/videoconverter/temp_storage/{{ dir }}
        - mode: 775
{% endfor %}