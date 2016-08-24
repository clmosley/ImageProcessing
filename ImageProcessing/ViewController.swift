//
//  ViewController.swift
//  ImageProcessing
//
//  Created by Connor Mosley on 8/22/16.
//  Copyright © 2016 Connor Mosley. All rights reserved.
//

import UIKit
import AVFoundation
import CoreImage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //container for UIImages
    var pictures : [UIImage] = [UIImage]()

    @IBOutlet weak var displayPicture: UIImageView!
    
    @IBAction func cameraButton(sender: UIButton) {
        if !startCameraControllerFromViewController(self, usingDelegate: self) {
            print("Camera not available")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        //displays a controll that allows the user to take a picture only
        let mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(cameraUI.sourceType)
        if let mediaTypes = mediaTypes {
            for type in mediaTypes {
                if type == "public.image" {
                    cameraUI.mediaTypes = ["public.image"]
                    break 
                }
            }
        }
        
        //hides the controls for moving and scaling pictures, or for
        //trimming movies.
        cameraUI.allowsEditing = false
        cameraUI.delegate = delegate
        
        controller?.presentViewController(cameraUI, animated: true, completion: nil)
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let mediaType : String = info[UIImagePickerControllerMediaType] as! String
        var originalImage : UIImage? = nil
        
        //handle still image capture
        if mediaType == "public.image" {
            originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        
        //save the new image to the Camera Roll
//        UIImageWriteToSavedPhotosAlbum(originalImage!, nil, nil, nil)
        if let originalImage = originalImage {
            pictures.append(originalImage)
            let filteredImage = processImage(originalImage)
            displayPicture.image = UIImage(CGImage: filteredImage)
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func processImage(image : UIImage) -> CGImageRef {
        let context : CIContext = CIContext()
        let intermediateImage : CIImage? = CIImage(image: image)
        let filter : CIFilter? = CIFilter(name: "CIEdgeWork")
        filter?.setValue(intermediateImage, forKey: kCIInputImageKey)
        filter?.setValue(4.0, forKey: kCIInputRadiusKey)
        let resultImage : CIImage = (filter?.valueForKey(kCIOutputImageKey))! as! CIImage
        let extent : CGRect = resultImage.extent
        let returnImage : CGImageRef = context.createCGImage(resultImage, fromRect: extent)
        return returnImage
    }

}

