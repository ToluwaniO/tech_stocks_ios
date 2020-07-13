//
//  StatisticsRowView.swift
//  Tech Stocks
//
//  Created by Toluwani Ogunsanya on 2020-07-07.
//  Copyright © 2020 Toluwani Ogunsanya. All rights reserved.
//

import Foundation
import UIKit

class StatisticsRowView: UIView {
    let nibName = "StatisticsRowView"
    var contentView:UIView?
    @IBOutlet var topLeft: UILabel!
    @IBOutlet var bottomLeft: UILabel!
    @IBOutlet var topRight: UILabel!
    @IBOutlet var bottomRight: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
}
