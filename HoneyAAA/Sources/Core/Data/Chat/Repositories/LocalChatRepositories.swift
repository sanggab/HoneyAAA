//
//  LocalChatRepositories.swift
//  HoneyAAA
//
//  Created by Gab on 1/14/26.
//

import Foundation

public protocol LocalChatMessageRepository {
    func fetchResendMessages(_ threadId: String) -> [Data]
    func fetchResendMessageDic() -> [String: [Data]]
    func saveResendMessage(_ threadId: String, data: Data) throws
    func deleteResendMessage(_ threadId: String, id: String) throws
    func isResendMessageAvailable(_ threadId: String) -> Bool
}

public struct LocalChatRepositories: LocalChatMessageRepository {
    public init() { }
    
    public func fetchResendMessages(_ threadId: String) -> [Data] {
        if let data = UserDefaults.standard.value(forKey: "resend") as? Data,
           let resendDic = try? JSONDecoder().decode([String: [Data]].self, from: data) {
            return resendDic[threadId] ?? []
        } else {
            return []
        }
    }
    
    public func fetchResendMessageDic() -> [String : [Data]] {
        if let data = UserDefaults.standard.value(forKey: "resend") as? Data,
           let resendDic = try? JSONDecoder().decode([String: [Data]].self, from: data) {
            return resendDic
        } else {
            return [:]
        }
    }
    
    public func saveResendMessage(_ threadId: String, data: Data) throws {
        var dict: [String : [Data]] = self.fetchResendMessageDic()
        var lists: [Data] = dict[threadId] ?? []
        
        lists.append(data)
        dict.updateValue(lists, forKey: threadId)
        
        let encoded: Data = try JSONEncoder().encode(dict)
        UserDefaults.standard.set(encoded, forKey: "resend")
    }
    
    public func deleteResendMessage(_ threadId: String, id: String) throws {
        var dict: [String : [Data]] = self.fetchResendMessageDic()
        let lists: [Data] = dict[threadId] ?? []
        
        var msgs: [ChatMessage] = try lists.map { try JSONDecoder().decode(ChatMessage.self, from: $0) }
        msgs.removeAll(where: { $0.id == id })
        
        let encodedMsgs: [Data] = try msgs.map { try JSONEncoder().encode($0) }
        dict.updateValue(encodedMsgs, forKey: threadId)
        
        let encodedDict: Data = try JSONEncoder().encode(dict)
        UserDefaults.standard.set(encodedDict, forKey: "resend")
    }
    
    public func isResendMessageAvailable(_ threadId: String) -> Bool {
        return fetchResendMessages(threadId).isEmpty
    }
}
