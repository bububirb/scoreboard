extends Node

var message: String = "New upload!"
var file_name: String = "image.png"
var data_to_send: Dictionary
var url: String

var default_color: int = 0x3399ff

func _ready():
	url = get_node("/root/Env").get_env("WEBHOOK_URL")
	$HTTPRequest.request_completed.connect(_on_request_completed)
	
func send_image(image: Texture2D):
	var image_buffer := Marshalls.raw_to_base64(image.get_image().save_png_to_buffer())
	data_to_send = {
		"embeds": [{
			"image": {"url": "attachment://%s" % file_name},
			"attachments": [{
				"id": 0,
				"description": "Image",
				"filename": file_name
			}],
			"color": default_color
		}]
	}
	
	
	var json = "\r\n--ABCD1234\r\n"
	json += "Content-Disposition: form-data; name=\"payload_json\"\r\n"
	json += "Content-Type: application/json\r\n\r\n"
	json += JSON.stringify(data_to_send)
	json += "\r\n--ABCD1234\r\n"
	json += "Content-Disposition: form-data; name=\"files[0]\"; filename=\"%s\"\r\n" % file_name
	json += "Content-Type: image/png\r\n"
	json += "Content-Transfer-Encoding: base64\r\n\r\n"
	json += JSON.stringify(image_buffer)
	json += "\r\n--ABCD1234--\r\n"
	
	var headers = ["Content-Type: multipart/form-data; boundary=ABCD1234"]
	$HTTPRequest.request(url, headers, HTTPClient.METHOD_POST, json)

func _on_request_completed(_result, response_code, _headers, body):
	if response_code == 200:
		print("Success!")
	else:
		print("Error Code: ", response_code)
		var json = JSON.parse_string(body.get_string_from_utf8())
		print(json)
