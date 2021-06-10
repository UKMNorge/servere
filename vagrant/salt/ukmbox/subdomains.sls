{% set subdomains = pillar.get('subdomains', {}) %}

{% for subdomain in subdomains %}
{% set config = subdomains[subdomain] %}
ukm-subdomain-{{subdomain}}:
    file.directory:
         - name: /var/www/{{subdomain}}/

{% if config.github is defined and config.github %}
ukm-subdomain-{{subdomain}}-git:
    git.latest:
        - name: {{config.github}}
        - target: /var/www/{{subdomain}}
        - require:
            - pkg: ukmlib
            - ukm-subdomain-{{subdomain}}
{% endif %}

{% if config.parameters is defined and config.parameters %}
ukm-subdomain-{{subdomain}}-parameters:
    file.managed:
        - name: {{ config.parameters.target }}
        - source: {{ config.parameters.source }}
        - mode: 640
        - user: root
        - group: www-data
        - template: jinja
        - require:
            - ukm-subdomain-{{subdomain}}-git
{% endif %}

{% if config.composer is defined and config.composer %}
ukm-subdomain-{{subdomain}}-composer:
    composer.installed:
        - no_dev: false
        - name: /var/www/{{subdomain}}/
        - require:
            - git: ukm-subdomain-{{subdomain}}-git
            - cmd: install-composer
            {% if config.parameters is defined and config.parameters %}- ukm-subdomain-{{subdomain}}-parameters{% endif %}
{% endif %}

{% if config.composer1 is defined and config.composer1 %}
ukm-subdomain-{{subdomain}}-composer1:
    cmd.run:
        - name: composer1 install --no-plugins
        - cwd: /var/www/{{subdomain}}
        - require:
            - ukm-subdomain-{{subdomain}}-git
            - composer1
            {% if config.parameters is defined and config.parameters %}- ukm-subdomain-{{subdomain}}-parameters{% endif %}
{% endif %}

ukm-subdomain-{{subdomain}}-vhost:
    file.managed:
        - name: /etc/apache2/sites-enabled/{{subdomain}}.conf
        - source: salt://apache/files/vhost-subdomain.conf
        - template: jinja
        - defaults:
          subdomain: {{subdomain}}
          {% if config.document_root is defined %}document_root: {{config.document_root}}{% endif %}
        - watch_in:
            - service: apache
        - require:
            - ssl-key-ukm-dev
            - ukm-subdomain-{{subdomain}}{% if config.github is defined and config.github %}-git{% endif %}
{% endfor %}