{% from 'states/jenkins/map.jinja' import jenkins as jenkins_map with context %}

jenkins:
  pkg.installed:
    - name: {{ jenkins_map.package }}

  service.running:
    - name: {{ jenkins_map.service }}
    - enable: true
    - require:
      - pkg: jenkins
