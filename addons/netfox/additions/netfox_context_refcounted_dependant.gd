class_name NetfoxContextRefCountedDependant extends RefCounted

var netfox_context: NetfoxContext 

func _init(ctx: NetfoxContext) -> void:
	assert(ctx != null)
	netfox_context = ctx

var network_time: _NetworkTime :
	get():
		return netfox_context.network_time
var network_time_synchroniser: _NetworkTimeSynchronizer :
	get():
		return netfox_context.network_time_synchroniser
var network_rollback: _NetworkRollback :
	get():
		return netfox_context.network_rollback
var network_events: _NetworkEvents :
	get():
		return netfox_context.network_events
var network_performance: _NetworkPerformance :
	get():
		return netfox_context.network_performance

#Allows for minimal modification of Netfox code.
var NetworkTime: _NetworkTime :
	get():
		return network_time
var NetworkTimeSynchronizer: _NetworkTimeSynchronizer :
	get():
		return network_time_synchroniser
var NetworkRollback: _NetworkRollback :
	get():
		return network_rollback
var NetworkEvents: _NetworkEvents :
	get():
		return network_events
var NetworkPerformance: _NetworkPerformance :
	get():
		return network_performance

var settings: NetfoxContextSettings :
	get():
		return netfox_context.settings
