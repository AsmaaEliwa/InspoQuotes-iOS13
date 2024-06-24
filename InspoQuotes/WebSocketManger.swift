//
//  WebSocketManger.swift
//  InspoQuotes
//
//  Created by asmaa gamal  on 24/06/2024.
//  Copyright © 2024 London App Brewery. All rights reserved.
//

import Foundation

class WebSocketManager: NSObject {
    
    var webSocketTask: URLSessionWebSocketTask?
    
 
    func send(message: String) {
        let message = URLSessionWebSocketTask.Message.string(message)
        webSocketTask?.send(message, completionHandler: { error in
            if let error = error {
                print(error)
            }else{
                print("message was sent")
            }
        })
    }
    
    func recive() {
        webSocketTask?.receive(completionHandler: { [weak self] result in
            switch result {
            case .success(let message):
                print(message)
                self?.recive()
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func close() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
    func connect() {
        guard let url = URL(string:"wss://example.com/socket")else{return}
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        recive()
        
    }
}

extension WebSocketManager: URLSessionWebSocketDelegate{
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("web socket connected")
    }
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("web socket dissconnected")
    }
}
