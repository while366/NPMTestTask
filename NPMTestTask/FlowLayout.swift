//
//  FlowLayout.swift
//  NPMTestTask
//
//  Created by Mikhail Zhadko on 7/22/16.
//  Copyright © 2016 Mikhail Zhadko. All rights reserved.
//

import UIKit

class FlowLayout: UICollectionViewFlowLayout {

    var deleteIndexPaths = NSMutableArray()
    var insertIndexPaths = NSMutableArray()

    override func finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let layout = super.finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath)
        if self.deleteIndexPaths.containsObject(itemIndexPath){
            layout?.center.x += UIScreen.mainScreen().bounds.width
        }
        return layout
    }
    
    override func prepareForCollectionViewUpdates(updateItems: [UICollectionViewUpdateItem]) {
        super.prepareForCollectionViewUpdates(updateItems)
        deleteIndexPaths = NSMutableArray()
        insertIndexPaths = NSMutableArray()
        for update in updateItems {
            if update.updateAction == UICollectionUpdateAction.Delete {
                self.deleteIndexPaths.addObject(update.indexPathBeforeUpdate!)
            }
            if update.updateAction == UICollectionUpdateAction.Insert {
                insertIndexPaths.addObject(update.indexPathAfterUpdate!)
            }
        }
    }
    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        self.deleteIndexPaths = []
        self.insertIndexPaths = []
    }
}
