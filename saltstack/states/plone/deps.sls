{% from "plone/map.jinja" import plone with context %}

plone-deps:
  pkg.installed:
    - pkgs:
{% if grains['os_family'] == 'FreeBSD' %}
      - wv
{% endif %}
      - lynx
      - poppler-utils
      - {{ plone.deps.freetype }}
      - {{ plone.deps.png }}
      - {{ plone.deps.jpeg }}
      - {{ plone.deps.tiff }}
      - {{ plone.deps.ffi }}
