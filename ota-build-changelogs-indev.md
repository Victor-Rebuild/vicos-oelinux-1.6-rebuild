# Indev ota changelogs
## https://modder.my.to/otas/1.6-rebuild/indev/
## If you want to use 1.6-rebuild do NOT use these images, use the release ones instead

## 1.6.1.0004 (2025/08/19)
Actually make the new different ramposts apply, don't clean anki every rebuild since cmake should be able to figure out what it needs to recompile should it have to happen

## 1.6.1.0003 (2025/08/18)
Add a seperate proddev bitbake option, use different ramposts to confirm that we can have build specific ramposts

## 1.6.1.0002 (2025/08/18)
Fixed the prod boot images so that they boot again, add new 1.6-rebuild rampost images

## 1.6.1.0001 (2025/08/18)
Wired works fully works, PicoVoice wakeword training works, changed OSKR messages to ankidevunit

## 1.6.1.0000 (2025/08/16)
Dev only, first ota run, basically plain vicos-oelinux-nosign but with 1.6 anki