import UIKit
import Photos

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let randomURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!.appendingPathComponent("\(Int.random(in: 1...10000)).mp4")
        let downloadVideoURL = URL(string: "https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4")!
        
        PHPhotoLibrary.requestAuthorization({ _ in })
        
        URLSession.shared.dataTask(with: downloadVideoURL) { (data, _, _) in
            try! data!.write(to: randomURL)
            
            if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(randomURL.relativePath) {
                print("Done saving method 1")
                UISaveVideoAtPathToSavedPhotosAlbum(randomURL.relativePath, nil, nil, nil)
            }
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: randomURL)
            }) { saved, error in
                print("Done saving method 2")
                // TODO: Error handler
                assert(error == nil && saved)
            }
            
            print("Done with saving")
        }.resume()
    }
    
    
}

