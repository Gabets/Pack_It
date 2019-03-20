//
//  ConstantsLists.swift
//  BackPacker
//
//  Created by Alex Gabets on 20.01.2019.
//  Copyright © 2019 Gabets. All rights reserved.
//

import Foundation

struct ConstantsLists {
    
    func lists() -> Array<ObjectList> {
        return [listNew, listForest, listBusiness, listBeach]
    }
    
    var listForest: ObjectList {
        let forest = ObjectList()
        forest.imageName = "img_forest"
        forest.listName = "list_name_forest".localized
        forest.listDescription = "list_description_forest".localized
        
        let constantsItems = ConstantsItems().itemsForest
        var id = 0
        for item in constantsItems {
            let objectItem = ObjectListItem()
            objectItem.name = item
            objectItem.id = id
            id += 1
            forest.listItems.append(objectItem)
        }
        
        return forest
    }
    
    var listBeach: ObjectList {
        let beach = ObjectList()
        beach.imageName = "img_beach"
        beach.listName = "list_name_beach".localized
        beach.listDescription = "list_description_beach".localized
        
        let constantsItems = ConstantsItems().itemsBeach
        var id = 0
        for item in constantsItems {
            let objectItem = ObjectListItem()
            objectItem.name = item
            objectItem.id = id
            id += 1
            beach.listItems.append(objectItem)
        }
        
        return beach
    }
        
    var listBusiness: ObjectList {
        let business = ObjectList()
        business.imageName = "img_business"
        business.listName = "list_name_business".localized
        business.listDescription = "list_description_business".localized
        
        let constantsItems = ConstantsItems().itemsBusiness
        var id = 0
        for item in constantsItems {
            let objectItem = ObjectListItem()
            objectItem.name = item
            objectItem.id = id
            id += 1
            business.listItems.append(objectItem)
        }
        
        return business
    }
    
    var listNew: ObjectList {
        let newList = ObjectList()
        newList.imageName = "img_new"
        newList.listName = "list_name_new".localized
        newList.listDescription = "list_description_new".localized
        
        return newList
    }

}
