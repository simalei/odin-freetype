# FreeType for Odin

Odin bindings for FreeType 2.14.3, generated using [odin-c-bindgen](https://github.com/karl-zylinski/odin-c-bindgen).

> [!NOTE]
> In order to use the bindings in your program, you will only need `*.odin` files and the folder that contains binaries for your OS/arch configuration (i.e. `windows_amd64`).
>
> You will only need the rest of the files if you are planning to generate bindings yourself.

# Generating bindings
Setup `odin-c-bindgen` as described [here](https://github.com/karl-zylinski/odin-c-bindgen#requirements).
Then run 
```
bindgen .
``` 
in the root of cloned repo.
