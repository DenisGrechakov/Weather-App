//
//  Color.swift
//  MoodDiary
//
//  Created by Гречаков Денис on 20.02.2026.
//

import UIKit

class Color: UIColor, @unchecked Sendable {
    
    static let buttons: Color.Button = Color.Button()
    static let background: Color.Background = Color.Background()
    static let text: Color.Text = Color.Text()
    
    class Button {
        let fill: UIColor = UIColor(named: "ButtonFill")!
        let fillText: UIColor = UIColor(named: "ButtonFillText")!
    }
    
    class Background {
        let primary: UIColor = UIColor(named: "BackgroundPrimary")!
        let secondary: UIColor = UIColor(named: "BackgroundSecondary")!
    }
    
    class Text {
        let primary: UIColor = UIColor(named: "TextPrimary")!
        let secondary: UIColor = UIColor(named: "TextSecondary")!
    }
}
