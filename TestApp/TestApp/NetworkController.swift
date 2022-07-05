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
    let sentenceURL = "https://tw.feature.appledaily.com/collection/dailyquote"
    // singleton
    static let sharedInstance = NetworkController()
    // MaskInfo List
    var maskInfoList:[MaskInfo] = []
    // AreaList
    var areaList:[String] = []
    // vc
    var vc:ViewController?
    
    var isShouldRenewAreaList = true
    func getＳentence(){
        let url = URL(string: sentenceURL)!
        
        do{
            //取得送出後資料的回傳值
            let html = try String(contentsOf: url)
            var htmlComponent = html.components(separatedBy: "rwdfix")
            htmlComponent = htmlComponent[1].components(separatedBy: "p>")
            htmlComponent = htmlComponent[2].components(separatedBy: "<br />")
            htmlComponent[1].removeLast(2)
            vc?.chSentence.text = htmlComponent[0]
            vc?.enSentence.text = htmlComponent[1]
            
        }catch{
            print(error)
        }
    }
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
    // 清空coredata
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
    // 搜尋資料
    private func searchMaskInfo(){
        maskInfoList.removeAll()
        let request = NSFetchRequest<MaskInfo>(entityName: "MaskInfo")
        do{
            let request = try self.context.fetch(request)
            request.forEach { MaskInfo in
                maskInfoList.append(MaskInfo)
                if isShouldRenewAreaList && !areaList.contains(MaskInfo.town ?? "no data"){
                    areaList.append(MaskInfo.town ?? "no data")
                }
            }
            isShouldRenewAreaList = false
            maskInfoList.sort { MaskInfo1, MaskInfo2 in
                return  MaskInfo1.address ?? "" <= MaskInfo2.address ?? ""
            }
            areaList.sort { String1, String2 in
                return String1 <= String2
            }
            areaList.insert("選擇區域", at: 0)
        }catch{
            fatalError("抓取錯誤:\(error)")
        }
        DispatchQueue.main.async {
            self.vc?.maskInfoTable.reloadData() 
        }
    }
    // 刪除資料
    func deleteMaskInfo(id:String){
        let request = NSFetchRequest<MaskInfo>(entityName: "MaskInfo")
        request.predicate = NSPredicate(format: "id == %@", id)
        do{
            let results = try context.fetch(request)
            results.forEach { MaskInfo in
                context.delete(MaskInfo)
            }
            self.searchMaskInfo()
        }catch{
            fatalError("抓取錯誤:\(error)")
        }
    }
    
}
