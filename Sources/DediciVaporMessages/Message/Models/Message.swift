//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Fluent
import DediciVaporFluentToolbox
import DediciVaporToolbox
import Vapor

internal final class Message: ResourceModel {
    static let schema = "messages"

    @ID(key: FieldKeys.id)
    var id: UUID?

    @Field(key: FieldKeys.creationDate)
    var creationDate: Date

    @Field(key: FieldKeys.lastModificationDate)
    var lastModificationDate: Date

    @Field(key: FieldKeys.senderIdentityId)
    var senderIdentityId: UUID

    @Field(key: FieldKeys.recipientIdentityId)
    var recipientIdentityId: UUID

    @Field(key: FieldKeys.version)
    var version: MessageVersion

    @Field(key: FieldKeys.type)
    var type: MessageType

    @Field(key: FieldKeys.headers)
    var headers: Data

    @Field(key: FieldKeys.content)
    var content: Data

    @Field(key: FieldKeys.expirationDate)
    var expirationDate: Date?

    init() {}

    init(
        id: IDValue? = nil,
        creationDate: Date = Date(),
        lastModificationDate: Date = Date(),
        senderIdentityId: UUID,
        recipientIdentityId: UUID,
        version: MessageVersion,
        type: MessageType,
        headers: Data,
        content: Data,
        maxAge: Int
    ) {
        self.id = id
        self.creationDate = creationDate
        self.lastModificationDate = lastModificationDate
        self.recipientIdentityId = recipientIdentityId
        self.senderIdentityId = senderIdentityId
        self.version = version
        self.type = type
        self.headers = headers
        self.content = content
        self.expirationDate = Date().addingTimeInterval(.init(maxAge))
    }
}

extension Message {
    enum FieldKeys {
        static let id: FieldKey = .id
        static let creationDate: FieldKey = .string("creation_date")
        static let lastModificationDate: FieldKey = .string("last_modification_date")
        static let senderIdentityId: FieldKey = .string("sender_identity_id")
        static let recipientIdentityId: FieldKey = .string("recipient_identity_id")
        static let version: FieldKey = .string("version")
        static let type: FieldKey = .string("type")
        static let headers: FieldKey = .string("headers")
        static let content: FieldKey = .string("content")
        static let expirationDate: FieldKey = .string("expiration_date")
    }
}

extension Message: ModelCanExpire {
    var expirationDateField: FieldProperty<Message, Date?> { $expirationDate }
}

extension Message: HasDefaultResponse {
    typealias DefaultResponse = MessageResponse
}

extension Message: HasDefaultDeleteListBody {
    typealias DefaultDeleteListBody = MessageListDelete
}

extension Message: HasDefaultCreateOneBody {
    typealias DefaultCreateOneBody = MessageNew
}

extension Message: HasDefaultCreateListBody {
    typealias DefaultCreateListBody = MessageListNew
}
