//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Foundation
import DediciVaporFluentToolbox
import DediciVaporToolbox
import Vapor

internal struct MessageExpirationMiddleware: Middleware {
    init() {}

    func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        request.repositories
            .get(for: DefaultRepository<Message>.self)
            .deleteExpired()
            .flatMap { next.respond(to: request) }
    }
}
