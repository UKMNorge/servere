base:
    '*':
        - networking
        - security
        - ssl
        - vim
        - swap
        - timezone

    'vagrant':
        - samba

    'roles:phpweb':
        - match: grain
        - apache
        - composer
    
    'roles:database':
        - match: grain
        - mysql

    'roles:ukmbox':
        - match: grain
        - ukmbox

    'roles:lite':
        - match: grain
        - ukmlib
        - ukmbox-lite

    'roles:main':
        - match: grain
        - ukmlib
        - wordpress
        - ukmbox-main
        - nodejs
    
    'roles:playback':
        - match: grain
        - ukmlib.config
        - ukmbox-playback
   
    'roles:videoconverter':
        - match: grain
        - apache
        - composer
        - ffmpeg
        - ukmbox-videoconverter

    'roles:videostorage':
        - match: grain
        - videostorage

    'roles:videocache':
        - match: grain
        - wowza