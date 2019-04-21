//
//  ViewController.swift
//  MessageComposer
//
//  Created by esanchez on 4/21/19.
//  Copyright © 2019 Tec. All rights reserved.
//

import UIKit
import MessageUI
import ContactsUI

class ViewController: UIViewController, MFMessageComposeViewControllerDelegate, CNContactPickerDelegate {
    // MARK: Outlets
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var messageSubject: UITextField!
    @IBOutlet weak var messageBody: UITextView!
    
    // MARK: UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    // MARK: Actions
    @IBAction func sendSMS(_ sender: UIButton) {
        if MFMessageComposeViewController.canSendText() {
            let smsController = MFMessageComposeViewController()
            smsController.messageComposeDelegate = self
            let recipientList = phoneNumber.text!.components(separatedBy: ",")
            smsController.recipients = recipientList
            smsController.body = messageBody.text
            
            present(smsController, animated: true, completion: nil)
        }
        else {
            print("Cannot send sms.")
        }
    }
    
    @IBAction func selectContact(_ sender: UIButton) {
        let contactPicker = CNContactPickerViewController()
        contactPicker.displayedPropertyKeys = [CNContactPhoneNumbersKey]
        contactPicker.delegate = self
        present(contactPicker, animated: true, completion: nil)
    }
    
    // MARK: MFMessageComposeViewControllerDelegate
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result) {
            case MessageComposeResult.cancelled:
                print("Cancelled.")
            case MessageComposeResult.sent:
                print("Sent.")
            case MessageComposeResult.failed:
                print("Failed.")
            default:
                print("Result code: \(result.rawValue)")
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    // MARK: CNContactPickerDelegate
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        if contact.phoneNumbers.count > 0 {
            let firstPhoneNumber = contact.phoneNumbers.first!.value
            phoneNumber.text = firstPhoneNumber.stringValue
        }
    }
}

