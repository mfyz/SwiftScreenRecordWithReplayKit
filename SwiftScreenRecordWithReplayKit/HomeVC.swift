//
//  ViewController.swift
//  SwiftScreenRecordWithReplayKit
//
//  Created by Mehmet Fatih YILDIZ on 1/14/20.
//  Copyright © 2020 Mehmet Fatih YILDIZ. All rights reserved.
//

import ReplayKit
import UIKit

class HomeViewController: UIViewController, RPPreviewViewControllerDelegate {

	override func viewDidLoad() {
		super.viewDidLoad()

		self.navigationController?.isNavigationBarHidden = false
		
		navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Start", style: .plain, target: self, action: #selector(startRecording))

		// Build screen layout
		self.view.backgroundColor = .white
		let btn = UIButton(type:.system)
		btn.backgroundColor = .blue
		btn.setTitle("Button", for: .normal)
		btn.tintColor = .white
		btn.layer.cornerRadius = 5
		btn.frame = CGRect(x: 50, y: 150, width: 100, height: 40)
		UIView.animate(withDuration: 10.0, delay: 0, options: [.repeat, .autoreverse], animations: {
			btn.frame = CGRect(x: 50, y: 700, width: 100, height: 40)
		}, completion: nil)
		self.view.addSubview(btn)
	}

	@objc func startRecording() {
		print("Start recording...")
        let recorder = RPScreenRecorder.shared()

        recorder.startRecording { (error) in
			guard error == nil else {
				print("Failed to start recording...")
				print(error?.localizedDescription ?? "")
				return
			}

			self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Stop", style: .plain, target: self, action: #selector(self.stopRecording))
        }
    }

    @objc func stopRecording() {
		print("Trying to stop recording...")
        let recorder = RPScreenRecorder.shared()

		recorder.stopRecording (handler: { (previewController, error) in
			guard error == nil else {
				print("Failed to stop recording...")
				print(error?.localizedDescription ?? "")
				return
			}

			self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Start", style: .plain, target: self, action: #selector(self.startRecording))

			guard previewController == nil else {
				previewController?.previewControllerDelegate = self
				self.present(previewController!, animated: true)
				return
			}
        })
    }

    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        dismiss(animated: true)
    }

}

