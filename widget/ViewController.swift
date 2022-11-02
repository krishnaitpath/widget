//
//  ViewController.swift
//  widget
//
//  Created by IPS-169 on 28/10/22.
//
import WidgetKit
import UIKit

class ViewController: UIViewController {

    private let nameField: UITextField = {
        let nameField = UITextField()
        nameField.placeholder = "Enter text"
        nameField.backgroundColor = .white
        return nameField
        
    }()
    
    private let button:UIButton = {
        let button = UIButton()
        button.setTitle("Enter", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .blue
        view.addSubview(nameField)
        view.addSubview(button)
        nameField.becomeFirstResponder()
        button.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        nameField.frame = CGRect(x: 20, y: view.safeAreaInsets.top + 10, width: view.frame.size.width - 40, height: 52)
        button.frame = CGRect(x: 30, y: view.safeAreaInsets.top + 70, width: self.view.frame.width - 40, height: 50)
    }
    @objc private func btnTapped(){
        nameField.resignFirstResponder()
        let userdefault = UserDefaults(suiteName: "group.widgetcatch")
        guard let text = nameField.text, !text.isEmpty else{
            return
        }
        userdefault?.setValue(text, forKey: "text")
        WidgetCenter.shared.reloadAllTimelines()
    }


}

