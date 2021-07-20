tool
extends HTTPRequest

signal agones_response(success, endpoint, content)
signal agones_ready_failed()

var ready = false
var agones_sdk_http_port = ""
var requested_endpoint = ""


func _ready():
	if not ready:
		start()


func start():
	ready = true
	connect("request_completed", self, "on_request_completed")
	agones_sdk_http_port = OS.get_environment("AGONES_SDK_HTTP_PORT")
	print("[AGONES] SDK STARTING UP... PORT FOUND: %s" % agones_sdk_http_port)


func ready(retry = 10, wait_time = 2.0):
	var real_retry = max(1, retry + 1)
	var i = 0
	var success = false
	while i < real_retry:
		agones_sdk_post("/ready", {})
		var res = yield(self, "agones_response")
		if res[0] or has_port() == false:
			success = true
			break
		else:
			print("[AGONES] ready failed. trying again (attempt %d/%d)" % [i+1, real_retry-1])
			yield(get_tree().create_timer(wait_time), "timeout")
			i += 1
	if not success:
		emit_signal("agones_ready_failed")


func health():
	agones_sdk_post("/health", {})


func reserve(seconds: int):
	agones_sdk_post("/reserve", {"seconds": seconds})


func allocate():
	agones_sdk_post("/allocate", {})


func shutdown():
	agones_sdk_post("/shutdown", {})


func gameserver():
	agones_sdk_get("/gameserver")


func agones_sdk_get(endpoint: String) -> bool:
	if not has_port():
		print("[AGONES] AGONES_SDK_HTTP_PORT not found. skipping %s call" % endpoint)
		on_request_completed(1, 1, PoolStringArray(), PoolByteArray())
		return false
	print("[AGONES] GET %s" % endpoint)
	requested_endpoint = endpoint
	var res = request(sdk_url(endpoint))
	if res == OK:
		return true
	else:
		on_request_completed(res, 1, PoolStringArray(), PoolByteArray())
		return false


func agones_sdk_post(endpoint: String, body: Dictionary) -> bool:
	if not has_port():
		print("[AGONES] AGONES_SDK_HTTP_PORT not found. skipping %s call" % endpoint)
		on_request_completed(1, 1, PoolStringArray(), PoolByteArray())
		return false
	print("[AGONES] POST %s" % endpoint)
	var headers = ["Content-Type: application/json"]
	requested_endpoint = endpoint
	var res = request(sdk_url(endpoint), headers, false, HTTPClient.METHOD_POST, JSON.print(body))
	if res == OK:
		return true
	else:
		on_request_completed(res, 1, PoolStringArray(), PoolByteArray())
		return false


func on_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray):
	print("[AGONES] REQUESTED COMPLETED. RESPONSE_CODE: %d | CODE: %d" % [response_code, result])
	if result != OK:
		emit_signal("agones_response", false, requested_endpoint, result)
	else:
		var dict_body = JSON.parse(body.get_string_from_utf8())
		emit_signal("agones_response", true, requested_endpoint, dict_body)
	requested_endpoint = ""


func sdk_url(endpoint):
	return "http://localhost:%s%s" % [OS.get_environment("AGONES_SDK_HTTP_PORT"), endpoint]


func has_port():
	return agones_sdk_http_port != ""
