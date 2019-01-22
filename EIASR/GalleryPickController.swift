//
//  GalleryPickController.swift
//  EIASR
//
//  Created by Jaka Tertinek on 06/01/2019.
//  Copyright © 2019 Jaka Tertinek. All rights reserved.
//

import UIKit

class GalleryPickController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    @IBOutlet weak var pickedImage: UIImageView!
    @IBOutlet weak var recognizedHandSign: UILabel!
    var brightnessFilter: CIFilter!
    var outputImage = CIImage();
    var aCIImage = CIImage();
    var context = CIContext();
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context = CIContext(options: nil);
    }

    @IBAction func onOpenGalleryBtnClick(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true)
        }
    }
   /* @objc func imagePickerController(_picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) -> Void{
        self.dismiss(animated: true, completion: { () -> Void in
            print("Its inside the function ---------")
        })
        print("Its outside the function ----------*****")
        pickedImage.image = image
    }*/
    /*func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        pickedImage.contentMode = .scaleAspectFit
        pickedImage.image = chosenImage
    }*/
    @IBOutlet weak var vmesna: UIImageView!
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage]
            as? UIImage else {
                return
        }
        self.dismiss(animated: true, completion: { () -> Void in
        })
        pickedImage.image = image
        startImageNormalization()
        
        processImage(pickedImage.image!)
    }
    
    func startImageNormalization(){
        print("Začetek normalizacije")
        //check the brightness level of an image
        
        //adjust brightness
        adjustBrightness(brightnessLevel: 0.05 )
        
        print("Konec normalizacije")
    }
    
    func adjustBrightness(brightnessLevel: Double){
        pickedImage.backgroundColor = UIColor.black
        
        let aCIImage = CIImage(image: pickedImage.image!)
        
        brightnessFilter = CIFilter(name: "CIColorControls");
        brightnessFilter.setValue(aCIImage, forKey: "inputImage")
        brightnessFilter.setValue(brightnessLevel, forKey: "inputBrightness");
        outputImage = brightnessFilter.outputImage!;
        
        let imageRef = context.createCGImage(outputImage, from: outputImage.extent)
        let newUIImage = UIImage(cgImage: imageRef!)
        pickedImage.image = newUIImage;
    }
    
    func processImage(_ image: UIImage){
        let model = HandSigns()
        let size = CGSize(width: 299, height: 299)
        
        guard let buffer = image.resize(to: size)?.pixelBuffer() else {
            fatalError("Scaling or converting to pixel buffer failed!")
        }
        
        guard let results = try? model.prediction(image: buffer) else {
            fatalError("Prediction failed!")
        }
        print(results.classLabel)
        var predictionString = ""
        switch results.classLabel {
            case HandSign.HighFive.rawValue:
                predictionString = "High five🤚"
            case HandSign.Peace.rawValue:
                predictionString = "Peace✌🏽"
            case HandSign.NoHand.rawValue:
                predictionString = "No Hand ❎"
            case HandSign.Fist.rawValue:
                predictionString = "Fist 👊🏻"
            default:
                print(results.classLabel);
                break
            }
        self.recognizedHandSign.text = predictionString;
        
    }
}
