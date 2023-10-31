# Run redis server

```
nix run
```

From Github

```
nix run github:frisoft/flake-redis
```

# Stop the server

```
nix run .#stop
```

From Github

```
nix run github:frisoft/flake-redis#stop
```

# Reset the DB

Before starting the server:

```
rm -f dump.rdb
```

