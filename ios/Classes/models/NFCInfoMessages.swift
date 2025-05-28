import Foundation
import FaturamatikVerify

public struct NFCInfoMessages {
    public var tagError: String?
    public var moreThanOneTag: String?
    public var connectionError: String?
    public var invalidMrzKey: String?
    public var responseError: String?
    public var defaultMessage: String?
    public var successMessage: String?
    public var requestPresentPass: String?

    public init(dict: [String: String]) {
        self.tagError = dict["tagError"]
        self.moreThanOneTag = dict["moreThanOneTag"]
        self.connectionError = dict["connectionError"]
        self.invalidMrzKey = dict["invalidMrzKey"]
        self.responseError = dict["responseError"]
        self.defaultMessage = dict["defaultMessage"]
        self.successMessage = dict["successMessage"]
        self.requestPresentPass = dict["requestPresentPass"]
    }

    public func toNFCMessageMap() -> [NFCMessageKey: String] {
        var map: [NFCMessageKey: String] = [:]

        if let tagError = tagError { map[.tagError] = tagError }
        if let moreThanOneTag = moreThanOneTag { map[.moreThanOneTag] = moreThanOneTag }
        if let connectionError = connectionError { map[.connectionError] = connectionError }
        if let invalidMrzKey = invalidMrzKey { map[.invalidMrzKey] = invalidMrzKey }
        if let responseError = responseError { map[.responseError] = responseError }
        if let defaultMessage = defaultMessage { map[.defaultMessage] = defaultMessage }
        if let successMessage = successMessage { map[.successMessage] = successMessage }
        if let requestPresentPass = requestPresentPass { map[.requestPresentPass] = requestPresentPass }

        return map
    }
}