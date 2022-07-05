//
//  NetworkController.swift
//  TestApp
//
//  Created by 王佶立 on 2022/7/3.
//

import UIKit
import CoreData

class NetworkController: NSObject {
    // coredata
    let app = UIApplication.shared.delegate as! AppDelegate
    lazy var context = app.persistentContainer.viewContext
    // API
    var dataTask : URLSessionDataTask?
    let maskURL = "https://raw.githubusercontent.com/kiang/pharmacies/master/json/points.json"
    // singleton
    static let sharedInstance = NetworkController()
    // MaskInfo List
    var maskInfoList:[MaskInfo] = []
    // vc
    var vc:ViewController?
    
    func getMaskInfo(){
        let url = URL(string: maskURL)!
        
        dataTask = URLSession.shared.dataTask(with: url) { [self] (data, response, error) in
            // 假如錯誤存在，則印出錯誤訊息（ 例如：網路斷線等等... ）
            if let error = error {
                print("Error: \(error.localizedDescription)")
            // 取得 response 和 data
            } else if let data = data {
                let responseData = try? JSONDecoder().decode(MaskCountInfo.self, from: data)
                // 取得台中地區資料
                let filteredData = responseData?.features.filter{
                    $0.properties.county.contains("臺中")
                }
                // 刪除舊的資料
                self.cleanMaskInfo()
                // 存入新的資料
                filteredData?.forEach({ element in
                    let info = MaskInfo(context: self.context)
                    info.id = element.properties.id
                    info.name = element.properties.name
                    info.phone = element.properties.phone
                    info.address = element.properties.address
                    info.adultCount = Int32(element.properties.maskAdult)
                    info.childCount = Int32(element.properties.maskChild)
                    info.county = element.properties.county
                    info.town = element.properties.town
                    info.cunli = element.properties.cunli
                    info.updatedate = element.properties.updated
                })
                self.app.saveContext()
                self.searchMaskInfo()
            }
        }
        dataTask?.resume()
    }
    
    private func cleanMaskInfo(){
        let request = NSFetchRequest<MaskInfo>(entityName: "MaskInfo")
        do{
            let results = try context.fetch(request)
            results.forEach { MaskInfo in
                context.delete(MaskInfo)
            }
        }catch{
            fatalError("抓取錯誤:\(error)")
        }
    }
    
    private func searchMaskInfo(){
        maskInfoList.removeAll()
        let request = NSFetchRequest<MaskInfo>(entityName: "MaskInfo")
        do{
            let request = try self.context.fetch(request)
            request.forEach { MaskInfo in
                maskInfoList.append(MaskInfo)
            }
            maskInfoList.sort { MaskInfo1, MaskInfo2 in
                return  MaskInfo1.address ?? "" <= MaskInfo2.address ?? ""
            }
        }catch{
            fatalError("抓取錯誤:\(error)")
        }
        DispatchQueue.main.async {
            self.vc?.maskInfoTable.reloadData() 
        }
        
    }
    
}
