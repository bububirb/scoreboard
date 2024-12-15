# GodotEnv Singleton
# Author: Nik Mirza
# Email: nik96mirza[at]gmail.com
extends Node

@onready var parser = GodotEnv_Parser.new()
var env = {}

func _ready():
	env = parser.parse("res://.env")
	
func get_env(env_name):
	# prioritized os environment variable
	if(OS.has_environment(env_name)):
		return OS.get_environment(env_name)
		
	if(env.has(env_name)):
		return env[env_name]
	# return empty
	return ""
