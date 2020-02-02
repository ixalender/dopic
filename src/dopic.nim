import os
import sugar
import cligen
import sequtils
import stb_image/read as stbi
import stb_image/write as stbiw

type
    ImageFormats* {.pure.} = enum
        PNG, JPG

    Pixel* = ref object
        r, g, b, a: byte

    Image* = ref object
        data: seq[Pixel]
        width, height: int
    
    Point* = ref object
        x, y: int


proc newPixel(rgbSeq: seq[byte]): Pixel =
    result = new(Pixel)
    result.r = rgbSeq[0]
    result.g = rgbSeq[1]
    result.b = rgbSeq[2]
    result.a = 0
    if rgbSeq.len > 3:
        result.a = rgbSeq[3]


proc chunks[T, R](s: seq[T], n: int, fun: proc (s: seq[T]): R): seq[R] =
    let disted = s.distribute(int(s.len / n), false)
    result = disted.map(proc (ts: seq[T]): R = fun(ts))


proc flatten[T, R](s: seq[T], fun: proc (t: T): seq[R]): seq[R] =
    result = newSeq[R]()
    for p in s:
        result.add(fun(p))


proc newImage(data: seq[byte], w, h: int, components: int = 3): Image =
    result = new(Image)
    result.width = w
    result.height = h
    result.data = chunks(
        data,
        components,
        proc (s: seq[byte]): Pixel = newPixel(s)
    )


proc newImage(data: seq[Pixel], w, h: int, components: int = 3): Image =
    result = new(Image)
    result.width = w
    result.height = h
    result.data = data


proc newPoint(x, y: int): Point =
    result = new(Point)
    result.x = x
    result.y = y


proc changeSize(image: Image, toW, toH: int): Image =
    result = newImage(newSeq[Pixel](toW * toH), toW, toH)
    
    let xRatio = (image.width shl 16) div toW
    let yRatio = (image.height shl 16) div toH
    let data: seq[Pixel] = image.data
    let imgWidth: int = image.width

    for hPix in 0..pred(toH):
        for wPix in 0..pred(toW):
            let y = ((hPix * yRatio) shr 16) * imgWidth
            let h = hPix * toW
            let x = (wPix * xRatio) shr 16

            result.data[wPix + h] = data[x + y]


proc insertTo(subjImage: Image, destImage: Image, destPoint: Point) =
    let data: seq[Pixel] = subjImage.data
    var widthDelta: int = destPoint.y * destImage.width 

    for hIdx in 0..pred(subjImage.height):
        for wIdx in 0..pred(subjImage.width):
            let y = hIdx * subjImage.width
            if wIdx + destPoint.x < destImage.width and
                    wIdx + destPoint.x > 0 and 
                    destPoint.y + hIdx < destImage.height and
                    destPoint.y + hIdx > 0:
                destImage.data[wIdx + y + widthDelta + destPoint.x] = data[wIdx + y]
        widthDelta += (destImage.width - subjImage.width)


proc matchChannel(format: ImageFormats): int =
    if format == ImageFormats.JPG:
        stbi.RGB
    elif format == ImageFormats.PNG:
        stbi.RGBA
    else:
        stbi.Default


proc saveFile(format: ImageFormats, image: Image, file: string) =
    if format == ImageFormats.PNG:
        stbiw.writePNG(file, image.width, image.height, stbi.RGBA, flatten(
            image.data,
            proc (p: Pixel): seq[byte] =
                @[p.r, p.g, p.b, p.a]
            )
        )
    else:
        stbiw.writeJPG(file, image.width, image.height, stbi.RGB, flatten(
                image.data,
                proc (p: Pixel): seq[byte] =
                    @[p.r, p.g, p.b]
            ),
            100
        )


proc resizeImage(
    file: string,
    output: string,
    format: ImageFormats,
    width, height: int,
    verb=false
) =
    var fileWidth, fileHeight, fileChannels: int

    let desiredChannel = matchChannel(format)
    let data = stbi.load(file, fileWidth, fileHeight, fileChannels, desiredChannel)
    let image: Image = newImage(data, fileWidth, fileHeight, desiredChannel)
    let resizedImage: Image = image.changeSize(width, height)

    saveFile(format, resizedImage, output)
        

proc insertImage(
    file: string,
    dest: string,
    output: string,
    format: ImageFormats,
    x, y: int,
    verb=false
) =
    var
        srcWidth, srcHeight, srcChannels: int
        destWidth, destHeight, destChannels: int

    let desiredChannel = matchChannel(format)
    let srcData = stbi.load(file, srcWidth, srcHeight, srcChannels, desiredChannel)
    let destData = stbi.load(dest, destWidth, destHeight, destChannels, desiredChannel)
    let srcImage: Image = newImage(srcData, srcWidth, srcHeight, desiredChannel)
    let destImage: Image = newImage(destData, destWidth, destHeight, desiredChannel)

    srcImage.insertTo(destImage, newPoint(x, y))
    saveFile(format, destImage, output)


when isMainModule:
    dispatchMulti(
        [resizeImage, cmdName="resize", doc="resize an image", help={
            "file": "source image file",
            "output": "output image file",
            "format": "image format",
            "width": "desirable image width",
            "height": "desirable image height"
        }],
        [insertImage, cmdName="insert", doc="insert an image to another image", help={
            "file": "source image file",
            "dest": "destination image file",
            "output": "output image file",
            "format": "image format",
            "x": "X location of insertable image",
            "y": "Y location of insertable image"
        }]
    )