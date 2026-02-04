class_name NetfoxContextSettings extends Resource

#@export_tool_button("Reset Settings") var reset_settings: bool

@export_category("Logging")
@export var logging_level: int

enum TickRateMismatchAction {
	WARN,
	DISCONNECT,
	ADJUST,
	SIGNAL
}
@export_category("Time Settings")
@export var tick_rate: int = 30
@export var max_ticks_per_frame: int = 8
@export var recalibrate_threshold: float = 8
@export var stall_threshold: float = 1.0
@export_range(_NetworkTimeSynchronizer.MIN_SYNC_INTERVAL, 2.0, 0.0001) var sync_interval: float = 0.25
@export var sync_samples: int = 8
@export var sync_adjust_steps: int = 8
@export var sync_to_physics: bool = false
@export_range(1, 2, 0.0001) var max_time_stretch: float = 1.25
@export var tick_rate_mismatch_action: TickRateMismatchAction
@export var suppress_offline_peer_warning: bool = false

@export_category("Rollback Settings")
#it was just enabled before.
@export var rollback_enabled: bool = true
@export var history_limit: int = 64
@export var input_redundancy: int = 3
@export_range(0, 4, 1) var display_offset: int = 0
@export_range(0, 4, 1) var input_delay: int = 0
@export var enable_diff_states: bool = true

@export_category("Event Settings")
#again it was just enabled under the events tag before
@export var events_enabled: bool = true

@export_category("Compatibility")

func get_project_setting(setting_str: String, default_value: Variant) -> Variant:
	match setting_str:
		"netfox/rollback/enabled":
			return rollback_enabled
		"netfox/events/enabled":
			return events_enabled
		_:
			if !setting_str.begins_with("netfox"):
				push_error("Cannot translate non-netfox settings.")
				return default_value
			var split_sections: = setting_str.split("/")
			var variable_name: = split_sections[split_sections.size() - 1]
			if self.get(variable_name) == null:
				push_warning("Failed to translate netfox setting: %s" % setting_str)
				return default_value
			return self.get(variable_name)

func set_project_setting(setting_str: String, value: Variant) -> void:
	match setting_str:
		"netfox/rollback/enabled":
			assert(typeof(value) == TYPE_BOOL)
			rollback_enabled = value
		"netfox/events/enabled":
			assert(typeof(value) == TYPE_BOOL)
			events_enabled = value
		_:
			if !setting_str.begins_with("netfox"):
				push_error("Cannot translate non-netfox settings.")
				return
			var split_sections: = setting_str.split("/")
			var variable_name: = split_sections[split_sections.size() - 1]
			var fetch = self.get(variable_name)
			if fetch == null:
				push_error("Failed to translate netfox setting: %s" % setting_str)
				return
			assert(typeof(fetch) == typeof(value))
			self.set(variable_name, value)
