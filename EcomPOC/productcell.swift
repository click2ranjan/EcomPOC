//
//  productcell.swift
//  EcomPOC
//
//  Created by Ranjan Mallick on 07/12/17.
//  Copyright © 2017 Ranjan Mallick. All rights reserved.
//

import UIKit

class productcell: UITableViewCell {
    
    @IBOutlet var lbl_ProductName: UILabel!
    @IBOutlet var lbl_Colors: UILabel!
    @IBOutlet var lbl_Variant: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        /*for (UIView *subview in self.contentView.superview.subviews) {
         if ([NSStringFromClass(subview.class) hasSuffix:@"SeparatorView"]) {
         subview.hidden = NO;
         }*/
        
        
    }
}



