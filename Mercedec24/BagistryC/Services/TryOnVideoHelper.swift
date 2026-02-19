import AVFoundation
import UIKit

enum TryOnVideoHelper {
    private static let frameRate: Int32 = 15
    private static let timescale: Int32 = 600
    
    static func makeVideo(from image: UIImage, durationSeconds: Int) -> URL? {
        let seconds = max(1, min(durationSeconds, 60))
        let size = image.size
        let frameCount = seconds * Int(frameRate)
        
        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("tryon_\(UUID().uuidString).mp4")
        
        do {
            let writer = try AVAssetWriter(outputURL: tempURL, fileType: .mp4)
            
            let videoSettings: [String: Any] = [
                AVVideoCodecKey: AVVideoCodecType.h264,
                AVVideoWidthKey: size.width,
                AVVideoHeightKey: size.height,
                AVVideoCompressionPropertiesKey: [
                    AVVideoAverageBitRateKey: 2_000_000
                ]
            ]
            
            let input = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
            input.expectsMediaDataInRealTime = false
            
            let sourcePixelBufferAttributes: [String: Any] = [
                kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA
            ]
            let adaptor = AVAssetWriterInputPixelBufferAdaptor(
                assetWriterInput: input,
                sourcePixelBufferAttributes: sourcePixelBufferAttributes
            )
            
            writer.add(input)
            writer.startWriting()
            writer.startSession(atSourceTime: .zero)
            
            guard let pixelBufferPool = adaptor.pixelBufferPool else {
                try? FileManager.default.removeItem(at: tempURL)
                return nil
            }
            
            var frameIndex: Int64 = 0
            
            for _ in 0..<frameCount {
                while !input.isReadyForMoreMediaData {
                    Thread.sleep(forTimeInterval: 0.01)
                }
                
                let presentationTime = CMTime(value: frameIndex, timescale: frameRate)
                guard let pixelBuffer = createPixelBuffer(from: image, pool: pixelBufferPool, size: size) else {
                    continue
                }
                adaptor.append(pixelBuffer, withPresentationTime: presentationTime)
                frameIndex += 1
            }
            
            input.markAsFinished()
            let semaphore = DispatchSemaphore(value: 0)
            var didComplete = false
            writer.finishWriting(completionHandler: {
                didComplete = true
                semaphore.signal()
            })
            semaphore.wait()
            
            guard writer.status == .completed else {
                try? FileManager.default.removeItem(at: tempURL)
                return nil
            }
            return tempURL
        } catch {
            try? FileManager.default.removeItem(at: tempURL)
            return nil
        }
    }
    
    private static func createPixelBuffer(from image: UIImage, pool: CVPixelBufferPool, size: CGSize) -> CVPixelBuffer? {
        var pixelBuffer: CVPixelBuffer?
        CVPixelBufferPoolCreatePixelBuffer(nil, pool, &pixelBuffer)
        guard let buffer = pixelBuffer else { return nil }
        
        CVPixelBufferLockBaseAddress(buffer, [])
        defer { CVPixelBufferUnlockBaseAddress(buffer, []) }
        
        let context = CGContext(
            data: CVPixelBufferGetBaseAddress(buffer),
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: 8,
            bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue
        )
        
        guard let cgImage = image.cgImage, let ctx = context else { return nil }
        ctx.translateBy(x: 0, y: size.height)
        ctx.scaleBy(x: 1, y: -1)
        ctx.draw(cgImage, in: CGRect(origin: .zero, size: size))
        return buffer
    }
}
