//
//  ViewController.swift
//  MachineLearningImageRecognitionIOS
//
//  Created by Eren Elçi on 15.10.2024.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    
    var choosenIamge = CIImage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }

    @IBAction func changeClicked(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        imageView.image = image
        self.dismiss(animated: true, completion: nil)
        
        
        // Image CIIMAGE cevirdik cunku o lazim
        if let ciImage = CIImage(image: imageView.image!) {
            choosenIamge = ciImage
        }
        
        recongizeImage(image: choosenIamge)
    }
    
    func recongizeImage(image: CIImage){
        //1. Request
        //2. Handler
        resultLabel.text = "Finding...."
        if let model = try? VNCoreMLModel(for: MobileNetV2().model)  {
            let request = VNCoreMLRequest(model: model) { (vnrequest , error ) in
                if let results = vnrequest.results as? [VNClassificationObservation] {
                    if results.count > 0 {
                        let topResults = results.first
                        
                        DispatchQueue.main.async {
                            let confidanceLevel = (topResults?.confidence ?? 0) * 100
                            
                            let rounded = Int(confidanceLevel * 100 ) / 100
                        
                            
                            self.resultLabel.text = "\(rounded)% It's \(topResults!.identifier)"
                        }
                    }
                }
            }
            let handler = VNImageRequestHandler(ciImage: image)
            DispatchQueue.global(qos: .userInteractive).async {
                do{
                    try handler.perform([request])
                } catch {
                    print("error")
                }
                
            }
           
        }
        
        
    }
    
}

