//
//  FingerDetectService.swift
//  pm-ios
//
//  Created by Synbrix Software on 1/20/20.
//  Copyright © 2020 Synbrix Software. All rights reserved.
//

import Foundation
import AVFoundation
import Accelerate.vImage

protocol FingerDetectService {
    func detect(pixelBuffer: CVImageBuffer) -> Double?
}

class FingerDetectAPIService {
    
    // MARK: - Dependencies -
    private let localCache: LocalCache
    
    // MARK: - Properties -
    private let intensities: [Double] = Array(0...255).map { Double($0) }
    private var samples: [Double] = []
    public var destinationBuffer = vImage_Buffer()
    private var converter: vImageConverter?
    private var sourceBuffers = [vImage_Buffer]()
    private var cgImageFormat = vImage_CGImageFormat(
        bitsPerComponent: 8,
        bitsPerPixel: 32,
        colorSpace: nil,
        bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipFirst.rawValue),
        version: 0,
        decode: nil,
        renderingIntent: .defaultIntent
    )
    private var sensitivity: Double {
        return localCache.cameraSensitivity
    }
    
    init(localCache: LocalCache) {
        self.localCache = localCache
    }
    
    deinit {
        free(destinationBuffer.data)
    }

}

// MARK: - API
extension FingerDetectAPIService: FingerDetectService {
    
    func detect(pixelBuffer: CVImageBuffer) -> Double? {
        log.verbose("Running finger detection")
        configureBuffers(pixelBuffer: pixelBuffer)
        if let redness = calculateAverageRedIntensity(indexes: intensities, outputBuffer: &destinationBuffer) {
            if redness > sensitivity {
                return redness
            }
        }
        return nil
    }

    private func configureBuffers(pixelBuffer: CVImageBuffer) {
        var error = setUpConverter(pixelBuffer: pixelBuffer)
        guard error == kvImageNoError else { return }
        error = setUpSourceBuffers(pixelBuffer: pixelBuffer)
        guard error == kvImageNoError else { return }
        error = setUpDestinationBuffer(pixelBuffer: pixelBuffer)
        guard error == kvImageNoError else { return }
    }
        
    private func calculateAverageRedIntensity(indexes: [Double], outputBuffer: inout vImage_Buffer) -> Double? {
        // Create buffers to store ARGB values from current frame
        var alphaBin = [vImagePixelCount](repeating: 0, count: 256)
        var redBin = [vImagePixelCount](repeating: 0, count: 256)
        var greenBin = [vImagePixelCount](repeating: 0, count: 256)
        var blueBin = [vImagePixelCount](repeating: 0, count: 256)
        
        // Establish pointers to buffers
        // Ugly nesting is an artifact of archaic C support in Swift, pointers only valid at initialization
        let error = alphaBin.withUnsafeMutableBufferPointer { alphaPtr -> vImage_Error in
            let error = redBin.withUnsafeMutableBufferPointer { redPtr -> vImage_Error in
                let error = greenBin.withUnsafeMutableBufferPointer { greenPtr -> vImage_Error in
                    let error = blueBin.withUnsafeMutableBufferPointer { bluePtr -> vImage_Error in
                        var histogramBins = [alphaPtr.baseAddress, redPtr.baseAddress, greenPtr.baseAddress, bluePtr.baseAddress]
                        let error = histogramBins.withUnsafeMutableBufferPointer { histogramBinsPtr in
                            return vImageHistogramCalculation_ARGB8888(&outputBuffer, histogramBinsPtr.baseAddress!, vImage_Flags(kvImageNoFlags))
                        }
                        return error
                    }
                    return error
                }
                return error
            }
            return error
        }
        // If something goes wrong we return nil for the current frame
        guard error == kvImageNoError else {
            #if DEBUG
                log.error("Failed to calculate image histogram.")
            #endif
            return nil
        }
        
        // Create buffer to store result value
        var result = [Double](repeating: 0.0, count: 256)
        
        // Multiply red channel pixel intensity counts by their index to calculate numerator addends for averaging
        vDSP_vmulD(indexes, 1, redBin.map { Double($0) }, 1, &result, 1, vDSP_Length(indexes.count))
        
        // Calculate average red intensity across red channel
        let total = result.reduce(0, +)
        let avg = total/Double(redBin.count)
        return avg
    }
        
    private func setUpConverter(pixelBuffer: CVPixelBuffer) -> vImage_Error {
        var error = kvImageNoError
        
        if converter == nil {
            let cvImageFormat = vImageCVImageFormat_CreateWithCVPixelBuffer(pixelBuffer).takeRetainedValue()
            
            vImageCVImageFormat_SetColorSpace(cvImageFormat,
                                              CGColorSpaceCreateDeviceRGB())
            
            vImageCVImageFormat_SetChromaSiting(cvImageFormat,
                                                kCVImageBufferChromaLocation_Center)
            
            guard let unmanagedConverter = vImageConverter_CreateForCVToCGImageFormat(cvImageFormat, &cgImageFormat, nil, vImage_Flags(kvImagePrintDiagnosticsToConsole), &error), error == kvImageNoError else {
                print("vImageConverter_CreateForCVToCGImageFormat error:", error)
                return error
            }
            converter = unmanagedConverter.takeRetainedValue()
        }
        return error
    }
    
    private func setUpSourceBuffers(pixelBuffer: CVPixelBuffer) -> vImage_Error {
        var error = kvImageNoError
        if sourceBuffers.isEmpty {
            let numberOfSourceBuffers = Int(vImageConverter_GetNumberOfSourceBuffers(converter!))
            sourceBuffers = [vImage_Buffer](repeating: vImage_Buffer(), count: numberOfSourceBuffers)
        }
        error = vImageBuffer_InitForCopyFromCVPixelBuffer(
            &sourceBuffers,
            converter!,
            pixelBuffer,
            vImage_Flags(kvImageNoAllocate))
        return error
    }
    
    private func setUpDestinationBuffer(pixelBuffer: CVPixelBuffer) -> vImage_Error {
        var error = kvImageNoError
        if destinationBuffer.data == nil {
            error = vImageBuffer_Init(&destinationBuffer,
                                      UInt(CVPixelBufferGetHeightOfPlane(pixelBuffer, 0)),
                                      UInt(CVPixelBufferGetWidthOfPlane(pixelBuffer, 0)),
                                      cgImageFormat.bitsPerPixel,
                                      vImage_Flags(kvImageNoFlags))
            
            guard error == kvImageNoError else {
                return error
            }
        }
        
        error = vImageConvert_AnyToAny(converter!,
                                       &sourceBuffers,
                                       &destinationBuffer,
                                       nil,
                                       vImage_Flags(kvImageNoFlags))
        
        return error
    }
    
}
