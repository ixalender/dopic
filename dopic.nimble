# Package

version       = "0.1.0"
author        = "Alexander Nekrasov"
description   = "A new awesome nimble package"
license       = "MIT"
srcDir        = "src"
bin           = @["dopic"]
skipDirs      = @["tests"]

# Dependencies

requires "nim >= 1.0.2"
requires "stb_image"
requires "cligen"
