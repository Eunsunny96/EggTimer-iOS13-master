

import UIKit
import AVFoundation


class ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var progressBar: UIProgressView!

    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var soft: UIButton!
    @IBOutlet weak var medium: UIButton!
    @IBOutlet weak var hard: UIButton!
    
    var player: AVAudioPlayer!

    let eggTimes = ["Soft": 3, "Medium": 4, "Hard": 7]
    
    var timer = Timer()
    var totalTime = 0
    var secondsPassed = 0
    
    override func viewDidLoad() {
        stopButton.isHidden = true
    }
    
    @IBAction func hardnessSelected(_ sender: UIButton) {
        
        timer.invalidate()
        
        stopButton.isHidden = false
        
        let hardness = sender.currentTitle!
        totalTime = eggTimes[hardness]!
        
        progressBar.progress = 0.0
        secondsPassed = 0
        titleLabel.text = hardness + " ("+String(totalTime) + " Seconds)"
        
        changedMode(sender)

        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
    }
    
    // If it changed mode
    func changedMode(_ sender: UIButton? = nil){
        
        soft.backgroundColor = .none
        medium.backgroundColor = .none
        hard.backgroundColor = .none
        
        if let button = sender {
            button.backgroundColor = .systemYellow
        }
        
    }
    
    @objc func updateTimer() {
        if secondsPassed < totalTime {
            secondsPassed += 1
            let percentageProgress = Float(secondsPassed) / Float(totalTime)
            progressBar.progress = percentageProgress
            titleLabel.text = String(totalTime - secondsPassed) + " Seconds"
            
        } else {
            timer.invalidate()
            titleLabel.text = "Done!"
            
            
            // Playing a sound
            guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else { return }
            
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
                
                player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
                
                guard let player = player else {return}
                
                player.volume = 0.5
                player.play()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func stopButton(_ sender: UIButton) {
        timer.invalidate()
        
        stopButton.isHidden = true
        progressBar.progress = 0.0
        secondsPassed = 0
        titleLabel.text = "How do you like your eggs?"
        
        changedMode()
    }
}
