{% set project_dir = salt['pillar.get']('plone:project_dir') %}

include:
  - .code

plone-buildout:
  cmd.run:
    - name: {{ project_dir }}/env/bin/buildout -N
    - cwd: {{ project_dir }}
    - runas: zope
    - require:
      - file: buildout-config

plone-buildout2:
  cmd.run:
    - name: {{ project_dir }}/env/bin/buildout
    - cwd: {{ project_dir }}
    - runas: zope
    - require:
      - plone-buildout

supervisorctl-reread:
  cmd.run:
    - name: /usr/bin/supervisorctl reread
    - runas: root
    - require:
        - plone-buildout2

supervisorctl-update:
  cmd.run:
    - name: /usr/bin/supervisorctl update
    - runas: root
    - require:
        - supervisorctl-reread
