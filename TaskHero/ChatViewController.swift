//
//  ChatViewController.swift
//  TaskHero
//
//  Created by Jonathan Como on 11/27/16.
//  Copyright © 2016 Task Hero. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageSendButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var messageEntryBottomConstraint: NSLayoutConstraint!
    
    var task: Task!
    
    fileprivate var messages: [Message]!
    fileprivate var messageTimer: Timer!
    fileprivate var bottomLayoutDelta: CGFloat!
    
    private var enteredText: String {
        get { return messageTextField?.text ?? "" }
        set { messageTextField.text = newValue }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.registerNib(with: "MessageCell")
        tableView.registerNib(with: "MyMessageCell")

        updateTextEntryUI()
        
        messages = []

        loadRecentMessages { messages in
            self.messages = messages
            self.tableView.reloadData()
        }
        
        messageTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { (timer) in
            self.loadRecentMessages { messages in
                if messages.count > 0 {
                    self.messages.insert(contentsOf: messages, at: 0)
                    self.tableView.reloadData()
                    self.tableView.scrollToBottom()
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        calculateBottomLayoutDelta()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        messageTimer.invalidate()
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @IBAction func onTextChanged(_ sender: Any) {
        updateTextEntryUI()
    }
    
    @IBAction func onSendTapped(_ sender: Any) {
        ParseClient.sharedInstance.postMessage(
            text: enteredText,
            task: task,
            success: {},
            failure: { error in print(error) }
        )
        
        clearTextEntry()
    }
    
    @objc fileprivate func keyboardWillShow(_ note: Notification) {
        guard let info = note.userInfo else { return }
        guard let frame = info[UIKeyboardFrameBeginUserInfoKey] as? NSValue else { return }
        
        let duration = info[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        let keyboardHeight = frame.cgRectValue.size.height
        
        messageEntryBottomConstraint.constant = keyboardHeight - bottomLayoutDelta
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc fileprivate func keyboardWillHide(_ note: Notification) {
        guard let info = note.userInfo else { return }

        let duration = info[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        
        messageEntryBottomConstraint.constant = 0
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func clearTextEntry() {
        enteredText = ""
        updateTextEntryUI()
    }
    
    private func updateTextEntryUI() {
        messageSendButton.isEnabled = !enteredText.isEmpty
    }
    
    private func loadRecentMessages(completion: @escaping ([Message]) -> ()) {
        let mostRecentMessage = messages?.max(by: { (a, b) -> Bool in
            return (a.createdAt ?? Date.distantPast) < (b.createdAt ?? Date.distantPast)
        })
        
        ParseClient.sharedInstance.getMessages(
            task: task,
            since: mostRecentMessage?.createdAt,
            success: { (messages) in
                completion(messages)
            },
            failure: { (error) in
                print("Error: \(error)")
            }
        )
    }
    
    private func calculateBottomLayoutDelta() {
        let origin = view.superview?.convert(view.frame.origin, to: nil) ?? CGPoint(x: 0, y: 0)
        let bottomY = origin.y + view.frame.height
        bottomLayoutDelta = UIScreen.main.bounds.size.height - bottomY
    }
}

extension ChatViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        messageTextField.resignFirstResponder()
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[messages.count - indexPath.row - 1]
        
        if message.isMine {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyMessageCell") as! MyMessageCell
            cell.message = message
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as! MessageCell
            cell.message = message
            return cell
        }
    }
}
