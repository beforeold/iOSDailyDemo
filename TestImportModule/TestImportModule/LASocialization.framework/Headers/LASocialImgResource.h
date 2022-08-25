//
//  LASocialImgResource.h
//  AFNetworking
//
//  Created by Cheng Ma on 2019/10/29.
//

// #import <TBJSONModel/TBJSONModel.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LASocialImgResource <NSObject>

@end

@interface LASocialImgResource : NSObject/*brooked*/ <NSCoding>

@property(nonatomic, strong) NSString *key;
@property(nonatomic, strong) NSString *resId;
@property(nonatomic, strong) NSString *originalURL;
@property(nonatomic, strong) NSString *targetURL;
@property(nonatomic, strong) NSString *ratio;
@property(nonatomic, strong) NSString *sourceType;
@property(nonatomic, strong) NSString *matrix;

// Temporary use for edit page
@property(nonatomic, strong, nullable) NSString *strClippedRect;
@property(nonatomic, strong, nullable) UIImage *originalImage;

@end

@interface LASocialContentGenerateModel : NSObject/*brooked*/ <NSCoding>

@property(nonatomic, assign) NSInteger locateIndex;
@property(nonatomic, strong) NSArray<LASocialImgResource> *localImgList;
@property(nonatomic, strong) NSArray<LASocialImgResource> *localFileList;

@property(nonatomic, assign) BOOL enableClip;
@property(nonatomic, assign) NSInteger maxSelectCount;

@property(nonatomic, assign) BOOL needSend;

@property(nonatomic, strong) NSDictionary *trackInfo;
@property(nonatomic, strong) NSString *spmString;

@property(nonatomic, strong) id model;
@property(nonatomic, strong) NSString *contentString;
@end

NS_ASSUME_NONNULL_END
