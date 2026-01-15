import Foundation

protocol QRScannerDelegate: AnyObject {
    func didFind(code: String)
}
