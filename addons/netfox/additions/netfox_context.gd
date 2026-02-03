##Represents an instance of the netfox library that can be used at any point in the SceneTree instead of at the root level.
##This allows for both server and client to be hosted in the same godot instance.
class_name NetFoxContext extends Node

const INSTANCE_METADATA: StringName = &"_NETFOX_CONTEXT"
#if the instance was obtained via the scene tree
#const INSTANCE_FROM_TREE_METADATA: StringName = &"_NETFOX_INSTANCE_IS_FROM_TREE"


#TODO: replace:
#NetworkTime
#NetworkTimeSynchronizer
#NetworkRollback
#NetworkEvents
#NetworkPerformance

var _network_time: _NetworkTime
var _network_time_synchroniser: _NetworkTimeSynchronizer
var _network_rollback: _NetworkRollback
var _network_events: _NetworkEvents
var _network_performance: _NetworkPerformance

var network_time: _NetworkTime:
	get(): return _network_time

var network_time_synchroniser: _NetworkTimeSynchronizer:
	get(): return _network_time_synchroniser

var network_rollback: _NetworkRollback:
	get(): return _network_rollback

var network_events: _NetworkEvents:
	get(): return _network_events

var network_performance: _NetworkPerformance:
	get(): return _network_performance

func _init() -> void:
	_network_time = _NetworkTime.new()
	_network_time_synchroniser = _NetworkTimeSynchronizer.new()
	_network_rollback = _NetworkRollback.new()
	_network_events = _NetworkEvents.new()
	_network_performance = _NetworkPerformance.new()

func _associate_child(node: Node) -> void:
	if node.has_meta(INSTANCE_METADATA):
		#Already associated, we can assume it's associated to a node further up the tree and override it, still warn though.
		push_warning("Nested NetFoxInstance nodes, the one further down the tree will be prioritised.")
	node.set_meta(INSTANCE_METADATA, self)

func _dessociate_child(node: Node) -> void:
	if node.has_meta(INSTANCE_METADATA):
		var instance = node.get_meta(INSTANCE_METADATA)
		if instance != self or instance == null:
			#We're not the owner so none of our business
			return
		instance.remove_meta(INSTANCE_METADATA)

func _enter_tree() -> void:
	var children = [_network_time, _network_time_synchroniser, _network_rollback, _network_events, _network_performance]
	for child in children:
		_associate_child(child)
		add_child(child, true)

static func get_context(node: Node) -> NetFoxContext:
	if not node.has_meta(INSTANCE_METADATA):
		push_warning("Not associated with any NetFoxContext.")
		return null
	var instance = node.get_meta(INSTANCE_METADATA)
	assert(instance is NetFoxInstance, "bug")
	return instance
