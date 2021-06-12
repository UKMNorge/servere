{% if grains['host'] %}
hostname:
    cmd.run:
        - name: hostname {{ grains['host'] }}
{% endif %}

{#
videoconverter-host:
    host.present:
        - ip: 10.0.10.11
        - name: videoconverter.ukm.dev

ukmno-host:
    host.present:
        - ip: 10.0.10.10
        - names:
            - ukm.dev
            - api.ukm.dev
            - tv.ukm.dev
            - embed.ukm.dev
            - caches.tv.ukm.dev
            - delta.ukm.dev
            - rsvp.ukm.dev

wowza-host:
    host.present:
        - ip: 10.0.10.12
        - name: video.ukm.dev

cache-host:
    host.present:
        - ip: 10.0.10.13
        - name: cache.ukm.dev
#}