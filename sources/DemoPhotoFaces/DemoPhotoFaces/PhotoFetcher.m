#import "PhotoFetcher.h"

@import Photos;
#import <float.h>

@interface PhotoFetcher ()

- (void)enumerateSmartAlbumsAcrossSubtypes;
- (void)runMetadataTimingTest;
- (void)requestPhotoAccessWithAuthorized:(dispatch_block_t)authorizedBlock;

@end

@implementation PhotoFetcher

- (void)test {
    [self requestPhotoAccessWithAuthorized:^{
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            [self enumerateSmartAlbumsAcrossSubtypes];
        });
    }];
}

- (void)testMetadataRequestTime {
    [self requestPhotoAccessWithAuthorized:^{
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
            [self runMetadataTimingTest];
        });
    }];
}

- (void)enumerateSmartAlbumsAcrossSubtypes {
    NSLog(@"PhotoFetcher.test: Enumerating smart albums (subtype raw values 0–300)");
    for (NSInteger rawSubtype = 0; rawSubtype <= 300; rawSubtype++) {
        PHAssetCollectionSubtype subtype = (PHAssetCollectionSubtype)rawSubtype;
        PHFetchResult<PHAssetCollection *> *result =
            [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                     subtype:subtype
                                                     options:nil];
        if (result.count == 0) {
            continue;
        }

        NSLog(@"Subtype %ld yielded %lu collection(s)", (long)rawSubtype, (unsigned long)result.count);
        [result enumerateObjectsUsingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL *stop) {
            PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
            NSString *title = collection.localizedTitle ?: @"<Untitled>";
            NSLog(@"  [%lu] %@ | assets: %lu | subtype: %ld | canContainAssets: %@ | canContainCollections: %@",
                  (unsigned long)idx,
                  title,
                  (unsigned long)assets.count,
                  (long)collection.assetCollectionSubtype,
                  collection.canContainAssets ? @"YES" : @"NO",
                  collection.canContainCollections ? @"YES" : @"NO");
        }];
    }
}

- (void)runMetadataTimingTest {
    NSLog(@"PhotoFetcher.testMetadataRequestTime: requesting metadata for latest 100 assets");

    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    fetchOptions.fetchLimit = 100;

    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsWithOptions:fetchOptions];
    if (assets.count == 0) {
        NSLog(@"PhotoFetcher.testMetadataRequestTime: no assets found.");
        return;
    }

    PHContentEditingInputRequestOptions *inputOptions = [[PHContentEditingInputRequestOptions alloc] init];
    inputOptions.canHandleAdjustmentData = ^BOOL(PHAdjustmentData * _Nonnull adjustmentData) {
        return YES;
    };
    inputOptions.networkAccessAllowed = NO;

    dispatch_group_t group = dispatch_group_create();
    NSMutableArray<NSNumber *> *durations = [[NSMutableArray alloc] init];

    NSUInteger count = MIN((NSUInteger)assets.count, 100);
    for (NSUInteger idx = 0; idx < count; idx++) {
        PHAsset *asset = assets[idx];
        dispatch_group_enter(group);
        NSDate *startDate = [NSDate date];

        [asset requestContentEditingInputWithOptions:inputOptions
                                   completionHandler:^(PHContentEditingInput * _Nullable input,
                                                       NSDictionary * _Nonnull info) {
            NSTimeInterval elapsed = [[NSDate date] timeIntervalSinceDate:startDate];
            @synchronized (durations) {
                [durations addObject:@(elapsed)];
            }

            BOOL cancelled = [info[PHImageCancelledKey] boolValue];
            NSError *error = info[PHImageErrorKey];
            NSArray<id<NSCopying>> *infoKeys = info.allKeys;
            if (cancelled) {
                NSLog(@"  Asset %@ metadata request cancelled (%.3fs)", asset.localIdentifier, elapsed);
            } else if (error) {
                NSLog(@"  Asset %@ metadata request failed (%.3fs) error: %@", asset.localIdentifier, elapsed, error);
            } else {
                NSString *typeDescription = [self descriptionForMediaType:asset.mediaType];
                NSLog(@"  Asset %@ (%@) metadata fetched in %.3fs", asset.localIdentifier, typeDescription, elapsed);
            }
            if (infoKeys.count > 0) {
                NSLog(@"    Info keys (%lu): %@", (unsigned long)infoKeys.count, infoKeys);
            } else {
                NSLog(@"    Info keys: <none>");
            }

            dispatch_group_leave(group);
        }];
    }

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (durations.count == 0) {
            NSLog(@"PhotoFetcher.testMetadataRequestTime: no metadata requests completed.");
            return;
        }

        double total = 0.0;
        double minValue = DBL_MAX;
        double maxValue = 0.0;
        for (NSNumber *value in durations) {
            double duration = value.doubleValue;
            total += duration;
            minValue = MIN(minValue, duration);
            maxValue = MAX(maxValue, duration);
        }
        double average = total / durations.count;

        NSLog(@"PhotoFetcher.testMetadataRequestTime: completed %lu request(s). Avg %.3fs, min %.3fs, max %.3fs",
              (unsigned long)durations.count,
              average,
              minValue,
              maxValue);
    });
}

- (void)requestPhotoAccessWithAuthorized:(dispatch_block_t)authorizedBlock {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatusForAccessLevel:PHAccessLevelReadWrite];
    if (status == PHAuthorizationStatusAuthorized || status == PHAuthorizationStatusLimited) {
        if (authorizedBlock) {
            dispatch_async(dispatch_get_main_queue(), authorizedBlock);
        }
        return;
    }

    if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorizationForAccessLevel:PHAccessLevelReadWrite
                                                   handler:^(PHAuthorizationStatus newStatus) {
            if (newStatus == PHAuthorizationStatusAuthorized || newStatus == PHAuthorizationStatusLimited) {
                if (authorizedBlock) {
                    dispatch_async(dispatch_get_main_queue(), authorizedBlock);
                }
            } else {
                NSLog(@"PhotoFetcher: photo library access denied.");
            }
        }];
        return;
    }

    NSLog(@"PhotoFetcher: photo library access denied.");
}

- (NSString *)descriptionForMediaType:(PHAssetMediaType)mediaType {
    switch (mediaType) {
        case PHAssetMediaTypeImage:
            return @"Image";
        case PHAssetMediaTypeVideo:
            return @"Video";
        case PHAssetMediaTypeAudio:
            return @"Audio";
        case PHAssetMediaTypeUnknown:
        default:
            return @"Unknown";
    }
}

@end
