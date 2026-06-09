# Agones SDK for Godot
[![Release](https://github.com/AndreMicheletti/godot-agones-sdk/actions/workflows/release.yml/badge.svg?branch=master)](https://github.com/AndreMicheletti/godot-agones-sdk/actions/workflows/release.yml)
<img src="https://img.shields.io/github/v/release/AndreMicheletti/godot-agones-sdk"/>
<img src="https://img.shields.io/badge/agones-1.16.0-blue"/>
<img src="https://img.shields.io/badge/godot-4.0-blue"/>

<p align="center">
<img src="https://raw.githubusercontent.com/AndreMicheletti/godot-agones-sdk/master/agones-sdk-icon.svg" width="250">
</p>

Welcome to the community-driven [Agones](https://agones.dev/site/) SDK for [Godot Engine](https://godotengine.org/).

Latest version is for **Godot 4.2**.

If you're using **Godot < 4.2**, please use [Release 0.4.0](https://github.com/AndreMicheletti/godot-agones-sdk/releases/tag/v0.4.0)

If you're using **Godot <= 3.x**, please use [Release 0.3.0](https://github.com/AndreMicheletti/godot-agones-sdk/releases/tag/v0.3.0)

## Example

```GDScript
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
  # Agones .Ready()
  AgonesSDK.ready()

func _process(delta):
  if peer:
    # Agones .Health()
    AgonesSDK.health()
```
**What is Agones?**
> [Agones](https://agones.dev/site/) is an open source, batteries-included, multiplayer dedicated game server scaling and orchestration platform that can run anywhere Kubernetes can run.

This plugin allows your Godot Scripts communicate with [Agones](https://agones.dev/site/docs/guides/client-sdks/) by giving you simple **GDScript** functions. Internally it works by calling the REST API that comes with Agones Server.

Only GDScript is supported for now

## Install

To install this plugin, go to [Releases](https://github.com/AndreMicheletti/godot-agones-sdk/releases) and download the latest version `agones-sdk.zip`.
> If you are using **Godot 3.x**, please install [Release 0.3.0](https://github.com/AndreMicheletti/godot-agones-sdk/releases/tag/v0.3.0)

Inside your Godot Project folder, create a folder named `addons` and extract the zip file inside it.

After installed, your folder structure will look like this:

![image](https://user-images.githubusercontent.com/16908595/126000349-572411bd-e596-45c1-b7c2-bb3f34d595d2.png)

## Getting Started

### Activate the plugin

- Open your project in Godot Editor
- Go to Project > Project Settings... > Plugins
- You should see AgonesSDK Plugin. On the right side, check the "Enable" box

![image](https://user-images.githubusercontent.com/16908595/126000549-9135b9da-22bf-4163-9409-994bef4fafc0.png)

## Use the SDK functions

You now have access to a singleton called `AgonesSDK`, which you can use to call SDK functions.

The SDK functions does the communication with [Agones's sidecar server](https://agones.dev/site/docs/guides/client-sdks/#connecting-to-the-sdk-server), which is a small server that goes with your Godot dedicated server inside the Agones Container.

If you want to test in local environment, check this page [Local Development - Agones](https://agones.dev/site/docs/guides/client-sdks/local/)

### Ready()

```GDScript
# Simple usage. Automatically retries 10 times and waits 2 seconds before trying again.
AgonesSDK.ready()

# Tries 30 times, waiting 5 seconds between each attempt.
AgonesSDK.ready(30, 5)
```

### Health()

```GDScript
AgonesSDK.health()
```

### Reserve()

```GDScript
# Reserves the server for 10 seconds
AgonesSDK.reserve(10)

# Reserves the server for 60 seconds
AgonesSDK.reserve(60)
```

### Allocate()

```GDScript
AgonesSDK.allocate()
```

### Shutdown()

```GDScript
AgonesSDK.shutdown()
```

### GameServer()

```GDScript
# Get gameserver information
result = yield(AgonesSDK.gameserver(), "agones_response")

success = result[0]  # true if the request was successfull, false otherwise
requested_endpoint = result[1]  # the url requested
info_dict = result[2]  # the JSON body returned by agones sidecar
```

### SetLabel(key, value) 

```GDScript
# Set metadata label on agones sidecar servr
AgonesSDK.set_label('version', '1.0.0')
```

### SetAnnotation(key, value)

```GDScript
# Set metadata annotation on agones sidecar servr
AgonesSDK.set_annotation('version', '1.0.0')
```

## Player Tracking
As players connect and disconnect from your game, the Player Tracking functions enable you to track which players are currently connected.

### Player connect
```GDScript
# Sets player 1337 as connected
AgonesSDK.player_connect(1337)
```

### Player disconnect
```GDScript
# Unsets player 1337 online status
AgonesSDK.player_disconnect(1337)
```

## Counters & Lists (Beta)

[Counters and Lists](https://agones.dev/site/docs/guides/counters-and-lists/) let you track
arbitrary numeric counters and string lists on your GameServer (player tracking, team slots,
etc). These are **Beta** Agones features and require **Agones 1.37+** (enabled by default since 1.45).

Like the rest of the SDK, every call is asynchronous and reports back through the
`agones_response(success, endpoint, content)` signal. For reads, `content` is the
returned `Counter` (`{name, count, capacity}`) or `List` (`{name, capacity, values}`).

### Lists

```GDScript
# Add a value to a list (e.g. mark a player as connected)
AgonesSDK.append_list_value("players", "player-123")

# Remove a value from a list
AgonesSDK.delete_list_value("players", "player-123")

# Read a list
var result = await AgonesSDK.get_list("players")
# result[2] -> { "name": "players", "capacity": 64, "values": ["player-123"] }

# Set the maximum capacity of a list
AgonesSDK.set_list_capacity("players", 64)
```

> `add_list_value` / `remove_list_value` are available as aliases matching the
> Agones REST endpoint names (`:addValue` / `:removeValue`).

### Counters

```GDScript
# Increment / decrement a counter (defaults to 1)
AgonesSDK.increment_counter("rooms")
AgonesSDK.decrement_counter("rooms", 2)

# Set an absolute count or capacity
AgonesSDK.set_counter_count("rooms", 5)
AgonesSDK.set_counter_capacity("rooms", 10)

# Read a counter
var result = await AgonesSDK.get_counter("rooms")
# result[2] -> { "name": "rooms", "count": 5, "capacity": 10 }
```

## Reference

| Type | Syntax | Description |
| ---- | ---- | ----------- |
| `func`      | `.ready(retry, wait_time)` | `retry` how many times it will retry. `wait_time` time in seconds to wait between retries |
| `func` | `.health()` | Sends a health check |
| `func` | `.reserve(seconds)` | Reserve for `seconds` |
| `func` | `.allocate()` | Set GameServer as Allocated |
| `func` | `.shutdown()` | Tells Agones to shutdown server |
| `func` | `.get_counter(name)` | Get a Counter. Response `content` is `{name, count, capacity}` |
| `func` | `.increment_counter(name, amount = 1)` | Increase a Counter's count by `amount` |
| `func` | `.decrement_counter(name, amount = 1)` | Decrease a Counter's count by `amount` |
| `func` | `.set_counter_count(name, count)` | Set a Counter's count to an absolute value |
| `func` | `.set_counter_capacity(name, capacity)` | Set a Counter's maximum capacity |
| `func` | `.get_list(name)` | Get a List. Response `content` is `{name, capacity, values}` |
| `func` | `.append_list_value(name, value)` | Add `value` to a List (alias: `add_list_value`) |
| `func` | `.delete_list_value(name, value)` | Remove `value` from a List (alias: `remove_list_value`) |
| `func` | `.set_list_capacity(name, capacity)` | Set a List's maximum capacity |
| `signal` | `agones_response(success, endpoint, content)` | Emitted when SDK receives an response from Agones. `success` Boolean if response is sucessfull. `endpoint` the requested endpoint. `content` the error message or request body, usually as a Dictionary |
| `signal` | `agones_ready_failed` | Emitted when `.ready` fails all its attempts.  |

See [Agones - Client SDK](https://agones.dev/site/docs/guides/client-sdks/#function-reference) 

## Contributing

Contributions are very welcome.

## License

Distributed under the terms of the MIT license, "godot-agones-sdk" is free and open source software
