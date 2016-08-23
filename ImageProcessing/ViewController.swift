//
//  ViewController.swift
//  ImageProcessing
//
//  Created by Connor Mosley on 8/22/16.
//  Copyright © 2016 Connor Mosley. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        startCameraControllerFromViewController(self, usingDelegate: self)
    }
    
    func startCameraControllerFromViewController(controller : UIViewController?,
                                     usingDelegate delegate : protocol<UIImagePickerControllerDelegate,
                                                              UINavigationControllerDelegate>?) -> Bool
    {
        if UIImagePickerController
            .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) == false
            || (delegate == nil)
            || (controller == nil) {
                return false
        }
        let cameraUI = UIImagePickerController()
        cameraUI.sourceType = UIImagePickerControllerSourceType.Camera
        
        //displays a controll that allows the user to choose picture or
        //movie capture, if both are available
        cameraUI.mediaTypes = UIImagePickerController
                              .availableMediaTypesForSourceType(UIImagePickerControllerSourceType.Camera)!
        
        //hides the controls for moving and scaling pictures, or for
        //trimming movies.
        cameraUI.allowsEditing = false
        cameraUI.delegate = delegate
        
        controller?.presentViewController(cameraUI, animated: true, completion: nil)
        return true
    }

    
//    func beginSession() {
////        var err : NSError? = nil
//        do {
//            try self.captureSession.addInput(AVCaptureDeviceInput(device: self.captureDevice))
//        } catch {
////            print("error: \(err)")
//            print("There was an error")
//        }
//        
//        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//        self.view.layer.addSublayer(previewLayer)
//        previewLayer?.frame = self.view.layer.frame
//        captureSession.startRunning()
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

