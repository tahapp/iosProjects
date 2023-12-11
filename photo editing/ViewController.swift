//
//  ViewController.swift
//  13 instaFilter
//
//  Created by Taha Saleh on 9/9/22.
//

import UIKit
import CoreImage
class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    var imageView = UIImageView()
    var intensity = UILabel()
    var intensitySlider = UISlider()
    var changeFilter = UIButton()
    var save = UIButton()
    var currentImage = UIImage()
    var context = CIContext()
    var filter : CIFilter!
    
    var portraitConstrints = [NSLayoutConstraint]()
    var landscapeConstraints = [NSLayoutConstraint]()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        filter = CIFilter(name: "CITwirlDistortion")
        
        title = "YAFAI"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addImage))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.borderWidth = 0.5
        view.addSubview(imageView)
        
        intensity.text = "intensity:"
        intensity.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(intensity)
        
        intensitySlider.translatesAutoresizingMaskIntoConstraints = false
        
        intensitySlider.addTarget(self, action: #selector(slide), for: .valueChanged)
        view.addSubview(intensitySlider)
        
        changeFilter.setTitle("change filter", for: .normal)
        changeFilter.setTitleColor(.black, for: .normal)
        changeFilter.translatesAutoresizingMaskIntoConstraints = false
        changeFilter.layer.borderWidth = 1
        changeFilter.addTarget(self, action: #selector(chooseFilter), for: .touchUpInside)
        view.addSubview(changeFilter)
        
        save.setTitle("save", for: .normal)
        save.translatesAutoresizingMaskIntoConstraints = false
        save.setTitleColor(.black, for: .normal)
        save.layer.borderWidth = 1
        save.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
        view.addSubview(save)
        
        landscapeConstraints = [
            imageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            imageView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            imageView.bottomAnchor.constraint(greaterThanOrEqualTo: view.layoutMarginsGuide.bottomAnchor),
            imageView.widthAnchor.constraint(equalToConstant:463),


            intensity.leftAnchor.constraint(equalTo: imageView.rightAnchor,constant: 10),
            intensity.topAnchor.constraint(equalTo: imageView.topAnchor),

            intensitySlider.topAnchor.constraint(equalTo: imageView.topAnchor),
            intensitySlider.leftAnchor.constraint(equalTo: intensity.rightAnchor,constant: 10),
            intensitySlider.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),

            changeFilter.topAnchor.constraint(equalTo: intensity.bottomAnchor,constant: 30),
            changeFilter.leftAnchor.constraint(equalTo: intensity.leftAnchor),

            save.centerYAnchor.constraint(equalTo: changeFilter.centerYAnchor),
            save.rightAnchor.constraint(equalTo: intensitySlider.rightAnchor),

        ]
        portraitConstrints = [
            imageView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            imageView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 463),

            imageView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),

            intensity.leftAnchor.constraint(equalTo: imageView.leftAnchor),
            intensity.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant: 20),

            intensitySlider.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant: 16),
            intensitySlider.leftAnchor.constraint(equalTo: intensity.rightAnchor,constant: 10)
        ,
            intensitySlider.rightAnchor.constraint(equalTo: imageView.rightAnchor),

            changeFilter.topAnchor.constraint(equalTo: intensity.bottomAnchor,constant: 30),
            changeFilter.leftAnchor.constraint(equalTo: intensity.leftAnchor),

            save.centerYAnchor.constraint(equalTo: changeFilter.centerYAnchor),
            save.rightAnchor.constraint(equalTo: intensitySlider.rightAnchor),


        ]
        
        
        
    }
    override func viewWillLayoutSubviews()
    {
        
        let current = UIDevice.current.orientation
        if current.isPortrait
        {
            NSLayoutConstraint.deactivate(landscapeConstraints)
            NSLayoutConstraint.activate(portraitConstrints)
        }
        else if current.isLandscape
        {
            NSLayoutConstraint.deactivate(portraitConstrints)
            NSLayoutConstraint.activate(landscapeConstraints)
        }
        
    }
    
    @objc func saveImage()
    {
        UIImageWriteToSavedPhotosAlbum(currentImage, self, #selector(image(_: didFinishSavingWithError: contextInfo:)), nil)
    }
    @objc func chooseFilter(_ sender:UIButton)
    {
        let filterNames = ["CIBumpDistortion","CIGaussianBlur","CIPixellate","CISepiaTone","CITwirlDistortion","CIUnsharpMask","CIVignette"]
        let ac = UIAlertController(title: "pick filter", message: nil, preferredStyle: .actionSheet)
        for filter in filterNames
        {
            ac.addAction(UIAlertAction(title: filter, style: .default, handler: pickTheFilter(_:)))
        }
        ac.addAction(UIAlertAction(title: "cancel", style: .cancel))
        
        if let popover = ac.popoverPresentationController{
            
            popover.sourceView = sender
        }
        present(ac, animated: true)
    }
    @objc func slide()
    {
        applyProcessing()
    }
    
    @objc func addImage()
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        {
            if let mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)
            {
                imagePicker.sourceType = .photoLibrary
                imagePicker.mediaTypes = mediaTypes
                imagePicker.allowsEditing = true
                
                present(imagePicker, animated: true)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else{return}
        dismiss(animated: true)
        currentImage = image
        
        let beginImage = CIImage(image: currentImage)
        filter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    func applyProcessing()
    {
        let keys = filter.inputKeys
        
        if keys.contains(kCIInputIntensityKey)
        {
            filter.setValue(intensitySlider.value, forKey: "kCIInputIntensityKey")
        }
        if keys.contains(kCIInputRadiusKey)
        {
            filter.setValue(intensitySlider.value * 200, forKey: kCIInputRadiusKey)
        }
        if keys.contains(kCIInputScaleKey)
        {
            filter.setValue(intensitySlider.value * 100, forKey: kCIInputScaleKey)
        }
        if keys.contains(kCIInputCenterKey)
        {
            filter.setValue(CIVector(x: currentImage.size.width/2, y: currentImage.size.height/2), forKey: kCIInputCenterKey)
        }
        
        guard let filteredImage = filter.outputImage else {return}
        if let cgImage = context.createCGImage(filteredImage, from: filteredImage.extent){
            let processedImage = UIImage(cgImage: cgImage)
            imageView.image = processedImage
            currentImage = processedImage
        }
    }
    
    func pickTheFilter( _ action : UIAlertAction?)
    {
        
        guard let filterName = action?.title else {return}
        filter = CIFilter(name: filterName)
        print(filter.inputKeys)
        let coreImage = CIImage(image: currentImage)
        filter.setValue(coreImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    @objc func image(_ image:UIImage, didFinishSavingWithError error: Error?, contextInfo:UnsafeRawPointer?)
    {
        if let _ = error {
            let ac = UIAlertController(title: "save error", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "ok", style: .default))
            present(ac, animated: true)
        }else
        {
            let ac = UIAlertController(title: "saved", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "ok", style: .default))
            present(ac, animated: true)
        }
    }
}

