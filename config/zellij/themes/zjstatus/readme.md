# Usage

The best and concise way to use a plugin is to declare it as an alias in 'config.kdl' and
 then use the alias in your layout file.

**config.kdl**
```kdl
plugins {

    zjstatus location="file:~/.local/share/zellij/plugins/zjstatus.wasm" {
        format_left   "#[bg=#313244,fg=#eba0ac]#[bg=#eba0ac,fg=#181926,bold] {session} {mode}#[bg=#282828] {tabs}"
        format_center "{notifications}"
        <snip>
    }
}
```
and then use the alias `zjstatus` in the layout
**terminal.kdl**
```kdl
layout {
    pane
    pane size=2 borderless=true {
        plugin location="zjstatus"
    }
}
```

