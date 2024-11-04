@import Foundation;

typedef NS_OPTIONS(int, VLCMediaParsingOptions) {
  VLCMediaParseLocal          = 0x00,     ///< Parse media if it's a local file
  VLCMediaParseNetwork        = 0x01,     ///< Parse media even if it's a network file
  VLCMediaFetchLocal          = 0x02,     ///< Fetch meta and covert art using local resources
  VLCMediaFetchNetwork        = 0x04,     ///< Fetch meta and covert art using network resources
  VLCMediaDoInteract          = 0x08,     ///< Interact with the user when preparsing this item (and not its sub items). Set this flag in order to receive a callback when the input is asking for credentials.
};


NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Object)

+ (void)inputOptions:(VLCMediaParsingOptions)options;

@end

NS_ASSUME_NONNULL_END
