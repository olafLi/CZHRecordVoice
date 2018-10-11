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

        self.view .addSubview(CZHRecordVoiceHUD.shareInstance())
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        CZHRecordVoiceHUD.shareInstance()?.center = self.view.center;
        CZHRecordVoiceHUD.shareInstance()?.layoutIfNeeded()
        CZHRecordVoiceHUD.shareInstance()?.setNeedsLayout()
    }

    @objc
    public func show(in viewController: UIViewController) {
        self.view.frame = CGRect(x: 0, y: 0, width: 300, height: 250)
        viewController.cb_presentPopupViewController(self)
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

        CZHRecordVoiceHUD.shareInstance()?.show(with: CZHRecordVoiceHUDType.beginRecord)
        CZHRecordVoiceHUD.shareInstance()?.longTimeHandler = {
            self.submitVoiceRecord()
        }
        if let delegate = delegate {
            delegate.didBeginRecord()
        }
    }

    func cancelVoiceRecord() {
        guard playing else { return }

        self.playing = false
        CZHRecordTool.shareInstance()?.czh_endRecord()
        CZHRecordVoiceHUD.shareInstance()?.show(with: CZHRecordVoiceHUDType.endRecord)
        if let delegate = delegate {
            delegate .didCancelRecord()
        }
    }

    func submitVoiceRecord(){
        guard playing else { return }

        self.playing = false
        CZHRecordTool.shareInstance()?.czh_endRecord()
        CZHRecordVoiceHUD.shareInstance()?.show(with: CZHRecordVoiceHUDType.endRecord)
        let amrFilePath = CZHFileManager.czh_convertWavtoAMR(withVoiceFilePath: self.audioLocalPath)
        CZHFileManager.czh_removeFile(self.audioLocalPath)

        if let delegate = delegate , let amrFilePath = amrFilePath {
            delegate .didFinishedRecord(with: amrFilePath)
        }

    }
}
