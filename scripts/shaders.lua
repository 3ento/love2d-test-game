moonshine = require 'lib/moonshine-master'

function setUpShaders()
    effect = moonshine(moonshine.effects.desaturate).chain(moonshine.effects.vignette)
    effect.desaturate.tint = {17, 17, 132}
    effect.desaturate.strength = 0.7
    effect.vignette.radius = 0.5

    glow = moonshine(moonshine.effects.pixelate)
    glow.min_luma = 0.3
end