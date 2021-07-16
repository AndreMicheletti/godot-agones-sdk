# Agones SDK for Godot
### Version 0.1.2

Welcome to the unofficial [Agones](https://agones.dev/site/) SDK for [Godot Engine](https://godotengine.org/).

[Agones](https://agones.dev/site/) is an open source, batteries-included, multiplayer dedicated game server scaling and orchestration platform that can run anywhere Kubernetes can run.

This plugin allows your Godot Scripts communicate with [Agones SDK Server](https://agones.dev/site/docs/guides/client-sdks/) by wrapping its REST API and giving you simple **GDScript** functions to use in your scripts.

> Only GDScript is supported for now

## Install

To install this plugin, go to [Releases](https://github.com/AndreMicheletti/godot-agones-sdk/releases/tag/0.1.1) and download the latest version `agones-sdk.zip`.

Inside your Godot Project folder, create a folder named `addons` and extract the zip file inside it.

After installed, your folder structure will look like this:

```
my-project/
├── addons/
|   ├── agones/
│   |    ├── agones_sdk.gd
│   |    ├── agones_wrapper.gd
│   |    ├── plugin.cfg
├── graphics/
├── sounds/
├── scenes/
├── ...
```

## Usage

## Contributing

Contributions are very welcome.

## License

Distributed under the terms of the MIT license, "godot-agones-sdk" is free and open source software