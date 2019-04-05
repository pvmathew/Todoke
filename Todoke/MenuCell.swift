//
//  MenuCell.swift
//  Todoke
//
//  Created by Pavin Mathew on 4/5/19.
//  Copyright © 2019 Pavin Mathew. All rights reserved.
//

import Foundation
import UIKit

// Required to resize imageView of cell
class MenuCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Customize imageView here
        self.imageView?.frame = CGRectMake(20,12,30,30)
        self.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
        // Costomize other elements
        self.textLabel?.frame = CGRectMake(70, 10, self.frame.width - 45, 20)
        self.detailTextLabel?.frame = CGRectMake(70, 30, self.frame.width - 45, 15)
        self.detailTextLabel?.textColor = UIColor.lightGray
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
}
