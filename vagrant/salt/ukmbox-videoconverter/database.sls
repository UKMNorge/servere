{% set mysql = pillar.get('mysql') %}
{% set videoconverter = pillar.get('videoconverter') %}

## CREATE DATABASES
ukm-database-videoconverter:
    mysql_database.present:
        - name: {{ videoconverter.database.name }}
        - host: localhost
        - connection_pass: {{ mysql.root_pass }}
        - require:
            - service: mysql-server

    file.managed:
        - name: /etc/mysql/ukmdev_videoconverter.sql
        - source: salt://ukmbox-videoconverter/files/ukmdev_videoconverter.sql
        - require:
            - pkg: mysql-server

    cmd.wait:
        - name: mysql -u root -p{{ mysql.root_pass }} {{ videoconverter.database.name }} < /etc/mysql/ukmdev_videoconverter.sql
        - require:
            - mysql_database: ukm-database-videoconverter
        - watch:
            - file: ukm-database-videoconverter

## CREATE DATABASE USERS
mysql-videoconverter-user:
    mysql_user.present:
        - name: {{ videoconverter.database.user }}
        - host: localhost
        - password: "{{ videoconverter.database.pass }}"
        - connection_pass: "root"
        - connection_pass: "{{ mysql.root_pass }}"

## GRANT USER PRIVILEGES
mysql-videoconverter-grant-user:
    mysql_grants.present:
        - user: {{ videoconverter.database.user }}
        - grant: 'all privileges'
        - database: '`{{ videoconverter.database.name }}`.*'
        - escape: False
        - host: localhost
        - connection_pass: "root"
        - connection_pass: "{{ mysql.root_pass }}"
        - require:
            - mysql-videoconverter-user