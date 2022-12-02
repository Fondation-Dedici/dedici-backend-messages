//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Fluent

internal struct MessagesCreate: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Message.schema)
            .id()
            .field(Message.FieldKeys.creationDate, .datetime, .required)
            .field(Message.FieldKeys.lastModificationDate, .datetime, .required)
            .field(Message.FieldKeys.expirationDate, .datetime, .required)
            .field(Message.FieldKeys.senderIdentityId, .uuid, .required)
            .field(Message.FieldKeys.recipientIdentityId, .uuid, .required)
            .field(Message.FieldKeys.version, .int8, .required)
            .field(Message.FieldKeys.type, .int8, .required)
            .field(Message.FieldKeys.headers, .data, .required)
            .field(Message.FieldKeys.content, .data, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Message.schema)
            .delete()
    }
}
