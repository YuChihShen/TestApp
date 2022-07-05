//
//  MaskInfo+CoreDataProperties.swift
//  TestApp
//
//  Created by 王佶立 on 2022/7/5.
//
//

import Foundation
import CoreData


extension MaskInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MaskInfo> {
        return NSFetchRequest<MaskInfo>(entityName: "MaskInfo")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var address: String?
    @NSManaged public var adultCount: Int32
    @NSManaged public var childCount: Int32
    @NSManaged public var updatedate: String?
    @NSManaged public var county: String?
    @NSManaged public var town: String?
    @NSManaged public var cunli: String?

}

extension MaskInfo : Identifiable {

}
