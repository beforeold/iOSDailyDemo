//
//  ActionViewController.swift
//  MyAction
//
//  Created by BrookXy on 2022/6/2.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
import Vision
import QuickLook

class ActionViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Get the item[s] we're handling from the extension context.
        
        // For example, look for an image and place it into an image view.
        // Replace this with something appropriate for the type[s] your extension supports.
        var imageFound = false
        for item in self.extensionContext!.inputItems as! [NSExtensionItem] {
            for provider in item.attachments! {
                if provider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                    // This is an image. We'll load it, then place it in our image view.
                    weak var weakImageView = self.imageView
                    provider.loadItem(forTypeIdentifier: UTType.image.identifier, options: nil, completionHandler: { (imageURL, error) in
                        OperationQueue.main.addOperation {
                            if let strongImageView = weakImageView {
                                if let imageURL = imageURL as? URL {
                                    strongImageView.image = UIImage(data: try! Data(contentsOf: imageURL))
                                }
                            }
                        }
                    })
                    
                    imageFound = true
                    break
                }
            }
            
            if (imageFound) {
                // We only handle one image, so stop looking for more.
                break
            }
        }
        
        imageView.isUserInteractionEnabled = true
//
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        imageView.addGestureRecognizer(tap)
    }
    
    @objc func onTap() {
        
        struct Cache {
            static var count = 0
        }
        
        Cache.count += 1
        
        if Cache.count % 2 == 0 {
            self.extensionContext?.cancelRequest(withError: NSError(domain: "", code: 5, userInfo: nil))
            return
        }
        
//        let detect = CIDetector(ofType: CIDetectorTypeText, context: nil, options: nil)!
//        if let uiImage = imageView.image {
//            if let ciImage = CIImage(image: uiImage) {
//                let features = detect.features(in: ciImage)
//                print(features)
//            }
//        }
//
        // Get the CGImage on which to perform requests.
        guard let cgImage = imageView.image?.cgImage else { return }

        // Create a new image-request handler.
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)

        // Create a new request to recognize text.
        let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)
        request.recognitionLanguages = ["en", "zh"]
        request.recognitionLevel = .accurate
        request.customWords = ["https://"]

        do {
            // Perform the text-recognition request.
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the requests: \(error).")
        }
        
        
        return
        

    }
    
    func openUrl(url: URL?) {
        let selector = sel_registerName("openURL:")
        var responder = self as UIResponder?
        while let r = responder, !r.responds(to: selector) {
            responder = r.next
        }
        _ = responder?.perform(selector, with: url)
    }

    func canOpenUrl(url: URL?) -> Bool {
        let selector = sel_registerName("canOpenURL:")
        var responder = self as UIResponder?
        while let r = responder, !r.responds(to: selector) {
            responder = r.next
        }
        return (responder!.perform(selector, with: url) != nil)
    }
    
    func recognizeTextHandler(request: VNRequest, error: Error?) {
        guard let observations =
                request.results as? [VNRecognizedTextObservation] else {
            return
        }
        let recognizedStrings = observations.compactMap { observation -> String? in
            // Return the string of the top VNRecognizedText instance.
            let all = observation.topCandidates(100)
            print("all -", all)
            return all.first?.string
        }
        
        // Process the recognized strings.
        processResults(recognizedStrings)
        
        openUrl(url: URL(string: "https://www.apple.com"))
        
        
        
    }
    
    func processResults(_ recognizedStrings: [String]) {
        print(recognizedStrings)
    }
    
//    func processResults(_ string: String) {
//        let boundingRects: [CGRect] = observations.compactMap { observation in
//
//            // Find the top observation.
//            guard let candidate = observation.topCandidates(1).first else { return .zero }
//
//            // Find the bounding-box observation for the string range.
//            let stringRange = candidate.string.startIndex..<candidate.string.endIndex
//            let boxObservation = try? candidate.boundingBox(for: stringRange)
//
//            // Get the normalized CGRect value.
//            let boundingBox = boxObservation?.boundingBox ?? .zero
//
//            // Convert the rectangle from normalized coordinates to image coordinates.
//            return VNImageRectForNormalizedRect(boundingBox,
//                                                Int(image.size.width),
//                                                Int(image.size.height))
//        }
//    }

    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }

}
