//
//  ViewController.swift
//  12 UserDefault
//
//  Created by Taha Saleh on 7/29/22.
//

import UIKit

class CollectionViewController: UICollectionViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    var people = [Person]()
    let imagePicker = UIImagePickerController()

    let userDefaults = UserDefaults.standard
    override func viewDidLoad()
    {
        super.viewDidLoad()
        collectionView.register(PersonCell.self, forCellWithReuseIdentifier: "person")
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: 140, height: 180)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        collectionView.collectionViewLayout = layout
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        imagePicker.delegate = self
        
        if let binaryPeople = userDefaults.object(forKey: "people") as? Data
        {
            if let decodedPeople  = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(binaryPeople) as? [Person]{
                
                self.people =  decodedPeople
            }else{
                print("second")
            }
        }else
        {
            print("first")
        }
    }
  
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "person", for: indexPath) as? PersonCell else
        {
            print("failed")
            return UICollectionViewCell()
        }
       
        let person = people[indexPath.item]
        cell.labelName.text = person.name
        cell.imageView.image = getImage(index: indexPath.item)
        return cell
    }
    
    
    @objc func addNewPerson()
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        {
            if let mediaKinds =  UIImagePickerController.availableMediaTypes(for: .photoLibrary)
            {
                imagePicker.sourceType = .photoLibrary
                imagePicker.mediaTypes = mediaKinds
                imagePicker.allowsEditing = true
               
                present(imagePicker, animated: true)
            }
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        let fileNameForImage = UUID().uuidString
        let pathForFile = getDocumentDirectory().appendingPathComponent(fileNameForImage)
        if let imageData = image.jpegData(compressionQuality: 0.1)
        {
            do
            {
                try imageData.write(to: pathForFile)
            }catch
            {
                print("couldn't save the photo")
            }
        }
        let person = Person(name: "unknown", image: fileNameForImage)
        people.append(person)
        save()
        let index = IndexPath(item: people.count - 1, section: 0)
        collectionView.insertItems(at: [index])
        dismiss(animated: true)
    }
  
    func getDocumentDirectory() ->URL
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func getImage(index:Int) ->UIImage?
    {
        let path = getDocumentDirectory().appendingPathComponent(people[index].image)
        let image : UIImage? = UIImage(contentsOfFile: path.path)
        return image
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ac = UIAlertController(title: "change Name", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let action = UIAlertAction(title: "submit", style: .default){ [weak self, weak ac] _ in
            let newName = ac?.textFields?[0].text
            self?.people[indexPath.item].name = newName ?? "failed"
            self?.save()
            
            DispatchQueue.main.async {
                let cell = collectionView.cellForItem(at: indexPath) as! PersonCell
                cell.labelName.text = newName
            }
            
        }
        ac.addAction(action)
        ac.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
    
    func save()
    {
        if let savedArray = try? NSKeyedArchiver.archivedData(withRootObject: people, requiringSecureCoding: false)
        {
            userDefaults.set(savedArray, forKey: "people")
        }
    }
}


