//
//  UploadedPhotos+CoreDataProperties.swift
//  Food Journal
//
//  Created by IACD 015 on 2022/12/03.
//
//

import Foundation
import CoreData


extension UploadedPhotos {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UploadedPhotos> {
        return NSFetchRequest<UploadedPhotos>(entityName: "UploadedPhotos")
    }

    @NSManaged public var imageURL: String?
    @NSManaged public var title: String?
    @NSManaged public var descript: String?
    @NSManaged public var childKey: String?

}

extension UploadedPhotos : Identifiable {

}
