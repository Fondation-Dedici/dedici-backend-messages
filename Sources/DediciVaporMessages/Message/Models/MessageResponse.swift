//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation
import DediciVaporFluentToolbox
import DediciVaporToolbox
import Vapor

internal struct MessageResponse: ResourceRequestResponse {
    typealias Resource = Message

    var id: UUIDv4
    var creationDate: Date
    var lastModificationDate: Date
    var senderIdentityId: UUIDv4
    var recipientIdentityId: UUIDv4
    var version: MessageVersion
    var type: MessageType
    var headers: Data
    var content: Data
    var expirationDate: Date

    init(from resource: Message, and _: Request) throws {
        self.id = try UUIDv4(value: resource.id.require())
        self.creationDate = resource.creationDate
        self.lastModificationDate = resource.lastModificationDate
        self.recipientIdentityId = try UUIDv4(value: resource.recipientIdentityId)
        self.senderIdentityId = try UUIDv4(value: resource.senderIdentityId)
        self.version = resource.version
        self.type = resource.type
        self.headers = resource.headers
        self.content = resource.content
        self.expirationDate = try resource.expirationDate.require()
    }

    static func make(from resource: Message, and request: Request) throws -> EventLoopFuture<Self> {
        let response = try Self(from: resource, and: request)
        return request.eventLoop.future(response)
    }
}
