{%- set iprange = '.'.join(grains['host_ips'][0].split('.')[0:-1]) %}

{%- if grains['provider'] == 'libvirt' %}
{%- set virtual_host_interface = 'eth1' %}
{%- else %}
{%- set virtual_host_interface = 'eth0' %}
{%- endif %}
{%- if grains['provider'] == 'gcp' %}
{%- set virtual_host_mask = 32 %}
{%- else %}
{%- set virtual_host_mask = 24 %}
{%- endif %}

netweaver:
  virtual_addresses:
    {{ grains['virtual_host_ips'][0] }}: sapha1as
    {{ grains['virtual_host_ips'][1] }}: sapha1er
    {{ grains['virtual_host_ips'][2] }}: sapha1pas
    {{ grains['virtual_host_ips'][3] }}: sapha1aas
  sidadm_user:
    uid: 2001
    gid: 2002
  sid_adm_password: SuSE1234
  sap_adm_password: SuSE1234
  master_password: SuSE1234
  sapmnt_inst_media: {{ grains['netweaver_nfs_share'] }}
  swpm_folder: /netweaver_inst_media/SWPM_10_SP26_6
  sapexe_folder: /netweaver_inst_media/kernel_nw75_sar
  additional_dvds:
    - /netweaver_inst_media/51050829_3 # NW Export folder
    - /netweaver_inst_media/51053381 # HANA HDB Client folder

  # apply by default the netweaver solution
  saptune_solution: 'NETWEAVER'

  hana:
{%- if grains['provider'] == 'gcp' %}
    host: {{ grains['hana_cluster_vip'] }}
{%- else %}
    host: {{ iprange }}.200
{%- endif %}
    sid: PRD
    instance: '00'
    password: YourPassword1234

  schema:
    name: SAPABAP1
    password: SuSE1234

  product_id: NW750.HDB.ABAPHA

  nodes:
    - host: {{ grains['name_prefix'] }}01
      virtual_host: sapha1as
      virtual_host_interface: {{ virtual_host_interface }}
      virtual_host_mask: {{ virtual_host_mask }}
      sid: HA1
      instance: {{ grains['ascs_instance_number'] }}
      root_user: root
      root_password: linux
      {%- if grains['provider'] == 'libvirt' %}
      shared_disk_dev: /dev/vdb
      init_shared_disk: True
      {%- else %}
      shared_disk_dev: {{ grains['netweaver_nfs_share'] }}/ASCS
      {%- endif %}
      sap_instance: ascs

    - host: {{ grains['name_prefix'] }}02
      virtual_host: sapha1er
      virtual_host_interface: {{ virtual_host_interface }}
      virtual_host_mask: {{ virtual_host_mask }}
      sid: HA1
      instance: {{ grains['ers_instance_number'] }}
      root_user: root
      root_password: linux
      {%- if grains['provider'] == 'libvirt' %}
      shared_disk_dev: /dev/vdb
      {%- else %}
      shared_disk_dev: {{ grains['netweaver_nfs_share'] }}/ERS
      {%- endif %}
      sap_instance: ers

    - host: {{ grains['name_prefix'] }}03
      virtual_host: sapha1pas
      virtual_host_interface: {{ virtual_host_interface }}
      virtual_host_mask: {{ virtual_host_mask }}
      sid: HA1
      instance: '00' # Not used
      root_user: root
      root_password: linux
      sap_instance: db

    - host: {{ grains['name_prefix'] }}03
      virtual_host: sapha1pas
      virtual_host_interface: {{ virtual_host_interface }}
      virtual_host_mask: {{ virtual_host_mask }}
      ascs_virtual_host: sapha1as
      sid: HA1
      instance: {{ grains['pas_instance_number'] }}
      root_user: root
      root_password: linux
      sap_instance: pas

    - host: {{ grains['name_prefix'] }}04
      virtual_host: sapha1aas
      virtual_host_interface: {{ virtual_host_interface }}
      virtual_host_mask: {{ virtual_host_mask }}
      sid: HA1
      instance: {{ grains['aas_instance_number'] }}
      root_user: root
      root_password: linux
      sap_instance: aas
