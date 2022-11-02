{% set robot_versions = {
  'robot-1': '1.0.0',
  'robot-2': '1.0.1',
}
%}

robot_version: {{ robot_versions.get(grains.id, '9.0.0') }}
robot_id: {{ grains.id }}
