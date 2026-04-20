import AppKit
import CoreGraphics

class ImageProcessor {
    static let shared = ImageProcessor()
    
    // ==========================================
    // 1. 最近邻算法
    // ==========================================
    func scaleNearestNeighbor(image: NSImage, scaleFactor: Int) -> NSImage? {
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return nil }
        let newWidth = cgImage.width * scaleFactor
        let newHeight = cgImage.height * scaleFactor
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        
        guard let context = CGContext(
            data: nil, width: newWidth, height: newHeight,
            bitsPerComponent: 8, bytesPerRow: 0,
            space: colorSpace, bitmapInfo: bitmapInfo
        ) else { return nil }
        
        context.interpolationQuality = .none
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        guard let scaledCGImage = context.makeImage() else { return nil }
        return NSImage(cgImage: scaledCGImage, size: NSSize(width: newWidth, height: newHeight))
    }
    
    // ==========================================
    // 2. 底层像素与内存转换引擎
    // ==========================================
    private func getPixelDataAsUInt32(from cgImage: CGImage) -> (pixels: [UInt32], width: Int, height: Int)? {
        let width = cgImage.width
        let height = cgImage.height
        
        var pixelData = [UInt32](repeating: 0, count: width * height)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
        
        guard let context = CGContext(
            data: &pixelData, width: width, height: height,
            bitsPerComponent: 8, bytesPerRow: width * 4,
            space: colorSpace, bitmapInfo: bitmapInfo
        ) else { return nil }
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        return (pixelData, width, height)
    }
    
    private func createImageFromUInt32(pixels: [UInt32], width: Int, height: Int) -> NSImage? {
        var mutablePixels = pixels
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
        
        guard let context = CGContext(
            data: &mutablePixels, width: width, height: height,
            bitsPerComponent: 8, bytesPerRow: width * 4,
            space: colorSpace, bitmapInfo: bitmapInfo
        ) else { return nil }
        
        guard let cgImage = context.makeImage() else { return nil }
        return NSImage(cgImage: cgImage, size: NSSize(width: width, height: height))
    }
    
    // ==========================================
    // 3. 终极 xBRZ (C++) 算法入口
    // ==========================================
    func scaleXBR(image: NSImage, scaleFactor: Int) -> NSImage? {
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return nil }
        guard let originalData = getPixelDataAsUInt32(from: cgImage) else { return nil }
        
        let width = originalData.width
        let height = originalData.height
        let targetWidth = width * scaleFactor
        let targetHeight = height * scaleFactor
        
        var targetPixels = [UInt32](repeating: 0, count: targetWidth * targetHeight)
        
        // 呼叫 xBRZ C++ 引擎
        xBRZWrapper.scaleImage(
            withSource: originalData.pixels,
            target: &targetPixels,
            width: Int32(width),
            height: Int32(height),
            scaleFactor: Int32(scaleFactor)
        )
        
        return createImageFromUInt32(pixels: targetPixels, width: targetWidth, height: targetHeight)
    }
}
