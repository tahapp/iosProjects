//
//  ViewController.swift
//  25 Selfie Share
//
//  Created by Taha Saleh on 1/3/23.
//
import MultipeerConnectivity
import UIKit

class CollectionViewController: UICollectionViewController,      UIImagePickerControllerDelegate, UINavigationControllerDelegate, MCSessionDelegate, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate, MCBrowserViewControllerDelegate
{
    let service = "ts-25Selfie"
    let imagePicker = UIImagePickerController()
    lazy var width = collectionView.frame.width - 20
    lazy var height = collectionView.frame.height - 150
    var images = [UIImage]()
    var mcPeerID = MCPeerID(displayName: UIDevice.current.name)
    var mcSession : MCSession?
    var nearByAdvertiser : MCNearbyServiceAdvertiser?
    var nearByBrowser : MCNearbyServiceBrowser?
    override func viewDidLoad()
    {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .camera, target: self, action: #selector(selectPhoto))
        navigationItem.leftBarButtonItem = .init(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
        imagePicker.delegate = self
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: width, height: height)
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.minimumLineSpacing = 10
        collectionView.setCollectionViewLayout(flowLayout, animated: true)
        
        mcSession = MCSession(peer: mcPeerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession?.delegate = self
        
        nearByBrowser = MCNearbyServiceBrowser(peer: mcPeerID, serviceType: service)
        nearByAdvertiser = MCNearbyServiceAdvertiser(peer: mcPeerID, discoveryInfo: nil, serviceType: service)
        
        nearByBrowser?.delegate = self
        nearByAdvertiser?.delegate = self
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photo", for: indexPath)
        cell.layer.borderWidth = 1.0
        let imageView = UIImageView()
        imageView.image = images[indexPath.item]
        cell.backgroundView = imageView
        return cell
    }
    @objc func selectPhoto()
    {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            if let mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera){
                
                imagePicker.allowsEditing = true
                imagePicker.mediaTypes = [mediaTypes[0]]
                present(imagePicker, animated: true)
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        images.append(image)
        collectionView.reloadData()
        dismiss(animated: true)
        
        guard  mcSession != nil else {return}
        if mcSession!.connectedPeers.count > 0
        {
            
            if let imageData = image.pngData()
            {
                // send the data
                
                do
                {
                    try mcSession?.send(imageData, toPeers: mcSession!.connectedPeers, with: .reliable)
                }catch
                {
                    let ac = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "ok", style: .cancel))
                    present(ac, animated: true)
                    
                }
            }
        }
    }
    @objc func showConnectionPrompt()
    {
        let ac = UIAlertController(title: "Connect to other", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: hostSession))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "cancel", style: .cancel))
        
        present(ac,animated: true)
        
    }
    
    func hostSession(_ action : UIAlertAction)
    {
        nearByAdvertiser?.startAdvertisingPeer()
    }
    
    func joinSession(_ action : UIAlertAction)
    {
        
        let browserViewController = MCBrowserViewController(serviceType: service, session: mcSession!)
        present(browserViewController, animated: true)
        browserViewController.delegate = self
        nearByBrowser?.startBrowsingForPeers()
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print(peerID)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        
    }
    
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
        invitationHandler(true,mcSession!)
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) // main one
    {
        DispatchQueue.main.async { [weak self] in
            if let image = UIImage(data: data)
            {
                /* when we import on device1, we append to the array but
                 when we send that image to device2, its array is still
                 empty so we add it to that array*/
                self?.images.append(image)
                self?.collectionView.reloadData()
            }
        }
    }
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress)
    {
        print("\(peerID) is trying to connect")
    }
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?)
    {
        print("\(peerID) is finish trying to connect")
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID)
    {
        print("\(peerID) receive")
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) // important for debugging
    {
        switch state {
        case .notConnected:
            print("notConnectec")
        case .connecting:
            print("connecting")
        case .connected:
            print("connected")
        @unknown default:
            print("unknown")
        }
    }
   
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
}

