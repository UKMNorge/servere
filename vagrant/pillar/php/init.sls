{% if 'videoconverter' in grains['roles'] %}
php:
    upload_max_filesize: 2000M
    post_max_size: 2000M
    opcache: false
{% elif 'videostorage' in grains['roles'] %}
php:
    upload_max_filesize: 2000M
    post_max_size: 2000M
    opcache: false
{% elif 'cache' in grains['roles'] %}
php:
    upload_max_filesize: 2000M
    post_max_size: 2000M
    opcache: false
{% else %}
php:
    upload_max_filesize: 80M
    post_max_size: 80M
    opcache: false
{% endif %}
