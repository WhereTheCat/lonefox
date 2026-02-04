class_name OneshotSignal extends RefCounted

var _signal: Signal
var _callable: Callable

func _init(signal_source: Signal, callable: Callable) -> void:
	_signal = signal_source
	_callable = callable

func emit() -> void:
	assert(_signal != null and _callable != null)
	_callable.call()
	_signal.disconnect(_callable)
	free()
	
static func create_connection(p_signal: Signal, p_callable: Callable) -> void:
	var t = OneshotSignal.new(p_signal, p_callable)
	p_signal.connect(t.emit)
