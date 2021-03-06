import Foundation

/// Instances of this class are capable of decoding CSV files as described by the `Codable` protocol.
@dynamicMemberLookup open class CSVDecoder {
    /// Wrap all configurations in a single easy-to-use structure.
    private final var _configuration: Configuration
    /// A dictionary you use to customize the decoding process by providing contextual information.
    open var userInfo: [CodingUserInfoKey:Any]
    
    /// Creates a CSV decoder with tthe default configuration values.
    /// - parameter configuration: Configuration values for the decoding process.
    public init(configuration: Configuration = .init()) {
        self._configuration = configuration
        self.userInfo = .init()
    }
    
    /// Creates a CSV decoder and passes the default configuration values to the closure.
    /// - parameter configuration: A closure receiving the default configuration values and returning (by `inout`) a tweaked version of them.
    @inlinable public convenience init(configuration: (inout Configuration)->Void) {
        var config = Configuration()
        configuration(&config)
        self.init(configuration: config)
    }
    
    /// Gives direct access to all the decoder's configuration values.
    /// - parameter member: Writable key path for the decoder's configuration value.
    public final subscript<V>(dynamicMember member: WritableKeyPath<CSVDecoder.Configuration,V>) -> V {
        get { self._configuration[keyPath: member] }
        set { self._configuration[keyPath: member] = newValue }
    }
}

extension CSVDecoder {
    /// Returns a value of the type you specify, decoded from a CSV file (given as a `Data` blob).
    /// - parameter type: The type of the value to decode from the supplied file.
    /// - parameter data: The data blob representing a CSV file.
    /// - throws: `DecodingError`, or `CSVError<CSVReader>`, or the error raised by your custom types.
    open func decode<T:Decodable>(_ type: T.Type, from data: Data) throws -> T {
        let reader = try CSVReader(input: data, configuration: self._configuration.readerConfiguration)
        let source = ShadowDecoder.Source(reader: reader, configuration: self._configuration, userInfo: self.userInfo)
        return try T(from: ShadowDecoder(source: source, codingPath: []))
    }
    
    /// Returns a value of the type you specify, decoded from a CSV file (given as a `String`).
    /// - parameter type: The type of the value to decode from the supplied file.
    /// - parameter string: A Swift string representing a CSV file.
    /// - throws: `DecodingError`, or `CSVError<CSVReader>`, or the error raised by your custom types.
    open func decode<T:Decodable>(_ type: T.Type, from string: String) throws -> T {
        let reader = try CSVReader(input: string, configuration: self._configuration.readerConfiguration)
        let source = ShadowDecoder.Source(reader: reader, configuration: self._configuration, userInfo: self.userInfo)
        return try T(from: ShadowDecoder(source: source, codingPath: []))
    }
    
    /// Returns a value of the type you specify, decoded from a CSV file (being pointed by `url`).
    /// - parameter type: The type of the value to decode from the supplied file.
    /// - parameter url: The URL pointing to the file to decode.
    /// - throws: `DecodingError`, or `CSVError<CSVReader>`, or the error raised by your custom types.
    open func decode<T:Decodable>(_ type: T.Type, from url: URL) throws -> T {
        let reader = try CSVReader(input: url, configuration: self._configuration.readerConfiguration)
        let source = ShadowDecoder.Source(reader: reader, configuration: self._configuration, userInfo: self.userInfo)
        return try T(from: ShadowDecoder(source: source, codingPath: []))
    }
}

extension CSVDecoder {
    /// Returns a sequence for decoding each row from a CSV file (given as a `Data` blob).
    /// - parameter data: The data blob representing a CSV file.
    /// - throws: `CSVError<CSVReader>` exclusively.
    open func lazy(from data: Data) throws -> LazySequence {
        let reader = try CSVReader(input: data, configuration: self._configuration.readerConfiguration)
        let source = ShadowDecoder.Source(reader: reader, configuration: self._configuration, userInfo: self.userInfo)
        return LazySequence(source: source)
    }
    
    /// Returns a sequence for decoding each row from a CSV file (given as a `String`).
    /// - parameter string: A Swift string representing a CSV file.
    /// - throws: `CSVError<CSVReader>` exclusively. 
    open func lazy(from string: String) throws -> LazySequence {
        let reader = try CSVReader(input: string, configuration: self._configuration.readerConfiguration)
        let source = ShadowDecoder.Source(reader: reader, configuration: self._configuration, userInfo: self.userInfo)
        return LazySequence(source: source)
    }

    /// Returns a sequence for decoding each row from a CSV file (being pointed by `url`).
    /// - parameter url: The URL pointing to the file to decode.
    /// - throws: `CSVError<CSVReader>` exclusively.
    open func lazy(from url: URL) throws -> LazySequence {
        let reader = try CSVReader(input: url, configuration: self._configuration.readerConfiguration)
        let source = ShadowDecoder.Source(reader: reader, configuration: self._configuration, userInfo: self.userInfo)
        return LazySequence(source: source)
    }
}
