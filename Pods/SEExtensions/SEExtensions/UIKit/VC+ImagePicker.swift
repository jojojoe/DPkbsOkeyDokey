//
//  VC+ImagePicker.swift
//  PhotoWatermark
//
//  Created by Conver on 5/7/19.
//  Copyright © 2019 Conver. All rights reserved.
//

import Alertift
import Photos
import SwifterSwift
import UIKit

public protocol ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func checkImagePicker(_ type: UIImagePickerController.SourceType, mediaTypes: [String], controller: UIViewController)
    
}

public extension ImagePicker where Self: UIViewController {
    func checkImagePicker(_ type: UIImagePickerController.SourceType, mediaTypes: [String], controller: UIViewController) {
        switch type {
        case .photoLibrary:
            photoPermission(controller: controller) { [weak self] bool in
                guard let `self` = self else { return }
                guard bool else { return }
                self.privateCheckImage(type, mediaTypes:mediaTypes, controller: controller)
            }
        case .camera:
            cameraPermission(controller: controller) { [weak self] bool in
                guard let `self` = self else { return }
                guard bool else { return }
                self.privateCheckImage(type, mediaTypes:mediaTypes, controller: controller)
            }
        case .savedPhotosAlbum:
            photoPermission(controller: controller) { [weak self] bool in
                guard let `self` = self else { return }
                guard bool else { return }
                self.privateCheckImage(type, mediaTypes:mediaTypes, controller: controller)
            }
        @unknown default:
            return
        }
    }
    
    
    
    private func privateCheckImage(_ type: UIImagePickerController.SourceType, mediaTypes: [String], controller: UIViewController) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            let picker = UIImagePickerController().then {
                $0.sourceType = type
                if mediaTypes != nil && mediaTypes.count != 0 {
                    $0.mediaTypes = mediaTypes
                }
                //                $0.allowsEditing = true
                $0.delegate = self
                $0.modalPresentationStyle = .overFullScreen
            }
            controller.present(picker)
        }
    }
}

public extension UIViewController {
    func photoPermission(controller: UIViewController, block: @escaping (Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        let alert = { [weak self] in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                Alertift
                .alert(title: "Please allow to access in setting page.", message: "Please allow to access your photos in Settings -> \(UIApplication.shared.displayName ?? "") -> Photos")
                .action(.default("OK"), handler: { _, _, _ in
                    UIApplication.shared.openURL(url: UIApplication.openSettingsURLString)
                })
                .show(on: controller, completion: nil)
            }
            
        }
        
        switch status {
        case .authorized:
            block(true)
        case .restricted, .denied:
            alert()
        case .notDetermined:
            // Show permission popup and get new status
            PHPhotoLibrary.requestAuthorization { status in
                if status != .authorized {
                    alert()
                }
                DispatchQueue.main.async {
                    block(status == .authorized)
                }
            }
        @unknown default:
            return
        }
    }
    
    func cameraPermission(controller: UIViewController, block: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] response in
            guard let `self` = self else { return }
            if response {
                block(true)
            } else {
                
                
                DispatchQueue.main.async {
                    Alertift
                    .alert(title: "Please allow to access in setting page.", message: "Please allow to access your Camera in Settings -> \(UIApplication.shared.displayName ?? "") -> Camera")
                    .action(.default("OK"), handler: { _, _, _ in
                        UIApplication.shared.openURL(url: UIApplication.openSettingsURLString)
                    })
                    .show(on: controller, completion: nil)
                }
                
                
            }
        }
    }
}
