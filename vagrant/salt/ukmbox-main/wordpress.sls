{% set ukm = pillar.get('ukm') %}

# Chmod so it can run 
# (index files must be writable so UKMwp_dash-plugin can overwrite them)
wordpress-permissions:
    cmd.wait:
        - name: chown root:www-data -R /var/www/wordpress &&
                find /var/www/wordpress -type f ! -iname ".htaccess" ! -iname wp-config.php -print0 | xargs -0 chmod 664 &&
                find /var/www/wordpress -type d -print0 | xargs -0 chmod 775
        - watch:
            - cmd: wordpress-install

wordpress-index-chmod:
    file.managed:
    - name: /var/www/wordpress/wp-admin/index.php
    - mode: 777
    - replace: False
    - watch:
        - cmd: wordpress-install

wordpress-admin-index-chmod:
  file.managed:
    - name: /var/www/wordpress/wp-admin/network/index.php
    - mode: 777
    - replace: False
    - watch:
        - cmd: wordpress-install

# Add htaccess file
wordpress-htaccess:
    file.managed:
        - name: /var/www/wordpress/.htaccess
        - source: salt://ukmbox-main/files/wordpress-htaccess
        - template: jinja
        - mode: 640
        - user: www-data
        - group: www-data
        - require:
            - cmd: wordpress-install

# Add config file
wordpress-config:
    file.managed:
        - name: /var/www/wordpress/wp-config.php
        - source: salt://wordpress/files/wp-config.php.j2
        - template: jinja
        - defaults:
            database_name: {{ ukm.database.wp.name }}
            database_user: {{ ukm.database.wp.users.user_write.name }}
            database_pass: '{{ ukm.database.wp.users.user_write.pass }}'
            database_host: '{{ ukm.database.host }}'
            database_table_prefix: wpms2012_
            current_site_domain: {{ ukm.hostname }}
            current_site_path: /
            current_site_id: 1
            current_site_blog_id: 1
        - mode: 640
        - user: www-data
        - group: www-data

# Add existing uploads (from datapackage)
wordpress-uploads:
    file.managed:
        - name: /usr/local/src/uploads.tar.gz
        - source: salt://ukmbox-main/files/uploads.tar.gz
    cmd.wait:
        - name: tar xf /usr/local/src/uploads.tar.gz -C /var/www/wordpress/wp-content --no-same-permissions --no-same-owner
        - watch:
            - file: wordpress-uploads

wordpress-uploads-mode:
    file.directory: 
        - name: /var/www/wordpress/wp-content/uploads/
        - mode: 777
        - require:
            - wordpress-uploads

# ADD THEME (UKMDESIGN)
ukmdesignwordpress-git:
    git.latest:
        - name: https://github.com/UKMNorge/UKMDesignWordpress.git
        - target: /var/www/wordpress/wp-content/themes/UKMDesignWordpress
        - require:
            - wordpress-install

ukmdesignwordpress-composer:
    cmd.run:
        - name: composer install
        - cwd: /var/www/wordpress/wp-content/themes/UKMDesignWordpress
        - require:
            - install-composer
            - ukmdesignwordpress-git