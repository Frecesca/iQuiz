//
//  QuizTableViewCell.swift
//  iQuiz
//
//  Created by Meixuan Wang on 2/22/2026.
//

import UIKit

class QuizTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with quiz: Quiz) {
        titleLabel.text = quiz.title
        descriptionLabel.text = quiz.description
        iconImageView.image = UIImage(systemName: quiz.iconName)
        iconImageView.tintColor = .systemBlue
    }
}
