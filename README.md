# Example project for the purescript-lua

This project exists to demonstrate usage of the [PureScript compiler backend for Lua](https://github.com/purescript-lua/purescript-lua).

One possible usage of Lua scripts is within the [NGINX](https://www.nginx.com/resources/wiki/modules/lua/)
server, one can implement a backend application serving HTTP requests.

## How to build / use

The project relies on `nix` to build dependencies.

1. Initialize nix shell:

   - Using `direnv`: `direnv allow`.
   - Using `nix develop` command.

1. Nix shell makes 2 executable `./scripts` available on your path:

   - `serve` - starts Nginx and binds http://localhost:58080
   - `build` - compile PureScript sources to `web/main.lua`

1. Open one terminal for building, then execute:

```sh
$ build
Building...
PS Lua: compiling ...
Wrote linked modules to /home/yura/projects/purescript/purescript-lua/example/web/main.lua
```

1. Open other terminal for serving content with Nginx, run:

```sh
$ serve
NGINX: Listening on port 58080
nginx: [alert] lua_code_cache is off; this will hurt performance in web/conf/nginx.conf:13
2023/07/05 12:30:12 [notice] 1859398#1859398: using the "epoll" event method
2023/07/05 12:30:12 [notice] 1859398#1859398: openresty/1.21.4.1
2023/07/05 12:30:12 [notice] 1859398#1859398: built by gcc 12.3.0 (GCC)
2023/07/05 12:30:12 [notice] 1859398#1859398: OS: Linux 6.1.34
2023/07/05 12:30:12 [notice] 1859398#1859398: getrlimit(RLIMIT_NOFILE): 524288:524288
2023/07/05 12:30:12 [notice] 1859398#1859398: start worker processes
2023/07/05 12:30:12 [notice] 1859398#1859398: start worker process 1859399
```

`lua_code_cache is off` alert means that nginx isn't going to cache the lua script,
but instead will re-read it from disk upon every HTTP request, which is exactly
what we want in the development mode: it allows to re-build PS sources in the first
terminal and not to restart nginx in order to see the changes.

1. Open browser and navigate to http://localhost:58080
or use `httpie`:

```sh
http :58080
HTTP/1.1 200 OK
Connection: keep-alive
Content-Type: text/html
Date: Tue, 16 Apr 2024 07:58:23 GMT
Server: openresty/1.21.4.3
Transfer-Encoding: chunked

Hello from "PureScript/Lua"!
```

## How to run a compiled script

```sh
lua -e 'dofile("web/main.lua")'
```

but it will fail when using Nginx as there is no global variable `ngx` which
is only defined when script is executed by nginx:

```
lua: web/main.lua:208: attempt to index a nil value (global 'ngx')
stack traceback:
        web/main.lua:208: in function <web/main.lua:206>
        web/main.lua:206: in main chunk
        [C]: in function 'dofile'
        (command line):1: in main chunk
        [C]: in ?
```
