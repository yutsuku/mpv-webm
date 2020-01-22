monitor_dimensions!
mainPage = MainPage!

mp.add_key_binding(options.keybind, "display-webm-encoder", mainPage\show, {repeatable: false})

mp.add_key_binding(options.keybind_options, "display-webm-encoder-options", mainPage\changeOptions, {repeatable: false})
mp.add_key_binding(options.keybind_preview, "display-webm-encoder-preview", mainPage\preview, {repeatable: false})
mp.add_key_binding(options.keybind_encode, "display-webm-encoder-encode", mainPage\encode, {repeatable: false})
mp.add_key_binding(options.keybind_cancel, "display-webm-encoder-close", mainPage\hide, {repeatable: false})
mp.add_key_binding(options.keybind_seta, "display-webm-encoder-seta", mainPage\setStartTime, {repeatable: false})
mp.add_key_binding(options.keybind_setb, "display-webm-encoder-setb", mainPage\setEndTime, {repeatable: false})

mp.register_event("file-loaded", mainPage\setupStartAndEndTimes)