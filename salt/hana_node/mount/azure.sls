hana_lvm_pvcreate_lun0_azure:
  lvm.pv_present:
    - name: /dev/disk/azure/scsi1/lun0
hana_lvm_pvcreate_lun1_azure:
  lvm.pv_present:
    - name: /dev/disk/azure/scsi1/lun1
hana_lvm_pvcreate_lun2_azure:
  lvm.pv_present:
    - name: /dev/disk/azure/scsi1/lun2

# TODO: Allow VG creation wih more disks
hana_lvm_vgcreate_lun0_azure:
  lvm.vg_present:
    - name: vg_hana_data
    - devices: /dev/disk/azure/scsi1/lun0
hana_lvm_vgcreate_lun1_azure:
  lvm.vg_present:
    - name: vg_hana_log
    - devices: /dev/disk/azure/scsi1/lun1
hana_lvm_vgcreate_lun2_azure:
  lvm.vg_present:
    - name: vg_hana_shared
    - devices: /dev/disk/azure/scsi1/lun2


hana_data_lvm_lvcreate_azure:
  lvm.lv_present:
    - name: hana_data
    - vgname: vg_hana_data
    - extents: 100%FREE
hana_log_lvm_lvcreate_azure:
  lvm.lv_present:
    - name: hana_log
    - vgname: vg_hana_log
    - extents: 100%FREE
hana_shared_lvm_lvcreate_azure:
  lvm.lv_present:
    - name: hana_shared
    - vgname: vg_hana_shared
    - extents: 100%FREE

hana_format_lv_azure:
  cmd.run:
    - name: |
        /sbin/mkfs -t {{ grains['hana_fstype'] }} /dev/vg_hana_data/hana_data && \
        /sbin/mkfs -t {{ grains['hana_fstype'] }} /dev/vg_hana_log/hana_log && \
        /sbin/mkfs -t {{ grains['hana_fstype'] }} /dev/vg_hana_shared/hana_shared

hana_data_directory_mount_azure:
  file.directory:
    - name: /hana/data
    - user: root
    - mode: "0755"
    - makedirs: True
  mount.mounted:
    - name: /hana/data
    - device: /dev/vg_hana_data/hana_data
    - fstype: {{ grains['hana_fstype'] }}
    - mkmnt: True
    - persist: True
    - opts: defaults,nofail
    - pass_num: 2
    - require:
      - cmd: hana_format_lv_azure

hana_log_directory_mount_azure:
  file.directory:
    - name: /hana/log
    - user: root
    - mode: "0755"
    - makedirs: True
  mount.mounted:
    - name: /hana/log
    - device: /dev/vg_hana_log/hana_log
    - fstype: {{ grains['hana_fstype'] }}
    - mkmnt: True
    - persist: True
    - opts: defaults,nofail
    - pass_num: 2
    - require:
      - cmd: hana_format_lv_azure

hana_shared_directory_mount_azure:
  file.directory:
    - name: /hana/shared
    - user: root
    - mode: "0755"
    - makedirs: True
  mount.mounted:
    - name: /hana/shared
    - device: /dev/vg_hana_shared/hana_shared
    - fstype: {{ grains['hana_fstype'] }}
    - mkmnt: True
    - persist: True
    - opts: defaults,nofail
    - pass_num: 2
    - require:
      - cmd: hana_format_lv_azure
