
import Foundation
extension FileManager
{

    func appendImages() ->[String]
    {
        var arr  = [String]()
        let path = Bundle.main.resourcePath!
        do{
            
            let items = try self.contentsOfDirectory(atPath: path)
            
            for item in items
            {
                if item.hasPrefix("nssl")
                {
                    arr.append(item)
                }
            }
        }catch
        {
          print(error.localizedDescription)
        }
        
        return arr
    }
}
