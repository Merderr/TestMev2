//
//  FeedBackViewController.swift
//  TestMe2
//
//  Created by admin on 3/21/22.
//

import UIKit
import Speech

class FeedBackViewController: UIViewController {
    
    //Outlet references for view controller controls. Data to be captured for SQLite read/write purposes
    @IBOutlet weak var label: UILabel!
    let audioEng = AVAudioEngine()
    let speechR = SFSpeechRecognizer()
    let req = SFSpeechAudioBufferRecognitionRequest()
    var rTask : SFSpeechRecognitionTask!
    var isStart = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Start speech recording with audio to text
    func startSpeechRec(){
        let nd = audioEng.inputNode
        let recordF = nd.outputFormat(forBus: 0)
        nd.installTap(onBus: 0, bufferSize: 1024, format: recordF){ (buffer , _ ) in
            self.req.append(buffer)
        }
        
        audioEng.prepare()
        do {
            try audioEng.start()
        }
        catch let err{
            print(err)
        }

        rTask = speechR?.recognitionTask(with: req, resultHandler: { (resp , error) in
            
            guard let rsp = resp else{
                print(error.debugDescription)
                return
            }
            let msg = resp?.bestTranscription.formattedString
            self.label.text = msg!
        })
    }
    
    //Stop speech recording
    func cancelSpeechRec(){
        rTask.finish()
        rTask.cancel()
        rTask = nil
        req.endAudio()
        audioEng.stop()
        if audioEng.inputNode.numberOfInputs > 0{
            audioEng.inputNode.removeTap(onBus: 0)
        }
    }
    
    //Button to Start/Stop recording button
    @IBAction func start(_ sender: UIButton) {
        isStart = !isStart
        if isStart {
            startSpeechRec()
            sender.setTitle("stop", for: .normal)
        }
        else{
            cancelSpeechRec()
            sender.setTitle("start", for: .normal)
        }
    }
}
