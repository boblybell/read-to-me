// ReadToMe: Apple's own document finder for the glass screen (Bell, 1 Nov 2026, option 2).
// The web app sends a small camera picture (a JPEG data URL). Apple Vision finds the page
// and sends back its four corners, 0..1, top-left first, with y going down (like the web app).
import Foundation
import UIKit
import Vision
import Capacitor

@objc(DocScanPlugin)
public class DocScanPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "DocScanPlugin"
    public let jsName = "DocScan"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "detect", returnType: CAPPluginReturnPromise)
    ]
    private let queue = DispatchQueue(label: "readtome.docscan", qos: .userInitiated)

    @objc func detect(_ call: CAPPluginCall) {
        guard let s = call.getString("image") else { call.reject("no image"); return }
        let b64 = s.firstIndex(of: ",").map { String(s[s.index(after: $0)...]) } ?? s
        guard let data = Data(base64Encoded: b64), let img = UIImage(data: data)?.cgImage else {
            call.reject("bad image"); return
        }
        queue.async {
            let req = VNDetectDocumentSegmentationRequest()
            let handler = VNImageRequestHandler(cgImage: img, orientation: .up)
            do { try handler.perform([req]) } catch { call.reject(error.localizedDescription); return }
            guard let o = req.results?.first else { call.resolve(["found": false]); return }
            // Vision: origin at bottom-left. Web app: origin at top-left.
            func p(_ pt: CGPoint) -> [Double] { [Double(pt.x), Double(1 - pt.y)] }
            call.resolve([
                "found": true,
                "confidence": Double(o.confidence),
                "quad": [p(o.topLeft), p(o.topRight), p(o.bottomRight), p(o.bottomLeft)]
            ])
        }
    }
}
