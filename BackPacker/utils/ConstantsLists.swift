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
        return [listForest, listBeach, listBusiness, listNew]
    }
    
    private var listForest: ObjectList {
        let forest = ObjectList()
        forest.imageName = "img_forest"
        forest.listName = "Поход в лес"
        forest.listDescription = "В данном списке находятся самые необхожимые предметы для суточного похода в лес"
        
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
    
    private var listBeach: ObjectList {
        let beach = ObjectList()
        beach.imageName = "img_beach"
        beach.listName = "Пляжный тур"
        beach.listDescription = "В данном списке находятся самые необходимые предметы для отдыха на море"
        
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
        
    private var listBusiness: ObjectList {
        let business = ObjectList()
        business.imageName = "img_business"
        business.listName = "Бизнес-поездка"
        business.listDescription = "В списке находятся предметы, которые понадобятся для короткой деловой поездки"
        
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
    
    private var listNew: ObjectList {
        let newList = ObjectList()
        newList.imageName = "img_new"
        newList.listName = "Новый список"
        newList.listDescription = "Здесь вы можете создать свой уникальный список для вашей поездки"
        
        return newList
    }

}
