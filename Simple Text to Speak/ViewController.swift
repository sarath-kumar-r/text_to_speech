//
//  ViewController.swift
//  Simple Text to Speak
//
//  Created by Sarath Kumar Rajendran on 25/02/20.
//  Copyright © 2020 Sarath Christiano. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    fileprivate let inputField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .gray
        textField.textColor = .white
        return textField
    }()
    
    fileprivate let speakButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Speak", for: .normal)
        button.backgroundColor = .green
        return button
    }()
    
    private var speechSynthesizer: AVSpeechSynthesizer!
    private var synthesizeVoice: AVSpeechSynthesisVoice!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpSpeechSysthesizer()
    }

}

fileprivate extension ViewController {
    
    func setUpView() {
        self.view.backgroundColor = .lightGray
        self.inputField.delegate = self
        self.view.addSubview(self.inputField)
        self.view.addSubview(self.speakButton)
        self.speakButton.addTarget(self, action: #selector(didTapSpeakButton(_:)), for: .touchUpInside)
        self.addConstraints()
    }
    
    func addConstraints() {
            
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[textField]-30-|", options: [], metrics: nil, views: ["textField": self.inputField])
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:|-80-[textField(100)]", options: [], metrics: nil, views: ["textField": self.inputField])
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:[button(100)]", options: [], metrics: nil, views: ["button": self.speakButton])
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "V:[textField]-30-[button(60)]", options: [], metrics: nil, views: ["button": self.speakButton, "textField": self.inputField])
        constraints.append(.init(item: self.inputField, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        constraints.append(.init(item: self.speakButton, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0))
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func didTapSpeakButton(_ sender: UIButton) {
        self.speak(self.inputField.text ?? "")
    }
}

fileprivate extension ViewController {
    
    func setUpSpeechSysthesizer() {
        
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.playback, mode: .measurement, options: .duckOthers)
        try? audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        self.speechSynthesizer = AVSpeechSynthesizer()
        AVSpeechSynthesisVoice.speechVoices().forEach { (voice) in
            if voice.gender == .female && voice.quality == .enhanced {
                synthesizeVoice = voice
                return
            }
        }
    }
    
    func speak(_ text: String) {
        
        guard let voice = synthesizeVoice, text.isEmpty == false else {
            return
        }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = voice
        utterance.volume = 1
        utterance.postUtteranceDelay = 0.5
        speechSynthesizer.speak(utterance)
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputField.resignFirstResponder()
        return true
    }
}
