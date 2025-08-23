import QuickHatchHTTP
import Testing
import Foundation

struct PublicKeyPinningStrateyTests {
    
    private let publicKey = "TzmA8j7eqlCvjs2Sx3wEJ9DRJSFjizmNi1sx3Hvc7yo="
    private let certificate: SecCertificate? = Stubs.CertificatePinner.certificate
    
    @Test(arguments: [("TzmA8j7eqlCvjs2Sx3wEJ9DRJSFjizmNi1sx3Hvc7yo=", true),
                     ("publickey", false)])
    func validate_expectValidationCorrect(publicKeyMock: String,
                                          testResult: Bool) throws {
        let sut = PublicKeyPinningStrategy(publicKeys: [publicKeyMock], hasher: CKSHA256Hasher())
        let certificate = try #require(Stubs.CertificatePinner.fakeChallenge(with: Stubs.CertificatePinner.certificate))
        let serverTrust = try #require(certificate.protectionSpace.serverTrust)
        
        let result = sut.validate(serverTrust: serverTrust)
        
        #expect(result == testResult)
    }
}
