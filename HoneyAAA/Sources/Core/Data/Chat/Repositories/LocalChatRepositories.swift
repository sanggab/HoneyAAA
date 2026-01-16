//
//  LocalChatRepositories.swift
//  HoneyAAA
//
//  Created by Gab on 1/14/26.
//

import Foundation

public protocol LocalChatMessageRepository {
    func fetchResendMessages(_ threadId: String) -> [ChatMessage]
    func fetchResendMessageDic() -> [String: [ChatMessage]]
    func saveResendMessage(_ threadId: String, message: ChatMessage) throws
    func deleteResendMessage(_ threadId: String, id: String) throws
    func isResendMessageAvailable(_ threadId: String) -> Bool
}

public struct LocalChatRepositoryImpl: LocalChatMessageRepository {
    public init() { }
    
    public func fetchResendMessages(_ threadId: String) -> [ChatMessage] {
        guard let list = self.fetchResendMessageDic()[threadId] else { return [] }
        return list
    }
    
    public func fetchResendMessageDic() -> [String : [ChatMessage]] {
        if let data = UserDefaults.standard.value(forKey: "resend") as? Data,
           let resendDic = try? JSONDecoder().decode([String: [ChatMessage]].self, from: data) {
            return resendDic
        } else {
            return [:]
        }
    }
    
    public func saveResendMessage(_ threadId: String, message: ChatMessage) throws {
        var dict: [String : [ChatMessage]] = self.fetchResendMessageDic()
        var lists: [ChatMessage] = dict[threadId] ?? []
        
        lists.append(message)
        
        dict.updateValue(lists, forKey: threadId)
        
        let encoded: Data = try JSONEncoder().encode(dict)
        UserDefaults.standard.set(encoded, forKey: "resend")
    }
    
    public func deleteResendMessage(_ threadId: String, id: String) throws {
        var dict: [String : [ChatMessage]] = self.fetchResendMessageDic()
        var lists: [ChatMessage] = dict[threadId] ?? []
        
        lists.removeAll(where: { $0.id == id })
        
        dict.updateValue(lists, forKey: threadId)
        
        let encodedDict: Data = try JSONEncoder().encode(dict)
        UserDefaults.standard.set(encodedDict, forKey: "resend")
    }
    
    public func isResendMessageAvailable(_ threadId: String) -> Bool {
        return !fetchResendMessages(threadId).isEmpty
    }
}
