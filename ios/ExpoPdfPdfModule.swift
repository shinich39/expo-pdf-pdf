import ExpoModulesCore
import PDFKit
import AVFoundation

enum ModuleError: Error {
    case ERROR
    case SOURCE
    case DESTINATION
    case PASSWORD
    case COMPRESS_NOT_SUPPORTED
}

extension ModuleError: LocalizedError {
    public var errorDescription: String? {
        switch self {
            case .ERROR:
                return NSLocalizedString("An error occurred", comment: "")
            case .SOURCE:
                return NSLocalizedString("An error occurred", comment: "")
            case .DESTINATION:
                return NSLocalizedString("An error occurred", comment: "")
            case .PASSWORD:
                return NSLocalizedString("An archive has been encrypted", comment: "")
            case .COMPRESS_NOT_SUPPORTED:
                return NSLocalizedString("Does not support PDF compression", comment: "")
        }
    }
}

func getDirPath(
    _ dirPath: String
) -> String? {
    guard let url = NSURL(fileURLWithPath: dirPath).appendingPathComponent(UUID().uuidString, isDirectory: true) else {
        return nil
    }

    do {
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        return url.path
    } catch {
        return nil
    }
}

func getFilePath(
    _ dirPath: String,
    _ ext: String
) -> String? {
    guard let url = NSURL(fileURLWithPath: dirPath).appendingPathComponent(UUID().uuidString + ext) else {
        return nil
    }
    
    return url.path
}

func encode(
  _ str: String
) -> String? {
    return str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
}

func uncompress(
    _ pdfPath: String
) throws -> String {
    guard let srcPath = encode(pdfPath) else {
        throw ModuleError.SOURCE
    }

    guard let dstPath = getDirPath(NSTemporaryDirectory()) else {
        throw ModuleError.DESTINATION
    }

    guard let srcUrl = NSURL(string: "file://\(srcPath)") else {
        throw ModuleError.SOURCE
    }

    guard let pdfDocument = PDFDocument(url: srcUrl as URL) else {
        throw ModuleError.SOURCE
    }
    
    for pageNum in 0..<pdfDocument.pageCount {
        do {
            guard let page = pdfDocument.page(at: pageNum) else {
                throw ModuleError.DESTINATION
            }
            
            guard let fileUrl = NSURL(string: "file://\(dstPath)/\(pageNum).png") else {
                throw ModuleError.DESTINATION
            }
            
            let bounds = page.bounds(for: .mediaBox)
            let origSize = CGSize(width: bounds.width, height: bounds.height)
            let maxSize = CGRect(x: 0, y: 0, width: 2560, height: 2560)
            let size = AVMakeRect(aspectRatio: origSize, insideRect: maxSize).size
            
            let image = page.thumbnail(
                of: size,
                for: .mediaBox
            )
            
            guard let data = image.pngData() else {
                throw ModuleError.ERROR
            }
            
            try data.write(to: fileUrl as URL)
        } catch {
            continue
        }
    }
    
    return dstPath
}

func compress(
    _ dirPath: String
) throws -> String {
    throw ModuleError.COMPRESS_NOT_SUPPORTED
}

public class ExpoPdfPdfModule: Module {
  // Each module class must implement the definition function. The definition consists of components
  // that describes the module's functionality and behavior.
  // See https://docs.expo.dev/modules/module-api for more details about available components.
  public func definition() -> ModuleDefinition {
    // Sets the name of the module that JavaScript code will use to refer to the module. Takes a string as an argument.
    // Can be inferred from module's class name, but it's recommended to set it explicitly for clarity.
    // The module will be accessible from `requireNativeModule('ExpoPdfPdf')` in JavaScript.
    Name("ExpoPdfPdf")

    Function("compress") { (sourcePath: String) throws -> String in
      return try compress(sourcePath)
    }

    Function("uncompress") { (sourcePath: String) throws -> String in
      return try uncompress(sourcePath)
    }
  }
}
