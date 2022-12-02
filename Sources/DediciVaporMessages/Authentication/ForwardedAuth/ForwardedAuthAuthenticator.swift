//
// Copyright (c) 2022 Dediĉi
// SPDX-License-Identifier: AGPL-3.0-only
//

import Fluent
import Foundation
import NIO
import DediciVaporToolbox
import Vapor

internal struct ForwardedAuthAuthenticator {}

extension ForwardedAuthAuthenticator: RequestAuthenticator {
    func authenticate(request: Request) -> EventLoopFuture<Void> {
        guard
            let authResult = request.headers.nxServerAuthResult,
            let identityIdString = authResult.extraAuth?["identity"]?.object?["identityId"]?.string,
            let identityId = UUIDv4(identityIdString)
        else { return request.eventLoop.makeSucceededFuture(()) }

        request.auth.login(ForwardedAuthResult(userId: authResult.userId, identityId: identityId))

        return request.eventLoop.makeSucceededFuture(())
    }
}
