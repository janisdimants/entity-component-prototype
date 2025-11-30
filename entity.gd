extends Node2D
class_name Entity

# Dictionary[method_name, Array[Callable]]
var methods: Dictionary[StringName, Array] = {}

# Dictionary[signal_name, Array[Node]]
var signals: Dictionary[StringName, Array] = {}

# Dictionary[signal_name, Array[Callable]]
var signal_connects: Dictionary[StringName, Array] = {}

func register_signal(signal_name: StringName, component: Node) -> void:
	# Connect signal to all existing requests
	var connect_requests: Array = signal_connects.get(signal_name, []) as Array[Callable]
	for connect_request: Callable in connect_requests:
		component.connect(signal_name, connect_request)

	# Register signal for future requests
	var signal_array: Array = signals.get(signal_name, []) as Array[Node]
	if signal_array.has(component):
		push_error("Component %s already registered for signal %s" % [component, signal_name])
	else:
		signal_array.append(component)
		signals.set(signal_name, signal_array)

func connect_to_signal(signal_name: StringName, callable: Callable) -> void:
	# Connect to existing signals
	var signal_array: Array = signals.get(signal_name, []) as Array[Node]
	for component: Node in signal_array:
		printt("Connecting", signal_name, callable, "to existing", component)
		component.connect(signal_name, callable)

	# Register request for future new signals
	var connect_requests: Array = signal_connects.get(signal_name, []) as Array[Callable]
	if connect_requests.has(callable):
		print("Signal %s already registered for callable %s" % [signal_name, callable])
	else:
		connect_requests.append(callable)
		signal_connects.set(signal_name, connect_requests)

func register_method(method_name: StringName, callable: Callable) -> void:
	# Register method for future requests
	var method_array: Array = methods.get(method_name, []) as Array[Callable]
	if method_array.has(callable):
		push_error("Method %s already registered for name %s" % [callable, method_name])
	else:
		method_array.append(callable)
		methods.set(method_name, method_array)

func get_methods(method_name: StringName) -> Array[Callable]:
	return methods.get(method_name, []) as Array[Callable]

func get_method(method_name: StringName) -> Callable:
	return methods.get(method_name, [])[0]
