{% if 'lite' in grains['roles'] %}
include:
    - ukm.subdomains.lite
{% elif 'main' in grains['roles'] %}
include:
    - ukm.subdomains.main
    - ukm.wordpress
    - ukm.husk
{% elif 'videoconverter' in grains['roles'] %}
include:
    - ukm.subdomains.videoconverter
{% endif %}

ukm:
    hostname: ukm.dev
    genericsalt: thisisthegenericsalt
    mail:
        host: mail.support.ukm.no
        user: post@support.ukm.no
        pass: dev
        port: 25
        from:
            address: post@support.ukm.no
            name: UKM Norge support
        reply: support@ukm.no
    delta:
        slett_bruker_info:
            pass: slettBrukerDev
    database:
        host: 127.0.0.1
        ss3:
            name: ukmdev_dev_ss3
            users:
                user_read:
                    name: ukmdev_devread
                    pass: devonly
                    grant: 'all privileges'
                user_write:
                    name: ukmdev_devwrite
                    pass: devonly
                    grant: 'all privileges'
        wp:
            name: ukmdev_dev_wp
            users:
                user_read:
                    name: ukmdev_devread
                    pass: devonly
                    grant: 'all privileges'
                user_write:
                    name: ukmdev_devwrite
                    pass: devonly
                    grant: 'all privileges'
        delta:
            name: ukmdelta_db
            users:
                user_read:
                    name: ukmdev_devread
                    pass: devonly
                    grant: 'all privileges'
                user_write:
                    name: ukmdev_devwrite
                    pass: devonly
                    grant: 'all privileges'
        id:
            name: ukmdev_dev_id
            users: 
                user_read:
                    name: ukmdev_devread
                    pass: devonly
                    grant: 'all privileges'
                user_write:
                    name: ukmdev_devwrite
                    pass: devonly
                    grant: 'all privileges'
        husk:
            name: ukmhusk_db
            users:
                user_husk:
                    name: ukmhusk_user
                    pass: devonly
                    grant: 'all privileges'

                
    bilder:
        sync_folder: /home/ukmno/private_sync/
    apis:
        cloudflare:
            auth_key: dummyauthkey
            email: dummyemail
            zone: dummyzone
            url: https://api.cloudflare.com/client/v4/zones/
        dropbox:
            app:
                id: dummyappid
                name: UKMdigark/v1.0
                secret: dummysecret
                endpoint: https://ukm.dev/wp-content/plugins/UKMsystem_tools/dropbox.php
            user:
                token: dummytoken
        facebook:
            app:
                id: Facebook-App-ID-dev
                secret: Facebook-App-secret-dev
        flickr:
            app:
                key: dummyapikey
                secret: dummysecret
                endpoint: https://ukm.dev/wp-content/plugins/UKMsystem_tools/endpoint/flickr.php
            user:
                id: dummyuserid
                token: dummyusertoken
                secret: dummyussersecret
        google:
            key: google api key
        instagram:
            client:
                id: dummyclientid
                secret: dummyclientsecret
                auth_redirect: dummyauthredirect
        livestream:
            email: kontoer@ukm.no
        mailchimp:
            key: dummykey
            lists:
                arrangor: dummylistid
        slack:
            client:
                id: dummyid
                secret: dummysecret
                signing_secret: dummysigningsecret
                shareable_url: dummyshareableurl
            teams:
                ukmnorge: 'teamIdNorge'
                ukmmedia: 'teamIdMedia'
        sveve:
            account: 'ukm'
        trello:
            app:
                key: dummyapikey
                token: dummyapitoken
            boards:
                innkjop: dummyinnkjopid
            custom_fields:
                leveres: dummyleveresid