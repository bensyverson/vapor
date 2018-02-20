import Routing

/// Capable of registering async routes.
extension Router {
    /// Registers a route handler at the supplied path.
    @discardableResult
    public func on<T>(
        _ method: HTTPMethod,
        at path: [PathComponent],
        use closure: @escaping RouteResponder<T>.Closure
    ) -> Route<Responder> where T: ResponseEncodable {
        let responder = RouteResponder(closure: closure)
        let route = Route<Responder>(
            path: [.constants([.bytes(method.bytes)])] + path,
            output: responder
        )
        self.register(route: route)
        return route
    }
    
    /// Registers a route handler at the supplied path.
    @discardableResult
    fileprivate func on<C, T>(
        _ method: HTTPMethod,
        at path: [PathComponent],
        use closure: @escaping RequestDecodableResponder<C, T>.Closure
    ) -> Route<Responder> where C: RequestDecodable, T: ResponseEncodable {
        let responder = RequestDecodableResponder(closure: closure)
        let route = Route<Responder>(
            path: [.constants([.bytes(method.bytes)])] + path,
            output: responder
        )
        self.register(route: route)
        return route
    }
}

extension Future: ResponseEncodable where T: ResponseEncodable {
    /// See ResponseEncodable.encode
    public func encode(for req: Request) throws -> Future<Response> {
        return flatMap(to: Response.self) { exp in
            try exp.encode(for: req)
        }
    }
}

extension Router {
    /// Creates a `Route` at the provided path using the `GET` method.
    ///
    /// [Learn More →](https://docs.vapor.codes/3.0/getting-started/routing/)
    @discardableResult
    public func get<T>(
        _ path: PathComponent...,
        use closure: @escaping RouteResponder<T>.Closure
    ) -> Route<Responder> where T: ResponseEncodable {
        return self.on(.get, at: path, use: closure)
    }

    /// Creates a `Route` at the provided path using the `PUT` method.
    ///
    /// [Learn More →](https://docs.vapor.codes/3.0/getting-started/routing/)
    @discardableResult
    public func put<T>(
        _ path: PathComponent...,
        use closure: @escaping RouteResponder<T>.Closure
    ) -> Route<Responder> where T: ResponseEncodable {
        return self.on(.put, at: path, use: closure)
    }

    /// Creates a `Route` at the provided path using the `POST` method.
    ///
    /// [Learn More →](https://docs.vapor.codes/3.0/getting-started/routing/)
    @discardableResult
    public func post<T>(
        _ path: PathComponent...,
        use closure: @escaping RouteResponder<T>.Closure
    ) -> Route<Responder> where T: ResponseEncodable {
        return self.on(.post, at: path, use: closure)
    }

    /// Creates a `Route` at the provided path using the `DELETE` method.
    ///
    /// [Learn More →](https://docs.vapor.codes/3.0/getting-started/routing/)
    @discardableResult
    public func delete<T>(
        _ path: PathComponent...,
        use closure: @escaping RouteResponder<T>.Closure
    ) -> Route<Responder> where T: ResponseEncodable {
        return self.on(.delete, at: path, use: closure)
    }

    /// Creates a `Route` at the provided path using the `PATCH` method.
    ///
    /// [Learn More →](https://docs.vapor.codes/3.0/getting-started/routing/)
    @discardableResult
    public func patch<T>(
        _ path: PathComponent...,
        use closure: @escaping RouteResponder<T>.Closure
    ) -> Route<Responder> where T: ResponseEncodable {
        return self.on(.patch, at: path, use: closure)
    }
}

extension Router {
    /// Creates a `Route` at the provided path using the `PUT` method.
    ///
    /// [Learn More →](https://docs.vapor.codes/3.0/getting-started/routing/)
    @discardableResult
    public func put<C, T>(
        _ content: C.Type,
        at path: PathComponent...,
        use closure: @escaping RequestDecodableResponder<C, T>.Closure
    ) -> Route<Responder> where C: RequestDecodable, T: ResponseEncodable {
        return self.on(.put, at: path, use: closure)
    }
    
    /// Creates a `Route` at the provided path using the `POST` method.
    ///
    /// [Learn More →](https://docs.vapor.codes/3.0/getting-started/routing/)
    @discardableResult
    public func post<C, T>(
        _ content: C.Type,
        at path: PathComponent...,
        use closure: @escaping RequestDecodableResponder<C, T>.Closure
    ) -> Route<Responder> where C: RequestDecodable, T: ResponseEncodable {
        return self.on(.post, at: path, use: closure)
    }
    
    /// Creates a `Route` at the provided path using the `PATCH` method.
    ///
    /// [Learn More →](https://docs.vapor.codes/3.0/getting-started/routing/)
    @discardableResult
    public func patch<C, T>(
        _ content: C.Type,
        at path: PathComponent...,
        use closure: @escaping RequestDecodableResponder<C, T>.Closure
    ) -> Route<Responder> where C: RequestDecodable, T: ResponseEncodable {
        return self.on(.patch, at: path, use: closure)
    }
}
