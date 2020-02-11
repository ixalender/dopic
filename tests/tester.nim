import os
import dopic
import unittest
import stb_image/read as stbi

suite "Resize tests":
    test "Resize JPG to small":
        let
            w  = 447
            h = 667
            wB = 1340
            hB = 2000
            smallOutFile = "./tests/testdata/mona.small.jpg"
            bigOutFile = "./tests/testdata/mona.big.jpg"

        dopic.resizeImage(
            "./tests/testdata/mona.jpg",
            smallOutFile,
            ImageFormats.JPG,
            w, h
        )

        var testWidth, testHeight, testChannels: int
        discard stbi.load(smallOutFile, testWidth, testHeight, testChannels, stbi.RGB)
        
        check w == testWidth
        check h == testHeight
        check testChannels == stbi.RGB

        dopic.resizeImage(
            "./tests/testdata/mona.jpg",
            bigOutFile,
            ImageFormats.JPG,
            wB, hB
        )

        discard stbi.load(bigOutFile, testWidth, testHeight, testChannels, stbi.RGB)

        check wB == testWidth
        check hB == testHeight
        check testChannels == stbi.RGB

        os.removeFile(smallOutFile)
        os.removeFile(bigOutFile)

    
    test "Resize PNG to small":
        let 
            w, h = 300
            wB, hB = 900
            smallOutFile = "./tests/testdata/vitruvian-man.small.png"
            bigOutFile = "./tests/testdata/vitruvian-man.big.png"

        dopic.resizeImage(
            "./tests/testdata/vitruvian-man.png",
            smallOutFile,
            ImageFormats.PNG,
            w, h
        )

        var testWidth, testHeight, testChannels: int
        discard stbi.load(smallOutFile, testWidth, testHeight, testChannels, stbi.RGBA)
        
        check w == testWidth
        check h == testHeight
        check testChannels == stbi.RGBA

        dopic.resizeImage(
            "./tests/testdata/vitruvian-man.png",
            bigOutFile,
            ImageFormats.PNG,
            wB, hB
        )

        discard stbi.load(bigOutFile, testWidth, testHeight, testChannels, stbi.RGBA)

        check wB == testWidth
        check hB == testHeight
        check testChannels == stbi.RGBA

        os.removeFile(smallOutFile)
        os.removeFile(bigOutFile)
