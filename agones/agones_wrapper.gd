tool
extends EditorPlugin

const SINGLETON_NAME = "AgonesSDK"

func enable_plugin():
	add_autoload_singleton(SINGLETON_NAME, "res://addons/agones/agones_sdk.gd")

func disable_plugin():
	remove_autoload_singleton(SINGLETON_NAME)
