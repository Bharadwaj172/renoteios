//
//  QRScanView.swift
//  TreeFreeNote
//
//  Created by Bhargavi on 05/10/23.
//

import SwiftUI
import AVFoundation
import SafariServices

struct QRCodeScannerView: View {
    @Binding var isTabViewShown: Bool
    @Binding var isShowingBottomSheet: Bool
    @Binding var bottomSheetContentType: BottomSheetType
    @Binding var selectedTab: String
    
    var body: some View {
        // Create a QR code scanner view
        VStack {
            HStack {
                Button(action: {
                    selectedTab = "Home"
                }, label: {
                    Text("Cancel")
                })
                Spacer()
            }
            .padding(10)
            QRCodeScanner()
        }
        .onAppear{
            isTabViewShown = false
        }
        .onDisappear{
            isTabViewShown.toggle()
        }
        .navigationBarHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct QRCodeScanner: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<QRCodeScanner>) -> UIViewController {
        // Create a QR code scanner
        let scannerViewController = QRCodeScannerViewController()
        return scannerViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<QRCodeScanner>) {
        // Update the view controller
        print(context)
    }
}

class QRCodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    // Set up the camera and capture session
    let captureSession = AVCaptureSession()
    var videoPreviewLayer : AVCaptureVideoPreviewLayer? //(session: captureSession)
    
    init() {
        super.init(nibName: nil, bundle: nil)
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the capture session
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        let input = try? AVCaptureDeviceInput(device: captureDevice!)
        captureSession.addInput(input!)
        
        // Set up the metadata output
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureMetadataOutput)
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        
        // Start the capture session
        if let videoPreviewLayer = self.videoPreviewLayer {
            videoPreviewLayer.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer)
        }
        captureSession.startRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadata object contains a QR code
        if metadataObjects.count == 0 {
            return
        }
        
        // Get the first metadata object
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        // Check if the QR code contains a valid URL
        if metadataObj.type == AVMetadataObject.ObjectType.qr, let urlString = metadataObj.stringValue, let url = URL(string: urlString) {
            // Handle the valid URL
            print(url)
            let browser = SFSafariViewController(url: url)
            present(browser, animated: true, completion: nil)

        }
    }
}
