hl.layer_rule({
    match = { namespace = "^(quickshell.*)$" },
    blur = true,
    blur_popups = true,
    ignore_alpha = 0.1,
    no_anim = true
})

hl.layer_rule({
    match = { namespace = "^(quickshell.*-xray.*)$"},
    xray = true
})