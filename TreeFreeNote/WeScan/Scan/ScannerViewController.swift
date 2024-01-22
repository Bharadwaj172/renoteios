//
//  ScannerViewController.swift
//  WeScan
//
//  Created by Boris Emorine on 2/8/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//
//  swiftlint:disable line_length

import AVFoundation
import UIKit
import SwiftUI

/// Camera functions Array
enum SacnnerViewButtonType: String, CaseIterable {
    case Back = "Back"
    case CameraFlip = "CameraFlip"
    case Flash = "Flash"
    case gridView = "gridView"
}

/// The `ScannerViewController` offers an interface to give feedback to the user regarding quadrilaterals that are detected. It also gives the user the opportunity to capture an image with a detected rectangle.
public final class ScannerViewController: UIViewController {
    public var documentViewModel : DocumentsViewModel

    private var captureSessionManager: CaptureSessionManager?
    private let videoPreviewLayer = AVCaptureVideoPreviewLayer()

    /// The view that shows the focus rectangle (when the user taps to focus, similar to the Camera app)
    private var focusRectangle: FocusRectangleView!

    /// The view that draws the detected rectangles.
    private let quadView = QuadrilateralView()

    /// Whether flash is enabled
    private var flashEnabled = false

    /// The original bar style that was set by the host app
    private var originalBarStyle: UIBarStyle?

    private var capturedImages: [UIImage]?
    private lazy var shutterButton: ShutterButton = {
        let button = ShutterButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(captureImage(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var autoScanButton: UIButton = {
        let image = UIImage(named: "ManualScan")
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(toggleAutoScan), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()

    private lazy var previewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.isOpaque = true
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var saveButton: UIButton = {
        let image = UIImage(named: "TickIcon")
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    private lazy var optionsScrollView: UIScrollView = {
        return addCameraOptionsScrollView()
    }()
    
    private var flashButton: UIButton?
    
    var currentCamera: AVCaptureDevice?

    // MARK: - Life Cycle

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "didImageCaptured"), object: nil)
    }
    
    public init(documentViewModel: DocumentsViewModel) {
        self.documentViewModel = documentViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        title = nil
        view.backgroundColor = UIColor.black

        setupViews()
        setupConstraints()

        captureSessionManager = CaptureSessionManager(videoPreviewLayer: videoPreviewLayer, delegate: self)

        CaptureSession.current.isAutoScanEnabled = false
        originalBarStyle = navigationController?.navigationBar.barStyle

        NotificationCenter.default.addObserver(self, selector: #selector(subjectAreaDidChange), name: Notification.Name.AVCaptureDeviceSubjectAreaDidChange, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceivedCapturedImage), name:
                                                Notification.Name(rawValue: "didImageCaptured"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(cancelImageScannerController), name: Notification.Name(rawValue: "didDismissOnSaving"), object: nil)
        
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()

        self.navigationController?.navigationBar.isHidden = true
        CaptureSession.current.isEditing = false
        quadView.removeQuadrilateral()
        captureSessionManager?.start()
        UIApplication.shared.isIdleTimerDisabled = true

    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        videoPreviewLayer.frame = view.layer.bounds
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isIdleTimerDisabled = false

        captureSessionManager?.stop()
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        if device.torchMode == .on {
            let _ = CaptureSession.current.toggleFlash()
        }
        flashButton?.setImage(UIImage(named: "FlashOff"), for: .normal)
    }

    // MARK: - Setups

    private func setupViews() {
        view.backgroundColor = .darkGray
        view.layer.addSublayer(videoPreviewLayer)
        quadView.translatesAutoresizingMaskIntoConstraints = false
        quadView.editable = false
        view.addSubview(quadView)
        view.addSubview(autoScanButton)
        view.addSubview(shutterButton)
        view.addSubview(activityIndicator)
        view.addSubview(optionsScrollView)
        view.addSubview(previewImageView)
        view.addSubview(saveButton)
    }

    // MARK: - Tap to Focus

    /// Called when the AVCaptureDevice detects that the subject area has changed significantly. When it's called, we reset the focus so the camera is no longer out of focus.
    @objc private func subjectAreaDidChange() {
        /// Reset the focus and exposure back to automatic
        do {
            try CaptureSession.current.resetFocusToAuto()
        } catch {
            let error = ImageScannerControllerError.inputDevice
            guard let captureSessionManager else { return }
            captureSessionManager.delegate?.captureSessionManager(captureSessionManager, didFailWithError: error)
            return
        }

        /// Remove the focus rectangle if one exists
        CaptureSession.current.removeFocusRectangleIfNeeded(focusRectangle, animated: true)
    }

    @objc private func didReceivedCapturedImage(notifiaction: Notification) {
        if self.capturedImages == nil {
            self.capturedImages = [UIImage]()
        }
        
        if let capturedImage = notifiaction.userInfo?["image"] as? UIImage {
            self.capturedImages?.append(capturedImage)
            DispatchQueue.main.async {
                self.previewImageView.image = capturedImage
            }
        }
    }
    
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        guard  let touch = touches.first else { return }
        let touchPoint = touch.location(in: view)
        let convertedTouchPoint: CGPoint = videoPreviewLayer.captureDevicePointConverted(fromLayerPoint: touchPoint)

        CaptureSession.current.removeFocusRectangleIfNeeded(focusRectangle, animated: false)

        focusRectangle = FocusRectangleView(touchPoint: touchPoint)
        view.addSubview(focusRectangle)

        do {
            try CaptureSession.current.setFocusPointToTapPoint(convertedTouchPoint)
        } catch {
            let error = ImageScannerControllerError.inputDevice
            guard let captureSessionManager else { return }
            captureSessionManager.delegate?.captureSessionManager(captureSessionManager, didFailWithError: error)
            return
        }
    }

}

    //Actions
extension ScannerViewController {
    
    @objc private func cameraOptionsbuttonTapped(_ sender: UIButton) {
        // Handle button tap here
        if let buttonTag = sender.accessibilityIdentifier {
            print("Button tapped: \(buttonTag)")
            
            switch SacnnerViewButtonType(rawValue: buttonTag) {
            case .Back:
                self.cancelImageScannerController()
            case .CameraFlip:
                self.toggleCamera()
            case .Flash:
                self.toggleFlash(sender: sender)
            case .gridView:
                break
            case .none:
                break
            }
        }
    }
    // MARK: - Actions
    
    @objc private func captureImage(_ sender: UIButton) {
        (navigationController as? ImageScannerController)?.flashToBlack()
        shutterButton.isUserInteractionEnabled = false
        captureSessionManager?.capturePhoto()
    }
    
    @objc private func cancelImageScannerController() {
        if self.capturedImages != nil {
            self.capturedImages = nil
            self.previewImageView.image = nil
        }
        guard let imageScannerController = navigationController as? ImageScannerController else { return }
        imageScannerController.imageScannerDelegate?.imageScannerControllerDidCancel(imageScannerController)
    }
    
    private func toggleCamera() {
        captureSessionManager?.captureSession.beginConfiguration()
        if let currentInput = captureSessionManager?.captureSession.inputs.first as? AVCaptureDeviceInput {
            captureSessionManager?.captureSession.removeInput(currentInput)
            
            // Toggle between front and back cameras
            if currentInput.device.position == .back {
                if let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
                    currentCamera = frontCamera
                }
            } else {
                if let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
                    currentCamera = backCamera
                }
            }
            
            // Add the new input
            do {
                let captureInput = try AVCaptureDeviceInput(device: currentCamera!)
                captureSessionManager?.captureSession.addInput(captureInput)
            } catch {
                print("Error setting device input: \(error.localizedDescription)")
            }
            
            captureSessionManager?.captureSession.commitConfiguration()
        }
    }
    
    @objc private func toggleAutoScan() {
        if CaptureSession.current.isAutoScanEnabled {
            CaptureSession.current.isAutoScanEnabled = false
            autoScanButton.setImage(UIImage(named: "ManualScan"), for: .normal)
        } else {
            CaptureSession.current.isAutoScanEnabled = true
            autoScanButton.setImage(UIImage(named: "AutoScan"), for: .normal)
        }
    }
    
    @objc private func nextAction() {
        if let capturedImages, !capturedImages.isEmpty {
//            let previewController = ScannedImagePreviewView(imageNames: capturedImages, isFromScanner: true, isTabViewShown: $istab, documentsViewModel: self.documentViewModel)
//            let controller = UIHostingController(rootView: previewController)
//            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @objc private func toggleFlash(sender: UIButton?) {
        let state = CaptureSession.current.toggleFlash()
        
        let flashImage = UIImage(named: "FlashOn")
        let flashOffImage = UIImage(named: "FlashOff")
        
        switch state {
        case .on, .off:
            flashEnabled = (state == .on) ? true : false
            flashButton?.setImage((state == .on) ? flashImage : flashOffImage, for: .normal)
        case .unknown, .unavailable:
            flashEnabled = false
            flashButton?.setImage(flashOffImage, for: .normal)
            flashButton?.tintColor = UIColor.lightGray
        }
    }
}

// Bottom Options View layout
extension ScannerViewController {
    
    private func getFlashImage() -> UIImage? {
        guard UIImagePickerController.isFlashAvailable(for: .rear) == false else {
            return UIImage(named: "FlashOff")
        }
        return UIImage(named: "FlashOn")
    }
    
    private func addCameraOptionsScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        // Create a horizontal stack view to hold the buttons
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 50 // Adjust the spacing between buttons
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true

        // Add buttons to the stack view
        for buttonType in SacnnerViewButtonType.allCases {
            let button = UIButton(type: .system)
            var buttonImage: UIImage?
            switch buttonType {
            case .Back:
                buttonImage = UIImage(named: "Back")
            case .CameraFlip:
                buttonImage = UIImage(named: "Camera")
            case .Flash:
                buttonImage = self.getFlashImage()
                flashButton = button
            case .gridView:
                buttonImage = UIImage(named: "Grid")
            }
            if buttonImage != nil {
                button.setImage(buttonImage, for: .normal)
            }
            button.accessibilityIdentifier = buttonType.rawValue
            button.addTarget(self, action: #selector(cameraOptionsbuttonTapped(_:)), for: .touchUpInside)
            button.widthAnchor.constraint(equalToConstant: 40).isActive = true
            button.heightAnchor.constraint(equalToConstant: 40).isActive = true
            button.tintColor = .white
            stackView.addArrangedSubview(button)
        }
        
        // Set the content size of the scroll view to enable scrolling horizontally
        scrollView.contentSize = CGSize(width: CGFloat(SacnnerViewButtonType.allCases.count * 50 + (SacnnerViewButtonType.allCases.count - 1) * 50), height: 0)
        return scrollView
    }
    
    private func setupConstraints() {
        var quadViewConstraints = [NSLayoutConstraint]()
        var autoScanButtonConstraints = [NSLayoutConstraint]()
        var shutterButtonConstraints = [NSLayoutConstraint]()
        var activityIndicatorConstraints = [NSLayoutConstraint]()
        var cameraOptionsConstraints = [NSLayoutConstraint]()
        var previewImageViewConstraints = [NSLayoutConstraint]()
        var nextButonConstraints = [NSLayoutConstraint]()
        
        quadViewConstraints = [
            quadView.topAnchor.constraint(equalTo: view.topAnchor),
            view.bottomAnchor.constraint(equalTo: quadView.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: quadView.trailingAnchor),
            quadView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ]

        shutterButtonConstraints = [
            shutterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shutterButton.widthAnchor.constraint(equalToConstant: 65.0),
            shutterButton.heightAnchor.constraint(equalToConstant: 65.0),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: shutterButton.bottomAnchor, constant: 8.0)
        ]

        activityIndicatorConstraints = [
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        autoScanButtonConstraints = [
            autoScanButton.widthAnchor.constraint(equalToConstant: 45.0),
            autoScanButton.heightAnchor.constraint(equalToConstant: 45.0),
            autoScanButton.trailingAnchor.constraint(equalTo: shutterButton.leadingAnchor, constant: -25),
            autoScanButton.centerYAnchor.constraint(equalTo: shutterButton.centerYAnchor)
        ]
        
        previewImageViewConstraints = [
            previewImageView.widthAnchor.constraint(equalToConstant: 45.0),
            previewImageView.heightAnchor.constraint(equalToConstant: 45.0),
            previewImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            previewImageView.centerYAnchor.constraint(equalTo: autoScanButton.centerYAnchor)
        ]
        
        nextButonConstraints = [
            saveButton.widthAnchor.constraint(equalToConstant: 45.0),
            saveButton.heightAnchor.constraint(equalToConstant: 45.0),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            saveButton.centerYAnchor.constraint(equalTo: autoScanButton.centerYAnchor)
        ]
                        
        cameraOptionsConstraints = [
            optionsScrollView.bottomAnchor.constraint(equalTo: shutterButton.topAnchor),
            optionsScrollView.heightAnchor.constraint(equalToConstant: 65.0),
            view.trailingAnchor.constraint(equalTo: optionsScrollView.trailingAnchor),
            optionsScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ]
        
        NSLayoutConstraint.activate(quadViewConstraints + shutterButtonConstraints + activityIndicatorConstraints + cameraOptionsConstraints + autoScanButtonConstraints + previewImageViewConstraints + nextButonConstraints)
    }
}

extension ScannerViewController: RectangleDetectionDelegateProtocol {
    func captureSessionManager(_ captureSessionManager: CaptureSessionManager, didFailWithError error: Error) {

        activityIndicator.stopAnimating()
        shutterButton.isUserInteractionEnabled = true

        guard let imageScannerController = navigationController as? ImageScannerController else { return }
        imageScannerController.imageScannerDelegate?.imageScannerController(imageScannerController, didFailWithError: error)
    }

    func didStartCapturingPicture(for captureSessionManager: CaptureSessionManager) {
        activityIndicator.startAnimating()
        captureSessionManager.stop()
        shutterButton.isUserInteractionEnabled = false
    }

    func captureSessionManager(_ captureSessionManager: CaptureSessionManager, didCapturePicture picture: UIImage, withQuad quad: Quadrilateral?) {
        activityIndicator.stopAnimating()

        let editVC = EditScanViewController(image: picture, quad: quad)
        navigationController?.pushViewController(editVC, animated: false)

        shutterButton.isUserInteractionEnabled = true
    }

    func captureSessionManager(_ captureSessionManager: CaptureSessionManager, didDetectQuad quad: Quadrilateral?, _ imageSize: CGSize) {
        guard let quad else {
            // If no quad has been detected, we remove the currently displayed on on the quadView.
            quadView.removeQuadrilateral()
            return
        }

        let portraitImageSize = CGSize(width: imageSize.height, height: imageSize.width)

        let scaleTransform = CGAffineTransform.scaleTransform(forSize: portraitImageSize, aspectFillInSize: quadView.bounds.size)
        let scaledImageSize = imageSize.applying(scaleTransform)

        let rotationTransform = CGAffineTransform(rotationAngle: CGFloat.pi / 2.0)

        let imageBounds = CGRect(origin: .zero, size: scaledImageSize).applying(rotationTransform)

        let translationTransform = CGAffineTransform.translateTransform(fromCenterOfRect: imageBounds, toCenterOfRect: quadView.bounds)

        let transforms = [scaleTransform, rotationTransform, translationTransform]

        let transformedQuad = quad.applyTransforms(transforms)

        quadView.drawQuadrilateral(quad: transformedQuad, animated: true)
    }

}
