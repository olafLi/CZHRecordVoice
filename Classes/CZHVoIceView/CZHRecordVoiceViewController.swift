//
//  CZHRecordVoiceViewController.swift
//  CZHRecordVoice
//
//  Created by LiTengFei on 2018/10/11.
//  Copyright © 2018 程召华. All rights reserved.
//

import UIKit
@objc
public protocol CZHRecordVoiceViewDelegate : NSObjectProtocol {

    func didBeginRecord() -> Void
    func continueRecording() -> Void
    func willCancelRecord() -> Void
    func didFinishedRecord(with audioLocalPath:String) -> Void
    func didCancelRecord() -> Void
}

public class CZHRecordVoiceViewController: UIViewController {
    
    public typealias RecordVoiceFinishedHandler = (_ path:String,_ seconds:Int) -> Void

    public var recordVoiceFinidhedHandler:RecordVoiceFinishedHandler?

    var audioLocalPath:String = ""
    var playing:Bool = false

    lazy  var voiceView: CZHRecordVoiceHUD = {
        let hub = CZHRecordVoiceHUD(frame: self.view.bounds)
        return hub
    }()

    @objc
    public var delegate:CZHRecordVoiceViewDelegate?

    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white

//        self.view.addSubview(CZHRecordVoiceHUD.shareInstance())

    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        CZHRecordVoiceHUD.shareInstance()?.center = CGPoint(x: self.view.czh_width / 2, y: self.view.czh_height / 2)
//        CZHRecordVoiceHUD.shareInstance()?.layoutIfNeeded()
//        CZHRecordVoiceHUD.shareInstance()?.setNeedsLayout()
    }

    @objc
    public func show(inViewController: UIViewController) {
        self.view.frame = CGRect(x: 0, y: 0, width: 300, height: 250)
        inViewController.cb_presentPopupViewController(self)

        self.playVoiceRecord()
    }

    @IBAction func submitVoiceRecord(_ sender: Any) {
        self.submitVoiceRecord()
        self.cb_dismissPopupViewController(animated: true)
    }

    @IBAction func cancelVoiceRecord(_ sender: Any) {
        self.cancelVoiceRecord()
        self.cb_dismissPopupViewController(animated: true)
    }

    func playVoiceRecord(){
        guard playing == false else { return }
        self.playing = true
        self.audioLocalPath = CZHFileManager.czh_filePath()!
        CZHRecordTool.shareInstance()?.czh_beginRecord(withRecordPath: self.audioLocalPath)

        CZHRecordVoiceHUD.shareInstance()?.czh_show(with: CZHRecordVoiceHUDType.beginRecord)
        CZHRecordVoiceHUD.shareInstance()?.longTimeHandler = {
            self.submitVoiceRecord()
            self.cb_dismissPopupViewController(animated: true)
        }
        if let delegate = delegate {
            delegate.didBeginRecord()
        }

    }

    func cancelVoiceRecord() {
        guard playing else { return }

        self.playing = false
        CZHRecordTool.shareInstance()?.czh_endRecord()
        CZHRecordVoiceHUD.shareInstance()?.czh_show(with: CZHRecordVoiceHUDType.endRecord)
        if let delegate = delegate {
            delegate .didCancelRecord()
        }
    }

    func submitVoiceRecord(){
        guard playing else { return }

        self.playing = false
        let recordTimes = CZHRecordVoiceHUD.shareInstance()?.seconds ?? 0
        CZHRecordTool.shareInstance()?.czh_endRecord()
        CZHRecordVoiceHUD.shareInstance()?.czh_show(with: CZHRecordVoiceHUDType.endRecord)
        if let delegate = delegate {
            delegate .didFinishedRecord(with: self.audioLocalPath)
        }
        if let handler = self.recordVoiceFinidhedHandler {
            handler(self.audioLocalPath,recordTimes)
        }
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancelVoiceRecord()
    }
}
