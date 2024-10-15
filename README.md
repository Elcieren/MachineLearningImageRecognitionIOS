<details>
    <summary><h2>Uygulma Amacı</h2></summary>
  Uygulama, kullanıcıların fotoğraf kütüphanesinden bir resim seçmesini sağlar ve ardından bu resmi tanımlamak için makine öğrenimi modelini kullanır.
  </details> 
  
  <details>
    <summary><h2>Kütüphanelerin İçe Aktarılması</h2></summary>
    CoreML: Makine öğrenimi modelleri ile çalışmak için kullanılır.
    Vision: Görsel analiz ve tanıma işlemleri için kullanılır.
    
    ```
    import CoreML
    import Vision
    ```
  </details> 

  <details>
    <summary><h2>Resim Seçildiğinde</h2></summary>
    Kullanıcı bir resim seçtiğinde bu işlev tetiklenir. Resim UIImage formatından CIImage formatına dönüştürülür ve recongizeImage fonksiyonu çağrılır.

    
    ```
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[.originalImage] as? UIImage else { return }
    imageView.image = image
    self.dismiss(animated: true, completion: nil)

    if let ciImage = CIImage(image: imageView.image!) {
        choosenIamge = ciImage
    }
    
    recongizeImage(image: choosenIamge)
    }


    ```
  </details> 




<details>
    <summary><h2>Resmi Tanıma</h2></summary>
    Seçilen resmi tanımak için VNCoreMLModel kullanarak bir istek oluşturur ve modeli kullanarak resmi sınıflandırır.
    Sonuçlar alındığında, sonuçlar resultLabel üzerinde gösterilir.

    
    ```
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



    ```
  </details>

  
  
  
<details>
    <summary><h2>Uygulama Görselleri </h2></summary>
    
    
 <table style="width: 100%;">
    <tr>
        <td style="text-align: center; width: 16.67%;">
            <h4 style="font-size: 14px;">Görüntü İşleme Sonuçları 1 </h4>
            <img src="https://github.com/user-attachments/assets/2b0ef975-1fcd-4680-9d7e-a545cf4fdb39" style="width: 100%; height: auto;">
        </td>
        <td style="text-align: center; width: 16.67%;">
            <h4 style="font-size: 14px;">Görüntü İşleme Sonuçları 2</h4>
            <img src="https://github.com/user-attachments/assets/6c1c2e26-2d45-4c9b-a34b-f06eeab20c14" style="width: 100%; height: auto;">
        </td>
      <td style="text-align: center; width: 16.67%;">
            <h4 style="font-size: 14px;">Görüntü İşleme Sonuçları 3</h4>
            <img src="https://github.com/user-attachments/assets/88838ad5-0166-4804-b627-fdbdc8174dbd" style="width: 100%; height: auto;">
        </td>
    </tr>
</table>
  </details> 
