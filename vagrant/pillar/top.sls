base:
    '*':
        - java
        - mysql
        - ssl
        - ukmtv

    'phpweb':
        - php
        - composer

    'roles:lite':
        - match: grain
        - ukm

    'roles:main':
        - match: grain
        - ukm
        - wordpress
        - ukmtv
    
    'roles:playback':
        - match: grain
        - ukm

    'roles:videoconverter':
        - match: grain
        - ukm
        - ukmtv
        - php

    'roles:videostorage':
        - match: grain
        - ukm
        - ukmtv
        - php
        
    'vagrant':
        - samba