worlds["survival"] = "/srv/minecraft/world"

renders["overworld"] = {
    "world": "survival",
    "title": "Overworld",
    "rendermode": smooth_lighting,
    "dimension": "overworld",
}

renders["nether"] = {
    "world": "survival",
    "title": "Nether",
    "rendermode": nether_smooth_lighting,
    "dimension": "nether",
}

renders['biomeoverlay'] = {
    'world': 'survival',
    'rendermode': [ClearBase(), BiomeOverlay()],
    'title': "Overworld Biomes",
    "dimension": "overworld",
    'overlay': ['overworld']
}

outputdir = "/var/mcmap"
texturepath = "/tmp/texture.jar"