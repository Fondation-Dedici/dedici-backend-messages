//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation
import DediciVaporFluentToolbox
import DediciVaporToolbox
import Vapor

internal struct MessageNew: ResourceCreateOneRequestBody, Validatable {
    typealias Resource = Message

    static func validations(_ validations: inout Validations) {
        let maxHeadersSize = PublicConfiguration.current.messageMaximumHeadersSize
        let maxContentSize = PublicConfiguration.current.messageMaximumContentSize
        let messageMaximumMaxAge = PublicConfiguration.current.messageMaximumMaxAge

        validations.add("headers", as: Data.self, is: .count(2 ... maxHeadersSize), required: true)
        validations.add("content", as: Data.self, is: .count(2 ... maxContentSize), required: true)
        validations.add("maxAge", as: Int.self, is: .range(0 ... messageMaximumMaxAge), required: false)
    }

    var id: UUIDv4?
    var recipientIdentityId: UUIDv4
    var version: MessageVersion
    var type: MessageType
    var headers: Data
    var content: Data
    var maxAge: Int?

    func asResource(considering request: Request) throws -> EventLoopFuture<Resource> {
        let authResult: ForwardedAuthResult = try request.auth.require()
        let message = Message(
            id: id?.value ?? UUID(),
            senderIdentityId: authResult.identityId.value,
            recipientIdentityId: recipientIdentityId.value,
            version: version,
            type: type,
            headers: headers,
            content: content,
            maxAge: maxAge ?? PublicConfiguration.current.messageDefaultMaxAge
        )

        return request.eventLoop.makeSucceededFuture(message)
    }
}

extension MessageNew: ResourceCreateListRequestBodyItem {
    var resourceId: UUID { (id ?? .init()).value }
}
