{% set mysql = pillar.get('mysql') %}
{% set videoconverter = pillar.get('videoconverter', {}) %}

include:
    - apache
    - composer
    - ssl
    - mysql
    - ffmpeg
    - ukmlib.config
    - ukmbox-videoconverter.database
    - ukmbox-videoconverter.ukmlib-files

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
        - require:
            - pkg: videoconverter-deps

apache-headers:
    cmd.run:
        - name: a2enmod headers
        - unless: test -f /etc/apache2/mods-enabled/headers.load
        - require:
            - pkg: apache

videoconverter-cron-final:
    cron.present:
        - name: wget -O  - http://localhost/cron/convert_final.cron.php
        - minute: "*/2"
        - identifier: cron_final

{% for cron_target in ['convert_first', 'store'] %}
videoconverter-cron-{{ cron_target }}:
    cron.present:
        - name: wget -O - http://localhost/cron/{{ cron_target }}.cron.php
        - identifier: {{ cron_target }}
{% endfor %}


{% for dir in [
    'store_hq',
    'store_temp_convert',
    'store_temp_converting',
    'store_temp_converting_pqt',
    'store_temp_transfer',
    'store_temp_transferring',
    'temp_reconvert_originals',
    'temp_storage',
    'temp_videoserver_originals',
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
    'store',
    'uploaded',
    'x264',
    ] %}
videoconverter-temp-storage-dir-{{ dir }}:
    file.directory:
        - name: /var/www/videoconverter/temp_storage/{{ dir }}
        - mode: 775
{% endfor %}