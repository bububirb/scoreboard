extends Node

@export var image: Texture2D

var message: String = "New upload!"
var data_to_send: Dictionary
var url: String

func _ready():
	var image_buffer := Marshalls.raw_to_base64(image.get_image().save_png_to_buffer())
	var file_name: String = "image.png"
	#data_to_send = {'content': message, 'attachments': [{'id': 0, 'description': 'Image of Battle Bay', "filename": file_name}]}
	data_to_send = {
		'content': message,
		"embeds": [{
			"description": "Hello!",
			"image": {"url": "attachment://%s" % file_name},
			"attachments": [{
				"id": 0,
				"description": "Image",
				"filename": file_name
			}]
		}]
	}
	url = get_node("/root/Env").get_env("WEBHOOK_URL")
	
	$HTTPRequest.request_completed.connect(_on_request_completed)
	
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

func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		print("Success!")
	else:
		print("Error Code: ", response_code)
		var json = JSON.parse_string(body.get_string_from_utf8())
		print(json)
