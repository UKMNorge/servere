{% set mysql = pillar.get('mysql') %}
{% set ukm = pillar.get('ukm') %}

## CREATE DATABASES
ukm-database-wp:
    mysql_database.present:
        - name: {{ ukm.database.wp.name }}
        - host: localhost
        - connection_pass: {{ mysql.root_pass }}
        - require:
            - pkg: ukmlib
            - service: mysql-server

    file.managed:
        - name: /etc/mysql/ukmdev_dev_wp.sql
        - source: salt://ukmlib/files/ukmdev_dev_wp.sql
        - require:
            - pkg: mysql-server

    cmd.wait:
        - name: mysql -u root -p{{ mysql.root_pass }} {{ ukm.database.wp.name }} < /etc/mysql/ukmdev_dev_wp.sql
        - require:
            - mysql_database: ukm-database-wp
        - watch:
            - file: ukm-database-wp

ukm-database-ss3:
    mysql_database.present:
        - name: {{ ukm.database.ss3.name }}
        - host: localhost
        - connection_pass: {{ mysql.root_pass }}
        - require:
            - pkg: ukmlib
            - service: mysql-server

    file.managed:
        - name: /etc/mysql/ukmdev_dev_ss3.sql
        - source: salt://ukmlib/files/ukmdev_dev_ss3.sql
        - require:
            - pkg: mysql-server

    cmd.wait:
        - name: mysql -u root -p{{ mysql.root_pass }} {{ ukm.database.ss3.name }} < /etc/mysql/ukmdev_dev_ss3.sql
        - require:
            - mysql_database: ukm-database-ss3
        - watch:
            - file: ukm-database-ss3

ukm-database-id:
    mysql_database.present:
        - name: {{ ukm.database.id.name }}
        - host: localhost
        - connection_pass: {{ mysql.root_pass }}
        - require:
            - pkg: ukmlib
            - service: mysql-server

    file.managed:
        - name: /etc/mysql/ukmdev_dev_id.sql
        - source: salt://ukmlib/files/ukmdev_dev_id.sql
        - require:
            - pkg: mysql-server

    cmd.wait:
        - name: mysql -u root -p{{ mysql.root_pass }} {{ ukm.database.id.name }} < /etc/mysql/ukmdev_dev_id.sql
        - require:
            - mysql_database: ukm-database-id
        - watch:
            - file: ukm-database-id

ukm-database-husk:
    mysql_database.present:
        - name: {{ ukm.database.husk.name }}
        - host: localhost
        - connection_pass: {{ mysql.root_pass }}
        - require:
            - pkg: ukmlib
            - service: mysql-server

{% for database_key in ukm.database if database_key != 'host' %}
    {% set database = ukm.database[ database_key ] %}
    {% for user_key in database.users %}
        {% set user = database.users[ user_key ] %}
## CREATE DATABASE USERS
mysql-{{ database_key }}-user-{{ user_key }}:
    mysql_user.present:
        - name: {{ user.name }}
        - host: localhost
        - password: "{{ user.pass }}"
        - connection_pass: "root"
        - connection_pass: "{{ mysql.root_pass }}"

## GRANT USER PRIVILEGES
mysql-{{ database_key }}-grant-{{ user_key  }}:
    mysql_grants.present:
        - user: {{ user.name }}
        - grant: {{ user.grant }}
        - database: '`{{ database.name }}`.*'
        - escape: False
        - host: localhost
        - connection_pass: "root"
        - connection_pass: "{{ mysql.root_pass }}"
        - require:
            - mysql-{{ database_key }}-user-{{ user_key }}
            {% if database_key != 'delta' %}
            - mysql_database: ukm-database-{{ database_key }}
            {% endif %}
{% endfor %}
{% endfor %}