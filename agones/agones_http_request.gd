@tool
extends HTTPRequest
class_name AgonesHTTPRequest

var _endpoint : String

signal agones_request_completed(endpoint: String,
								result: int, 
								response_code: int, 
								headers: PackedStringArray, 
								body: PackedByteArray)
								
# Can't directly override built-in functions, but this is an override for HTTPRequest.request()
func make_request(	endpoint: String = '',
					custom_headers: PackedStringArray = PackedStringArray(),
					method: int = 0, 
					request_data: String = '') -> int:
	if not AgonesSDK.isReady:
		push_error('[AGONES] Trying to make agones request before SDK is ready')
		return RESULT_NO_RESPONSE
		
	_endpoint = endpoint
	self.request_completed.connect(_on_request_completed)
	return super.request(sdk_url(endpoint), custom_headers, method, request_data)
		
func get_endpoint() -> String:
	return _endpoint
	
static func sdk_url(endpoint) -> String:
	return "http://%s:%s%s" % [AgonesSDK.get_host(), AgonesSDK.get_port(), endpoint]
	
func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	agones_request_completed.emit(_endpoint, result, response_code, headers, body)