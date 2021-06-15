{% set ukmwordpress = pillar.get('ukmwordpress', {}) %}

## ADD GITHUB PLUGINS
{% if ukmwordpress.plugins is defined %}
    {% for repo in ukmwordpress.plugins %}
https://github.com/UKMNorge/{{ repo }}.git:
    git.latest:
        - target: /var/www/wordpress/wp-content/plugins/{{ repo }}
        - require:
            - wordpress-install
    {% endfor %}
{% endif %}

## ADD NON-GITHUB PLUGINS
ukm-wordpress-plugins:
    file.managed:
        - name: /usr/local/src/plugins.tar.gz
        - source: salt://ukmbox-main/files/plugins.tar.gz
    
    cmd.wait:
        - name: tar xf /usr/local/src/plugins.tar.gz -C /var/www/wordpress/wp-content/plugins --strip 1 --no-same-permissions --no-same-owner
        - watch:
            - file: ukm-wordpress-plugins

include:
    - ukmbox-main.plugins.cache