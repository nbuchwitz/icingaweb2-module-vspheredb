CREATE TYPE enum_boolean AS ENUM('y', 'n');
CREATE TYPE enum_scheme AS ENUM ('http', 'https');
CREATE TYPE enum_proxy AS ENUM('HTTP', 'SOCKS5');
CREATE TYPE enum_loglevel AS ENUM('debug', 'info', 'warning', 'error');
CREATE TYPE enum_object_type AS ENUM(
    'ComputeResource',
    'ClusterComputeResource',
    'Datacenter',
    'Datastore',
    'DatastoreHostMount',
    'DistributedVirtualPortgroup',
    'DistributedVirtualSwitch',
    'Folder',
    'HostMountInfo',
    'HostSystem',
    'Network',
    'ResourcePool',
    'StoragePod',
    'VirtualApp',
    'VirtualMachine',
    'VmwareDistributedVirtualSwitch'
);
CREATE TYPE enum_status_colors AS ENUM(
    'gray',
    'green',
    'yellow',
    'red'
);
CREATE TYPE enum_network_protocol AS ENUM('ipv4', 'ipv6');
CREATE TYPE enum_maintenance_mode AS ENUM(
    'normal',
    'enteringMaintenance',
    'inMaintenance'
);
CREATE TYPE enum_disk_type AS ENUM(
    'persistent', -- Changes are immediately and permanently written to the virtual disk.
    'nonpersistent', -- Changes to virtual disk are made to a redo log and discarded at power off.
    'undoable', -- Changes are made to a redo log, but you are given the option to commit or undo.
    'independent_persistent', -- Same as persistent, but not affected by snapshots.
    'independent_nonpersistent', -- Same as nonpersistent, but not affected by snapshots.
    'append' -- Changes are appended to the redo log; you revoke changes by removing the undo log.
);
CREATE TYPE enum_address_type AS ENUM(
    'manual',    -- Statically assigned MAC address
    'generated', -- Automatically generated MAC address
    'assigned'   -- MAC address assigned by VirtualCenter
);

CREATE TYPE enum_alarm_type AS ENUM (
    'AlarmAcknowledgedEvent',
    'AlarmClearedEvent',
    'AlarmCreatedEvent',
    'AlarmReconfiguredEvent',
    'AlarmRemovedEvent',
    'AlarmStatusChangedEvent'
);

CREATE TYPE enum_event_type AS ENUM (
    'VmBeingMigratedEvent',
    'VmBeingHotMigratedEvent',
    'VmEmigratingEvent',
    'VmFailedMigrateEvent',
    'VmMigratedEvent',
    'DrsVmMigratedEvent',
    'VmBeingCreatedEvent',
    'VmCreatedEvent',
    'VmStartingEvent',
    'VmPoweredOnEvent',
    'VmPoweredOffEvent',
    'VmSuspendedEvent',
    'VmStoppingEvent',
    'VmBeingDeployedEvent',
    'VmReconfiguredEvent',
    'VmBeingClonedEvent',
    'VmBeingClonedNoFolderEvent',
    'VmClonedEvent',
    'VmCloneFailedEvent'
);

CREATE TYPE enum_connection_state AS ENUM (
    'connected',    -- server has access to the vm
    'disconnected', -- disconnected from the virtual machine, since its host is disconnected
    'inaccessible', -- vm config unaccessible
    'invalid',      -- vm config is invalid
    'orphaned'      -- vm no longer exists on host (but in vCenter)
);

CREATE TYPE enum_monitoring_source_type AS ENUM (
    'ido',
    'icinga2-api',
    'icingadb'
);

CREATE TYPE enum_hoststate AS ENUM(
    'UP',
    'DOWN',
    'UNREACHABLE',
    'MISSING'
);

CREATE TYPE enum_stats_type AS ENUM( -- statsType
    'absolute',
    'delta',
    'rate'
);

CREATE TYPE enum_rollup_type AS ENUM(  -- rollupType
    'average',
    'maximum',
    'minimum',
    'latest',
    'summation',
    'none'
);

CREATE TYPE enum_host_runtime_power_state AS ENUM (
    'poweredOff',
    'poweredOn',
    'standBy',
    'unknown'
);

CREATE TYPE enum_connection_type AS ENUM (
    'connected',    -- server has access to the vm
    'disconnected', -- disconnected from the virtual machine, since its host is disconnected
    'inaccessible', -- vm config unaccessible
    'invalid',      -- vm config is invalid
    'orphaned'      -- vm no longer exists on host (but in vCenter)
);

CREATE TYPE enum_guest_state AS ENUM (
    'notRunning',
    'resetting',
    'running',
    'shuttingDown',
    'standby',
    'unknown'
);
CREATE TYPE enum_guest_tools_status AS  ENUM (
    'toolsNotInstalled',
    'toolsNotRunning',
    'toolsOld',
    'toolsOk'
);

CREATE TYPE enum_guest_tools_running_status AS ENUM (
    'guestToolsNotRunning',
    'guestToolsRunning',
    'guestToolsExecutingScripts' -- VMware Tools is starting.
);

CREATE TYPE enum_runtime_power_state AS ENUM (
    'poweredOff',
    'poweredOn',
    'suspended'
);

CREATE TYPE enum_portgroup_type AS ENUM (
    'earlyBinding', -- assigned when reconfigured
    'ephemeral',    -- assigned when powered on
    'lateBinding'   -- Deprecated as of vSphere API 5.0.
);

CREATE TYPE enum_disk_mode AS ENUM(
    'persistent', -- Changes are immediately and permanently written to the virtual disk.
    'nonpersistent', -- Changes to virtual disk are made to a redo log and discarded at power off.
    'undoable', -- Changes are made to a redo log, but you are given the option to commit or undo.
    'independent_persistent', -- Same as persistent, but not affected by snapshots.
    'independent_nonpersistent', -- Same as nonpersistent, but not affected by snapshots.
    'append' -- Changes are appended to the redo log; you revoke changes by removing the undo log.
);

-- CREATE TABLE trust_store (
--   id BIGINT NOT NULL AUTO_INCREMENT,
--   certificate
-- );

-- CREATE TABLE trust_store_ca (
--   trust_store_id
-- );

CREATE TABLE vspheredb_schema_migration (
  schema_version INTEGER NOT NULL,
  migration_time TIMESTAMP WITHOUT TIME ZONE NOT NULL,
  PRIMARY KEY(schema_version)
);

CREATE TABLE vcenter (
  id serial,
  instance_uuid bytea CHECK(LENGTH(instance_uuid) = 16) NOT NULL UNIQUE,
  trust_store_id BIGINT DEFAULT NULL, -- TODO: not null?
  name VARCHAR(64) NOT NULL, -- name	"VMware vCenter Server"
  version VARCHAR(10) NOT NULL, -- version	"6.0.0"
  os_type VARCHAR(32) NOT NULL, -- osType	"linux-x64"
  api_type VARCHAR(64) NOT NULL, -- apiType	"VirtualCenter"
  api_version VARCHAR(10) NOT NULL, -- apiVersion	"6.0"
  build VARCHAR(32) DEFAULT NULL, -- build "5318203"
  -- fullName -> "<api_type> <version> build-<build>"
  vendor VARCHAR(64) NOT NULL, -- vendor	"VMware, Inc."
  product_line VARCHAR(32) DEFAULT NULL, -- productLineId	string	"vpx"
  license_product_name VARCHAR(64) DEFAULT NULL, -- licenseProductName	"VMware VirtualCenter Server"
  license_product_version VARCHAR(10) DEFAULT NULL, -- licenseProductVersion"6.0"
  locale_build VARCHAR(32) DEFAULT NULL, -- localeBuild	"000"
  locale_version VARCHAR(10) DEFAULT NULL, -- localeVersion	"INTL"
  PRIMARY KEY ("id")
);

-- currently: id!
CREATE TABLE vcenter_server (
  id serial PRIMARY KEY,
  vcenter_id BIGINT DEFAULT NULL REFERENCES vcenter(id) ON DELETE SET NULL ON UPDATE CASCADE,
  -- vcenter_uuid bytea CHECK(LENGTH(vcenter_uuid) = 16) NOT NULL,
  -- server_uuid bytea CHECK(LENGTH(server_uuid) = 16) NOT NULL, -- md5(vcenter_uuid:scheme://host
  host VARCHAR(255) NOT NULL,
  scheme enum_scheme NOT NULL,
  username VARCHAR(64) NOT NULL,
  password VARCHAR(64) NOT NULL,
  proxy_type enum_proxy DEFAULT NULL,
  proxy_address VARCHAR(255) DEFAULT NULL,
  proxy_user VARCHAR(64) DEFAULT NULL,
  proxy_pass VARCHAR(64) DEFAULT NULL,
  ssl_verify_peer enum_boolean NOT NULL,
  ssl_verify_host enum_boolean NOT NULL,
  enabled enum_boolean NOT NULL
);


CREATE TABLE vspheredb_daemon (
  instance_uuid bytea CHECK(LENGTH(instance_uuid) = 16) NOT NULL, -- random by daemon
  fqdn VARCHAR(255) NOT NULL,
  username VARCHAR(64) NOT NULL,
  pid BIGINT NOT NULL,
  php_version VARCHAR(64) NOT NULL,
  ts_last_refresh NUMERIC(20) NOT NULL,
  process_info TEXT NOT NULL,
  PRIMARY KEY (instance_uuid)
);


CREATE TABLE vspheredb_daemonlog (
  vcenter_uuid bytea CHECK(LENGTH(vcenter_uuid) = 16) NOT NULL,
  instance_uuid bytea CHECK(LENGTH(instance_uuid) = 16) NOT NULL,
  ts_create NUMERIC(20) NOT NULL,
  level enum_loglevel NOT NULL,
  message TEXT NOT NULL
);

CREATE INDEX vpheredb_daemon_idx ON vspheredb_daemonlog (vcenter_uuid, ts_create);


CREATE TABLE vcenter_sync (
  vcenter_uuid bytea CHECK(LENGTH(vcenter_uuid) = 16) NOT NULL,
  fqdn VARCHAR(255) NOT NULL,
  username VARCHAR(64) NOT NULL,
  pid BIGINT NOT NULL,
  php_version VARCHAR(64) NOT NULL,
  ts_last_refresh BIGINT NOT NULL,
  PRIMARY KEY (vcenter_uuid)
);

CREATE TABLE vcenter_session (
  session_id bytea NOT NULL CHECK(LENGTH(session_id) = 20), -- hex2bin(sid)
  vcenter_id BIGINT NOT NULL REFERENCES vcenter(id) ON DELETE CASCADE ON UPDATE CASCADE,
  session_cookie_string VARCHAR(255) NOT NULL,
  session_cookie_name VARCHAR(64) NOT NULL,
  scope VARCHAR(32) NOT NULL,
  -- vmware_soap_session="72bb45defccdf97b1945e686228279af0c3746a9"; Path=/; HttpOnly; Secure;
  ts_created BIGINT NOT NULL,
  ts_last_check BIGINT NOT NULL,
  PRIMARY KEY (session_id)
);

CREATE TABLE vcenter_event_history_collector (
  session_id bytea NOT NULL CHECK(LENGTH(session_id) = 20) REFERENCES vcenter_session(session_id) ON DELETE CASCADE ON UPDATE CASCADE,
  -- session[52dd54f1-28a1-4b84-6bd4-fc45fd9f3b78]52fc6d14-1c07-ffcd-107c-7132b2d263b0"
  ref_string VARCHAR(128) NOT NULL,
  ts_created BIGINT NOT NULL
);

CREATE TABLE object (
  uuid bytea NOT NULL CHECK(LENGTH(uuid) = 20), -- sha1(vcenter_uuid + moref)
  vcenter_uuid bytea CHECK(LENGTH(vcenter_uuid) = 16) NOT NULL REFERENCES vcenter(instance_uuid) ON DELETE RESTRICT ON UPDATE CASCADE,
  -- Hint: 64 Bytes might seem overkill for MoRefs, but there is
  --       52d4e949-55c225c2923-a7ba-009689221ad9-datastorebrowser on ESXi
  moref VARCHAR(64) NOT NULL, -- textual id
  object_name VARCHAR(255) NOT NULL,
  object_type enum_object_type NOT NULL,
  overall_status enum_status_colors NOT NULL,
  level SMALLINT NOT NULL,
  parent_uuid bytea DEFAULT NULL CHECK(parent_uuid IS NULL OR LENGTH(parent_uuid) = 20) REFERENCES object(uuid) ON DELETE RESTRICT ON UPDATE RESTRICT,
  PRIMARY KEY(uuid),
  UNIQUE (vcenter_uuid, moref)
);

CREATE INDEX object_type_idx on object (object_type);
CREATE INDEX object_name_idx on object (left(object_name, 64) varchar_pattern_ops);

CREATE TABLE host_system (
  uuid bytea NOT NULL CHECK(LENGTH(uuid) = 20),
  host_name VARCHAR(255) DEFAULT NULL,
  vcenter_uuid bytea CHECK(LENGTH(vcenter_uuid) = 16) NOT NULL,
  product_api_version VARCHAR(32) NOT NULL, -- 6.0
  product_full_name VARCHAR(64) NOT NULL,   -- VMware ESXi 6.0.0 build-5572656
  bios_version VARCHAR(64) DEFAULT NULL, -- P89, SE5C610.86B.01.01.0020.122820161512
  bios_release_date TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL, -- 2017-02-17T00:00:00Z
  sysinfo_vendor VARCHAR(64) NOT NULL, -- HP
  sysinfo_model VARCHAR(64) NOT NULL,  -- ProLiant DL380 Gen9
  sysinfo_uuid VARCHAR(64) NOT NULL,   -- 30133937-3365-54a3-3544-30374a334d53
  service_tag VARCHAR(32) DEFAULT NULL, -- DQ6EXJ3
  hardware_cpu_model VARCHAR(64) NOT NULL, -- Intel(R) Xeon(R) CPU E5-2699A v4 @ 2.40GHz
  hardware_cpu_mhz BIGINT NOT NULL,
  hardware_cpu_packages INTEGER NOT NULL,
  hardware_cpu_cores INTEGER NOT NULL,
  hardware_cpu_threads INTEGER NOT NULL,
  hardware_memory_size_mb BIGINT NOT NULL,
  hardware_num_hba INTEGER NOT NULL,
  hardware_num_nic INTEGER NOT NULL,
  runtime_power_state enum_host_runtime_power_state NOT NULL,
  PRIMARY KEY(uuid),
  UNIQUE (sysinfo_uuid)
);

CREATE TABLE host_pci_device (
  id VARCHAR(16) NOT NULL, -- bus:slot.function . But: 0000:00:00.0
  host_uuid  bytea NOT NULL CHECK(LENGTH(host_uuid) = 20),
  vcenter_uuid bytea CHECK(LENGTH(vcenter_uuid) = 16) NOT NULL,
  bus bytea NOT NULL, -- byte
  slot bytea NOT NULL, -- byte
  "function" bytea NOT NULL, -- byte
  class_id SMALLINT NOT NULL, -- short
  device_id SMALLINT NOT NULL, -- short
  device_name VARCHAR(255) NOT NULL,
  sub_device_id SMALLINT NOT NULL, -- short
  vendor_id SMALLINT NOT NULL, -- short
  vendor_name VARCHAR(255) NOT NULL,
  sub_vendor_id SMALLINT NOT NULL, -- short
  parent_bridge VARCHAR(64) DEFAULT NULL,
  PRIMARY KEY(host_uuid, id)
);

CREATE TABLE host_sensor (
  name VARCHAR(128) NOT NULL,
  host_uuid  bytea NOT NULL CHECK(LENGTH(host_uuid) = 20),
  vcenter_uuid bytea CHECK(LENGTH(vcenter_uuid) = 16) NOT NULL,
  health_state enum_status_colors NOT NULL,
  current_reading INT NOT NULL,
  unit_modifier SMALLINT NOT NULL,
  base_units VARCHAR(32) DEFAULT NULL,
  rate_units VARCHAR(32) DEFAULT NULL,
  sensor_type VARCHAR(32) NOT NULL,
  -- Seen so far:
  -- fan, power, system, temperature, voltage, other,
  -- Battery, Cable/Interconnect, Chassis, Management Subsystem Health,
  -- Memory, Processors, Software Components, Storage, System, Watchdog
  PRIMARY KEY(host_uuid, name)
);

CREATE TABLE virtual_machine (
  uuid  bytea NOT NULL CHECK(LENGTH(uuid) = 20),
  vcenter_uuid bytea CHECK(LENGTH(vcenter_uuid) = 16) NOT NULL,
  hardware_memorymb BIGINT NOT NULL,
  hardware_numcpu SMALLINT NOT NULL,
  hardware_numcorespersocket SMALLINT DEFAULT 1 NOT NULL,
  template enum_boolean NOT NULL, -- TODO: drop and skip templates? Or separate table?
  instance_uuid VARCHAR(64) NOT NULL,   -- 5004890e-8edd-fe5f-d116-d5704b2043e4
  bios_uuid VARCHAR(64) NOT NULL,       -- 42042ce7-1c4f-b339-2293-40357f1d6860
  version VARCHAR(32) NOT NULL,         -- vmx-11
  online_standby enum_boolean NOT NULL,
  paused enum_boolean DEFAULT NULL,
  cpu_hot_add_enabled enum_boolean NOT NULL,
  memory_hot_add_enabled enum_boolean NOT NULL,
  connection_state enum_connection_state NOT NULL,
  guest_state enum_guest_state NOT NULL,
  guest_tools_status enum_guest_tools_status DEFAULT NULL,
  guest_tools_running_status enum_guest_tools_running_status NOT NULL,
  guest_id VARCHAR(64) DEFAULT NULL,        -- rhel7_64Guest
  -- Linux 3.10.0-693.17.1.el7.x86_64 CentOS Linux release 7.4.1708 (Core)
  guest_full_name VARCHAR(128) DEFAULT NULL, -- Red Hat Enterprise Linux 7 (64-bit)
  guest_host_name VARCHAR(255) DEFAULT NULL,
  guest_ip_address VARCHAR(50) DEFAULT NULL,
  resource_pool_uuid bytea DEFAULT NULL CHECK(resource_pool_uuid IS NULL OR LENGTH(resource_pool_uuid) = 20),
  runtime_host_uuid bytea DEFAULT NULL CHECK(runtime_host_uuid IS NULL OR LENGTH(runtime_host_uuid) = 20),
  runtime_last_boot_time TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL, -- TODO: to BIGINT?
  runtime_last_suspend_time TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL, -- TODO: to BIGINT?
  runtime_power_state enum_runtime_power_state NOT NULL,
  boot_network_protocol enum_network_protocol DEFAULT NULL,
  boot_order VARCHAR(128) DEFAULT NULL,
  annotation TEXT DEFAULT NULL,
  PRIMARY KEY(uuid)
);

CREATE TABLE distributed_virtual_switch (
  uuid bytea NOT NULL CHECK(LENGTH(uuid) = 20),
  num_hosts INTEGER NOT NULL,
  num_ports INTEGER NOT NULL,
  max_ports INTEGER NOT NULL,
  hostmembers_checksum bytea DEFAULT NULL CHECK(hostmembers_checksum IS NULL OR LENGTH(hostmembers_checksum) = 20),
  portgroups_checksum bytea DEFAULT NULL CHECK(portgroups_checksum IS NULL OR LENGTH(portgroups_checksum) = 20),
  vms_checksum bytea DEFAULT NULL CHECK(vms_checksum IS NULL OR LENGTH(vms_checksum) = 20),
  vcenter_uuid bytea CHECK(LENGTH(vcenter_uuid) = 16) NOT NULL,
  description TEXT DEFAULT NULL,
  PRIMARY KEY(uuid)
);

CREATE INDEX distributed_virtual_switch_vcenter_uuid_idx on distributed_virtual_switch(vcenter_uuid);

CREATE TABLE distributed_virtual_portgroup (
  uuid bytea NOT NULL CHECK(LENGTH(uuid) = 20),
  portgroup_type enum_portgroup_type NOT NULL,
  vlan INTEGER DEFAULT NULL,
  vlan_ranges VARCHAR(255) DEFAULT NULL,
  num_ports INTEGER NOT NULL,
  distributed_virtual_switch_uuid bytea NOT NULL CHECK(LENGTH(distributed_virtual_switch_uuid) = 20),
  vcenter_uuid bytea CHECK(LENGTH(vcenter_uuid) = 16) NOT NULL,
  PRIMARY KEY(uuid)
  );

CREATE INDEX distributed_virtual_portgroup_vcenter_uuid_idx on distributed_virtual_portgroup(vcenter_uuid);


CREATE TABLE datastore (
  uuid bytea NOT NULL CHECK(LENGTH(uuid) = 20),
  vcenter_uuid bytea CHECK(LENGTH(vcenter_uuid) = 16) NOT NULL,
  maintenance_mode enum_maintenance_mode DEFAULT NULL,
  is_accessible enum_boolean NOT NULL,
  capacity NUMERIC(20) DEFAULT NULL,
  free_space NUMERIC(20) DEFAULT NULL,
  uncommitted NUMERIC(20) DEFAULT NULL,
  multiple_host_access enum_boolean DEFAULT NULL,
  -- datastore_type ENUM(
  --     'vmfs', -- VMFS??
  --     'nfs',
  --     'cifs'
  -- ) NOT NULL,
  PRIMARY KEY(uuid)
);

CREATE TABLE vm_snapshot (
  uuid bytea NOT NULL CHECK(LENGTH(uuid) = 20),
  parent_uuid bytea DEFAULT NULL CHECK(parent_uuid IS NULL OR LENGTH(parent_uuid) = 20),
  vcenter_uuid bytea CHECK(LENGTH(vcenter_uuid) = 16) NOT NULL,
  vm_uuid bytea NOT NULL CHECK(LENGTH(vm_uuid) = 20),
  id BIGINT NOT NULL,
  moref VARCHAR(32) NOT NULL, -- textual id, we have no object entry
  name VARCHAR(255) NOT NULL,
  description TEXT DEFAULT NULL,
  ts_create BIGINT NOT NULL,
  state enum_runtime_power_state NOT NULL, -- VM power state when the snapshot was taken
  quiesced enum_boolean NOT NULL,
  PRIMARY KEY (uuid)
);

CREATE INDEX vm_snapshot_vcenter_uuid_idx on vm_snapshot(vcenter_uuid);

CREATE TABLE vm_datastore_usage (
  vm_uuid bytea NOT NULL CHECK(LENGTH(vm_uuid) = 20),
  datastore_uuid  bytea NOT NULL CHECK(LENGTH(datastore_uuid) = 20),
  vcenter_uuid bytea CHECK(LENGTH(vcenter_uuid) = 16) NOT NULL,
  committed NUMERIC(20) DEFAULT NULL,
  uncommitted NUMERIC(20) DEFAULT NULL,
  unshared NUMERIC(20) DEFAULT NULL,
  PRIMARY KEY(vm_uuid, datastore_uuid)
);

CREATE INDEX vm_datastore_usage_vcenter_uuid_idx on vm_datastore_usage(vcenter_uuid);

CREATE TABLE vm_hardware (
  vm_uuid bytea NOT NULL CHECK(LENGTH(vm_uuid) = 20),
  hardware_key BIGINT NOT NULL,
  vcenter_uuid bytea CHECK(LENGTH(vcenter_uuid) = 16) NOT NULL,
  bus_number BIGINT DEFAULT NULL,
  unit_number BIGINT DEFAULT NULL, -- unit number of this device on its controller
  controller_key BIGINT DEFAULT NULL,
  label VARCHAR(64) NOT NULL,
  summary VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY(vm_uuid, hardware_key)
);

CREATE INDEX vm_hardware_vcenter_uuid_idx on vm_hardware(vcenter_uuid);

CREATE TABLE vm_disk (
  vm_uuid bytea NOT NULL CHECK(LENGTH(vm_uuid) = 20),
  hardware_key BIGINT NOT NULL,
  disk_uuid bytea CHECK(disk_uuid is null or LENGTH(disk_uuid) = 16) DEFAULT NULL, -- backing->uuid: 6000C272-5a6b-ca2f-1706-4d2493ba11f0
  datastore_uuid bytea DEFAULT NULL CHECK(datastore_uuid IS NULL OR LENGTH(datastore_uuid) = 20), -- backing->datastore->_
  file_name VARCHAR(255) DEFAULT NULL, -- backing->fileName: [DSNAME] <name>/<name>.vmdk
  capacity NUMERIC(20) DEFAULT NULL, -- capacityInBytes
  disk_mode enum_disk_mode NOT NULL, -- backing->diskMode
  split enum_boolean DEFAULT NULL, --  Flag to indicate the type of virtual disk file: split or monolithic.
                                  -- If true, the virtual disk is stored in multiple files, each 2GB.
  write_through enum_boolean DEFAULT NULL,
  thin_provisioned enum_boolean DEFAULT NULL,
  vcenter_uuid bytea CHECK(LENGTH(vcenter_uuid) = 16) NOT NULL,
  PRIMARY KEY(vm_uuid, hardware_key)
);

CREATE INDEX vm_disk_vcenter_uuid_idx on vm_disk(vcenter_uuid);

CREATE TABLE vm_disk_usage (
  vm_uuid bytea NOT NULL CHECK(LENGTH(vm_uuid) = 20),
  disk_path VARCHAR(128) NOT NULL,
  capacity BIGINT NOT NULL,
  free_space BIGINT NOT NULL,
  vcenter_uuid bytea CHECK(LENGTH(vcenter_uuid) = 16) NOT NULL,
  PRIMARY KEY(vm_uuid, disk_path)
);

CREATE INDEX vm_disk_usage_vcenter_uuid_idx on vm_disk_usage(vcenter_uuid);

CREATE TABLE vm_network_adapter (
  vm_uuid bytea NOT NULL CHECK(LENGTH(vm_uuid) = 20),
  hardware_key BIGINT NOT NULL,
  portgroup_uuid bytea DEFAULT NULL CHECK(portgroup_uuid IS NULL OR LENGTH(portgroup_uuid) = 20), -- port->portgroupKey (moid, dvportgroup-1288720)
  port_key VARCHAR(64) DEFAULT NULL, -- port->portKey Can be 'c-31'
  mac_address VARCHAR(17) DEFAULT NULL, -- binary(6)? new xxeuid?
  address_type enum_address_type NOT NULL,
  vcenter_uuid bytea CHECK(LENGTH(vcenter_uuid) = 16) NOT NULL,
  PRIMARY KEY(vm_uuid, hardware_key)
);

CREATE INDEX vm_network_adapter_vcenter_uuid_idx on vm_network_adapter(vcenter_uuid);

CREATE TABLE host_quick_stats (
  uuid bytea NOT NULL CHECK(LENGTH(uuid) = 20),
  distributed_cpu_fairness INTEGER DEFAULT NULL,
  distributed_memory_fairness INTEGER DEFAULT NULL,
  overall_cpu_usage BIGINT DEFAULT NULL,
  overall_memory_usage_mb BIGINT DEFAULT NULL,
  uptime BIGINT DEFAULT NULL,
  vcenter_uuid bytea CHECK(LENGTH(vcenter_uuid) = 16) NOT NULL,
  PRIMARY KEY(uuid)
);

CREATE INDEX host_quick_stats_vcenter_uuid_idx on host_quick_stats(vcenter_uuid);

CREATE TABLE vm_quick_stats (
  uuid bytea NOT NULL CHECK(LENGTH(uuid) = 20),
  ballooned_memory_mb BIGINT DEFAULT NULL,
  compressed_memory_kb NUMERIC(20) DEFAULT NULL,
  consumed_overhead_memory_mb BIGINT DEFAULT NULL,
  distributed_cpu_entitlement BIGINT DEFAULT NULL, -- mhz
  distributed_memory_entitlement_mb BIGINT DEFAULT NULL,
  ft_latency_status enum_status_colors DEFAULT NULL,
  ft_log_bandwidth INTEGER DEFAULT NULL, -- Hint -1 -> NULL
  ft_secondary_latency INTEGER DEFAULT NULL, -- Hint -1 -> NULL
  guest_heartbeat_status enum_status_colors NOT NULL,
  guest_memory_usage_mb BIGINT DEFAULT NULL,
  host_memory_usage_mb BIGINT DEFAULT NULL,
  overall_cpu_demand BIGINT DEFAULT NULL, -- mhz
  overall_cpu_usage BIGINT DEFAULT NULL, -- mhz
  private_memory_mb BIGINT DEFAULT NULL,
  shared_memory_mb BIGINT DEFAULT NULL,
  ssd_swapped_memory_kb BIGINT DEFAULT NULL,
  static_cpu_entitlement BIGINT DEFAULT NULL, -- mhz
  static_memory_entitlement_mb BIGINT DEFAULT NULL,
  swapped_memory_mb BIGINT DEFAULT NULL,
  uptime BIGINT DEFAULT NULL,
  vcenter_uuid bytea CHECK(LENGTH(vcenter_uuid) = 16) NOT NULL,
  PRIMARY KEY(uuid)
);
CREATE INDEX vm_quick_stats_vcenter_uuid_idx on vm_quick_stats(vcenter_uuid);

CREATE TABLE alarm_history (
  id bigserial NOT NULL,
  vcenter_uuid bytea CHECK(LENGTH(vcenter_uuid) = 16) NOT NULL,
  ts_event_ms BIGINT NOT NULL,
  event_type enum_alarm_type NOT NULL,
  event_key NUMERIC(20) NOT NULL,
  event_chain_id NUMERIC(20) NOT NULL,
  entity_uuid bytea DEFAULT NULL CHECK(entity_uuid IS NULL OR LENGTH(entity_uuid) = 20),
  source_uuid bytea DEFAULT NULL CHECK(source_uuid IS NULL OR LENGTH(source_uuid) = 20),
  alarm_name VARCHAR(255) DEFAULT NULL,
  alarm_moref VARCHAR(48) DEFAULT NULL,
  status_from enum_status_colors DEFAULT NULL,
  status_to enum_status_colors DEFAULT NULL,
  full_message TEXT DEFAULT NULL,
  PRIMARY KEY (id)
);

CREATE INDEX alarm_history_time_idx on alarm_history(ts_event_ms);
CREATE INDEX alarm_history_search_type_idx on alarm_history(event_type, ts_event_ms);
CREATE INDEX alarm_history_search_entity_idx on alarm_history(entity_uuid, ts_event_ms);

CREATE TABLE vm_event_history (
  id bigserial NOT NULL,
  vcenter_uuid bytea CHECK(LENGTH(vcenter_uuid) = 16) NOT NULL,
  ts_event_ms BIGINT NOT NULL,
  event_type enum_event_type NOT NULL,
  event_key NUMERIC(20) NOT NULL,
  event_chain_id NUMERIC(20) NOT NULL,
  is_template enum_boolean DEFAULT NULL,
  datacenter_uuid bytea DEFAULT NULL CHECK(datacenter_uuid IS NULL OR LENGTH(datacenter_uuid) = 20),
  compute_resource_uuid bytea DEFAULT NULL CHECK(compute_resource_uuid IS NULL OR LENGTH(compute_resource_uuid) = 20),
  host_uuid bytea DEFAULT NULL CHECK(host_uuid IS NULL OR LENGTH(host_uuid) = 20),
  vm_uuid bytea DEFAULT NULL CHECK(vm_uuid IS NULL OR LENGTH(vm_uuid) = 20),
  datastore_uuid bytea DEFAULT NULL CHECK(datastore_uuid IS NULL OR LENGTH(datastore_uuid) = 20),
  dvs_uuid bytea DEFAULT NULL CHECK(dvs_uuid IS NULL OR LENGTH(dvs_uuid) = 20),
  destination_host_uuid bytea DEFAULT NULL CHECK(destination_host_uuid IS NULL OR LENGTH(destination_host_uuid) = 20),
  destination_datacenter_uuid bytea DEFAULT NULL CHECK(destination_datacenter_uuid IS NULL OR LENGTH(destination_datacenter_uuid) = 20),
  destination_datastore_uuid bytea DEFAULT NULL CHECK(destination_datastore_uuid IS NULL OR LENGTH(destination_datastore_uuid) = 20),
  full_message TEXT DEFAULT NULL,
  user_name VARCHAR(128) DEFAULT NULL,
  fault_message TEXT DEFAULT NULL,
  fault_reason TEXT DEFAULT NULL,
  config_spec TEXT DEFAULT NULL,
  config_changes TEXT DEFAULT NULL,
  PRIMARY KEY (id)
);

CREATE INDEX vm_event_history_time_idx ON vm_event_history(ts_event_ms);
CREATE INDEX vm_event_history_search_type_idx ON vm_event_history(event_type, ts_event_ms);
CREATE INDEX vm_event_history_search_host_idx ON vm_event_history(host_uuid, ts_event_ms);
CREATE INDEX vm_event_history_search_vm_idx ON vm_event_history(vm_uuid, ts_event_ms);
CREATE INDEX vm_event_history_search_ds_idx ON vm_event_history(datastore_uuid, ts_event_ms);

CREATE TABLE monitoring_connection (
  vcenter_uuid bytea CHECK(LENGTH(vcenter_uuid) = 16) NOT NULL REFERENCES vcenter(instance_uuid) ON DELETE RESTRICT ON UPDATE CASCADE,
  priority INTEGER NOT NULL,
  source_type enum_monitoring_source_type NOT NULL,
  source_resource_name VARCHAR(64) DEFAULT NULL, -- null means default resource
  host_property VARCHAR(128) DEFAULT NULL,
  monitoring_host_property VARCHAR(128) DEFAULT NULL,
  vm_property VARCHAR(128) DEFAULT NULL,
  monitoring_vm_host_property VARCHAR(128) DEFAULT NULL,
  PRIMARY KEY (vcenter_uuid, priority)
);

CREATE TABLE host_monitoring_hoststate (
  host_uuid bytea NOT NULL CHECK(LENGTH(host_uuid) = 20) REFERENCES host_system(uuid) ON DELETE CASCADE ON UPDATE CASCADE,
  ido_connection_id BIGINT NOT NULL,
  icinga_object_id BIGINT NOT NULL,
  current_state enum_hoststate NOT NULL,
  PRIMARY KEY (host_uuid)
);
CREATE INDEX host_monitoring_hoststate_sync_idx ON host_monitoring_hoststate (ido_connection_id);

CREATE TABLE vm_monitoring_hoststate (
  vm_uuid bytea NOT NULL CHECK(LENGTH(vm_uuid) = 20) REFERENCES virtual_machine(uuid) ON DELETE CASCADE ON UPDATE CASCADE,
  ido_connection_id BIGINT NOT NULL,
  icinga_object_id BIGINT NOT NULL,
  current_state enum_hoststate NOT NULL,
  PRIMARY KEY (vm_uuid)
);
CREATE INDEX vm_monitoring_hoststate_idx on vm_monitoring_hoststate (ido_connection_id);

CREATE TABLE performance_unit (
  vcenter_uuid bytea CHECK(LENGTH(vcenter_uuid) = 16) NOT NULL,
  name VARCHAR(32) NOT NULL,
  label VARCHAR(16) NOT NULL,
  summary VARCHAR(64) NOT NULL,
  PRIMARY KEY (name)
);

CREATE TABLE performance_group (
  vcenter_uuid bytea CHECK(LENGTH(vcenter_uuid) = 16) NOT NULL,
  name VARCHAR(32) NOT NULL,
  label VARCHAR(48) NOT NULL,
  summary VARCHAR(64) NOT NULL,
  PRIMARY KEY (name)
);

CREATE TABLE performance_collection_interval (
  vcenter_uuid bytea CHECK(LENGTH(vcenter_uuid) = 16) NOT NULL,
  name VARCHAR(32) NOT NULL,
  label VARCHAR(48) NOT NULL,
  summary VARCHAR(64) NOT NULL,
  PRIMARY KEY (name)
);

CREATE TABLE performance_counter (
  vcenter_uuid bytea CHECK(LENGTH(vcenter_uuid) = 16) NOT NULL
    REFERENCES vcenter(instance_uuid) ON DELETE RESTRICT ON UPDATE RESTRICT,
  counter_key BIGINT NOT NULL,
  name VARCHAR(32) NOT NULL,
  label VARCHAR(96) NOT NULL,
  group_name VARCHAR(32) NOT NULL
    REFERENCES performance_group(name) ON DELETE RESTRICT ON UPDATE RESTRICT,
  unit_name VARCHAR(32) NOT NULL
    REFERENCES performance_unit(name) ON DELETE RESTRICT ON UPDATE RESTRICT,
  summary VARCHAR(255) NOT NULL,
  stats_type enum_stats_type NOT NULL,
  rollup_type enum_rollup_type NOT NULL,
  level SMALLINT NOT NULL, -- level 1-4
  per_device_level SMALLINT NOT NULL, -- perDeviceLevel 1-4
  -- collection_interval BIGINT NOT NULL, -- 300, 86400... -> nur pro el?
  PRIMARY KEY (vcenter_uuid, counter_key)
  -- UNIQUE INDEX combined (vcenter_uuid, group_name, name, unit_name),
);

CREATE TABLE counter_300x5 (
  object_uuid bytea NOT NULL CHECK(LENGTH(object_uuid) = 20),
  counter_key BIGINT NOT NULL,
  instance VARCHAR(64) NOT NULL,
  ts_last BIGINT NOT NULL,
  value_last BIGINT NOT NULL,
  value_minus1 BIGINT DEFAULT NULL,
  value_minus2 BIGINT DEFAULT NULL,
  value_minus3 BIGINT DEFAULT NULL,
  value_minus4 BIGINT DEFAULT NULL,
  vcenter_uuid bytea CHECK(LENGTH(vcenter_uuid) = 16) NOT NULL,
  PRIMARY KEY (object_uuid, counter_key, instance)
);
CREATE INDEX counter_300x5_vcenter_uuid ON counter_300x5(vcenter_uuid);

-- Not yet:
-- CREATE TABLE vm_triggered_alarm (
--   id NUMERIC(20) NOT NULL,
--   object_id BIGINT NOT NULL,
-- );

-- CREATE TABLE vm_alarm_history (
--   vm_id NUMERIC(20) AUTO_INCREMENT NOT NULL,
-- );


INSERT INTO vspheredb_schema_migration
    (schema_version, migration_time)
VALUES (6, NOW());
