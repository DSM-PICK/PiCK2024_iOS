import Domain

public struct ServiceDI {
    public static let shared = resolve()

    // Auth
    public let loginUseCase: LoginUseCase
}

extension ServiceDI {
    private static func resolve() -> ServiceDI {
        let authRepo = AuthRepositoryImpl()

        // MARK: Auth관련 UseCase
        let loginUseCaseInject = LoginUseCase(
            authRepository: authRepo
        )

        return .init(
            loginUseCase: loginUseCaseInject
        )
    }
    
}
