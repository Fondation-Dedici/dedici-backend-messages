//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Fluent
import Foundation
import DediciVaporFluentToolbox
import DediciVaporToolbox
import Vapor

internal struct MessagesController: RouteCollection, ResourceController {
    typealias Resource = Message

    func boot(routes: RoutesBuilder) throws {
        let messages = routes
            .grouped(ForwardedAuthAuthenticator(), ForwardedAuthResult.guardMiddleware())
            .grouped("messages")
        messages.group(":messageId") { message in
            message.delete(use: defaultDeleteOne(
                idPathComponentName: "messageId",
                resourceValidator: .init(checkMessageDeletionRights)
            ))
        }
        messages.delete(use: defaultDeleteList(resourcesValidator: .init(checkMessagesDeletionRights)))
        messages.post(use: defaultCreateOne(resourceValidator: .init(checkMessageConsistency)))
        messages.patch(use: defaultCreateList(resourcesValidator: .init(checkMessagesConsistency)))
        messages.get("received", use: getAllReceived)
        messages.get("sent", use: getAllSent)
    }

    func getAllReceived(request: Request) throws -> EventLoopFuture<[MessageResponse]> {
        let authResult: ForwardedAuthResult = try request.auth.require()
        return try defaultReadList(resourcesProvider: { request in
            Message.query(on: request.db)
                .filter(\.$recipientIdentityId == authResult.identityId.value)
                .all().map { $0 }
        })(request)
    }

    func getAllSent(request: Request) throws -> EventLoopFuture<[MessageResponse]> {
        let authResult: ForwardedAuthResult = try request.auth.require()
        return try defaultReadList(resourcesProvider: { request in
            Message.query(on: request.db)
                .filter(\.$senderIdentityId == authResult.identityId.value)
                .all().map { $0 }
        })(request)
    }

    private func checkMessagesDeletionRights(
        _ messages: [Message],
        for request: Request
    ) throws -> EventLoopFuture<Void> {
        let individualChecks = try messages.map { try checkMessageDeletionRights($0, for: request) }
        return .andAllSucceed(individualChecks, on: request.eventLoop)
    }

    private func checkMessageDeletionRights(_ message: Message, for request: Request) throws -> EventLoopFuture<Void> {
        let identityId = try request.auth.require(ForwardedAuthResult.self).identityId.value
        guard identityId == message.senderIdentityId || identityId == message.recipientIdentityId else {
            throw Abort(.forbidden)
        }

        return request.eventLoop.makeSucceededFuture(())
    }

    private func checkMessagesConsistency(_ messages: [Message], for request: Request) throws -> EventLoopFuture<Void> {
        let individualChecks = try messages.map { try checkMessageConsistency($0, for: request) }
        return .andAllSucceed(individualChecks, on: request.eventLoop)
    }

    private func checkMessageConsistency(_ message: Message, for request: Request) throws -> EventLoopFuture<Void> {
        let identityId = try request.auth.require(ForwardedAuthResult.self).identityId.value
        guard message.senderIdentityId != message.recipientIdentityId else {
            throw Abort(.badRequest, reason: "Sender's identity must not equal recipient's identity")
        }
        guard identityId != message.recipientIdentityId else {
            throw Abort(.badRequest, reason: "Your identity must not equal recipient's identity")
        }

        return request.eventLoop.makeSucceededFuture(())
    }
}
