# Agones SDK for Godot
### Version 0.1.2

Welcome to the community-driven [Agones](https://agones.dev/site/) SDK for [Godot Engine](https://godotengine.org/).

## Example

```
extends Node
var peer = null

func _ready():
  if "--server" in OS.get_cmdline_args() or OS.has_feature("Server"):
		host_server(DEFAULT_PORT, MAX_PEERS)

func host_server(port, max_peers):
	peer = NetworkedMultiplayerENet.new()
	peer.create_server(port, max_peers)
	get_tree().set_network_peer(peer)
  # Initialize AGONES SDK
	AgonesSDK.start()
  # Agones READY
  AgonesSDK.ready()

func _process(delta):
  if peer:
    AgonesSDK.health()
```

[Agones](https://agones.dev/site/) is an open source, batteries-included, multiplayer dedicated game server scaling and orchestration platform that can run anywhere Kubernetes can run.

This plugin allows your Godot Scripts communicate with [Agones SDK Server](https://agones.dev/site/docs/guides/client-sdks/) by giving you simple **GDScript** functions. Internally it works by calling the REST API that comes with Agones Server.

> Only GDScript is supported for now

## Install

To install this plugin, go to [Releases](https://github.com/AndreMicheletti/godot-agones-sdk/releases/tag/0.1.1) and download the latest version `agones-sdk.zip`.

Inside your Godot Project folder, create a folder named `addons` and extract the zip file inside it.

After installed, your folder structure will look like this:

![image](https://user-images.githubusercontent.com/16908595/126000349-572411bd-e596-45c1-b7c2-bb3f34d595d2.png)

## Getting Started

### Activate the plugin

- Open your project in Godot Editor
- Go to Project > Project Settings... > Plugins
- You should see AgonesSDK Plugin. On the right side, check the "Enable" box

![image](https://user-images.githubusercontent.com/16908595/126000549-9135b9da-22bf-4163-9409-994bef4fafc0.png)

### Use the plugin functions

See [Agones - Client SDK](https://agones.dev/site/docs/guides/client-sdks/#function-reference)

## Reference

## Contributing

Contributions are very welcome.

## License

Distributed under the terms of the MIT license, "godot-agones-sdk" is free and open source software
