{% from "base/map.jinja" import base with context %}
{% set repo = salt['pillar.get']('plone:repo') %}
{% set project_dir = salt['pillar.get']('plone:project_dir') %}

include:
  - .user
  - .config

plone-buildout-repo:
  git.latest:
    - name: {{ repo }}
    - branch: daterecurringindex
    - user: zope
    - target: {{ project_dir }}
    - require:
      - user: zope-user
      - file: {{ project_dir }}

buildout-config:
  file.copy:
    - name: {{ project_dir }}/buildout.cfg
    - source: {{ project_dir }}/profiles/buildout.cfg.tmpl
    - user: zope
    - group: zope
    - require:
      - git: plone-buildout-repo

{{ project_dir }}/env:
  virtualenv.managed:
    - python: python3
    - requirements: {{ project_dir }}/requirements.txt
    - require:
      - sls: base
      - git: plone-buildout-repo

plone-log-file:
  file.managed:
    - name: {{ project_dir }}/var/log/instance.log
    - user: zope
    - group: zope
    - require:
      - plone-buildout
