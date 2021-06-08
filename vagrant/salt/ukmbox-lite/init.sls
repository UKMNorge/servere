box-lite-www-folder:
    file.directory:
        - name: /var/www/lite/

box-lite-vhost:
    file.managed:
        - name: /etc/apache2/sites-enabled/lite.ukm.dev.conf
        - source: salt://apache/files/vhost.conf
        - template: jinja
        - defaults:
            hostname: lite.ukm.dev
            document_root: lite/
        - require:
            - pkg: apache
            - ssl-key-ukm-dev
            - box-lite-www-folder
        - watch_in:
            - service: apache

box_tempdev_vhost:
    file.managed:
        - name: /etc/apache2/sites-enabled/ukm.dev.conf
        - source: salt://apache/files/vhost.conf
        - template: jinja
        - defaults:
            hostname: ukm.dev
            document_root: wordpress/
        - require:
            - pkg: apache
            - ssl-key-ukm-dev
        - watch_in:
            - service: apache

ukmdesign_git_lite:
    git.latest:
        - name: https://github.com/UKMNorge/UKMDesign.git
        - target: /var/www/wordpress/wp-content/themes/UKMDesign
