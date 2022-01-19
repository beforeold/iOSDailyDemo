#import <Foundation/NSArray.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSError.h>
#import <Foundation/NSObject.h>
#import <Foundation/NSSet.h>
#import <Foundation/NSString.h>
#import <Foundation/NSValue.h>

@class SharedMtopRequestContext, SharedAccountInfo, SharedBaseContext, SharedObserver<T>, SharedLiveData<T>, SharedViewModelProvider, SharedBaseRepository, SharedViewModel, SharedFollowContext, SharedFollowDataItem, SharedMutableLiveData<T>, SharedBaseService, SharedBaseEntity, SharedFeedBaseInfo, SharedFeedContentV1, SharedFeedContentV2, SharedInteractiveInfo;

@protocol SharedMtopRequestToken, SharedMtopRequestObserver, SharedViewType, SharedAccountLoginHandler, SharedLifeCycle, SharedFollowRepositoryIRepositoryCallback;

NS_ASSUME_NONNULL_BEGIN
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunknown-warning-option"
#pragma clang diagnostic ignored "-Wincompatible-property-type"
#pragma clang diagnostic ignored "-Wnullability"

__attribute__((swift_name("KotlinBase")))
@interface SharedBase : NSObject
- (instancetype)init __attribute__((unavailable));
+ (instancetype)new __attribute__((unavailable));
+ (void)initialize __attribute__((objc_requires_super));
@end;

@interface SharedBase (SharedBaseCopying) <NSCopying>
@end;

__attribute__((swift_name("KotlinMutableSet")))
@interface SharedMutableSet<ObjectType> : NSMutableSet<ObjectType>
@end;

__attribute__((swift_name("KotlinMutableDictionary")))
@interface SharedMutableDictionary<KeyType, ObjectType> : NSMutableDictionary<KeyType, ObjectType>
@end;

@interface NSError (NSErrorSharedKotlinException)
@property (readonly) id _Nullable kotlinException;
@end;

__attribute__((swift_name("KotlinNumber")))
@interface SharedNumber : NSNumber
- (instancetype)initWithChar:(char)value __attribute__((unavailable));
- (instancetype)initWithUnsignedChar:(unsigned char)value __attribute__((unavailable));
- (instancetype)initWithShort:(short)value __attribute__((unavailable));
- (instancetype)initWithUnsignedShort:(unsigned short)value __attribute__((unavailable));
- (instancetype)initWithInt:(int)value __attribute__((unavailable));
- (instancetype)initWithUnsignedInt:(unsigned int)value __attribute__((unavailable));
- (instancetype)initWithLong:(long)value __attribute__((unavailable));
- (instancetype)initWithUnsignedLong:(unsigned long)value __attribute__((unavailable));
- (instancetype)initWithLongLong:(long long)value __attribute__((unavailable));
- (instancetype)initWithUnsignedLongLong:(unsigned long long)value __attribute__((unavailable));
- (instancetype)initWithFloat:(float)value __attribute__((unavailable));
- (instancetype)initWithDouble:(double)value __attribute__((unavailable));
- (instancetype)initWithBool:(BOOL)value __attribute__((unavailable));
- (instancetype)initWithInteger:(NSInteger)value __attribute__((unavailable));
- (instancetype)initWithUnsignedInteger:(NSUInteger)value __attribute__((unavailable));
+ (instancetype)numberWithChar:(char)value __attribute__((unavailable));
+ (instancetype)numberWithUnsignedChar:(unsigned char)value __attribute__((unavailable));
+ (instancetype)numberWithShort:(short)value __attribute__((unavailable));
+ (instancetype)numberWithUnsignedShort:(unsigned short)value __attribute__((unavailable));
+ (instancetype)numberWithInt:(int)value __attribute__((unavailable));
+ (instancetype)numberWithUnsignedInt:(unsigned int)value __attribute__((unavailable));
+ (instancetype)numberWithLong:(long)value __attribute__((unavailable));
+ (instancetype)numberWithUnsignedLong:(unsigned long)value __attribute__((unavailable));
+ (instancetype)numberWithLongLong:(long long)value __attribute__((unavailable));
+ (instancetype)numberWithUnsignedLongLong:(unsigned long long)value __attribute__((unavailable));
+ (instancetype)numberWithFloat:(float)value __attribute__((unavailable));
+ (instancetype)numberWithDouble:(double)value __attribute__((unavailable));
+ (instancetype)numberWithBool:(BOOL)value __attribute__((unavailable));
+ (instancetype)numberWithInteger:(NSInteger)value __attribute__((unavailable));
+ (instancetype)numberWithUnsignedInteger:(NSUInteger)value __attribute__((unavailable));
@end;

__attribute__((swift_name("KotlinByte")))
@interface SharedByte : SharedNumber
- (instancetype)initWithChar:(char)value;
+ (instancetype)numberWithChar:(char)value;
@end;

__attribute__((swift_name("KotlinUByte")))
@interface SharedUByte : SharedNumber
- (instancetype)initWithUnsignedChar:(unsigned char)value;
+ (instancetype)numberWithUnsignedChar:(unsigned char)value;
@end;

__attribute__((swift_name("KotlinShort")))
@interface SharedShort : SharedNumber
- (instancetype)initWithShort:(short)value;
+ (instancetype)numberWithShort:(short)value;
@end;

__attribute__((swift_name("KotlinUShort")))
@interface SharedUShort : SharedNumber
- (instancetype)initWithUnsignedShort:(unsigned short)value;
+ (instancetype)numberWithUnsignedShort:(unsigned short)value;
@end;

__attribute__((swift_name("KotlinInt")))
@interface SharedInt : SharedNumber
- (instancetype)initWithInt:(int)value;
+ (instancetype)numberWithInt:(int)value;
@end;

__attribute__((swift_name("KotlinUInt")))
@interface SharedUInt : SharedNumber
- (instancetype)initWithUnsignedInt:(unsigned int)value;
+ (instancetype)numberWithUnsignedInt:(unsigned int)value;
@end;

__attribute__((swift_name("KotlinLong")))
@interface SharedLong : SharedNumber
- (instancetype)initWithLongLong:(long long)value;
+ (instancetype)numberWithLongLong:(long long)value;
@end;

__attribute__((swift_name("KotlinULong")))
@interface SharedULong : SharedNumber
- (instancetype)initWithUnsignedLongLong:(unsigned long long)value;
+ (instancetype)numberWithUnsignedLongLong:(unsigned long long)value;
@end;

__attribute__((swift_name("KotlinFloat")))
@interface SharedFloat : SharedNumber
- (instancetype)initWithFloat:(float)value;
+ (instancetype)numberWithFloat:(float)value;
@end;

__attribute__((swift_name("KotlinDouble")))
@interface SharedDouble : SharedNumber
- (instancetype)initWithDouble:(double)value;
+ (instancetype)numberWithDouble:(double)value;
@end;

__attribute__((swift_name("KotlinBoolean")))
@interface SharedBoolean : SharedNumber
- (instancetype)initWithBool:(BOOL)value;
+ (instancetype)numberWithBool:(BOOL)value;
@end;

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Greeting")))
@interface SharedGreeting : SharedBase
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
- (NSString *)greeting __attribute__((swift_name("greeting()")));
@end;

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Platform")))
@interface SharedPlatform : SharedBase
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
@property (readonly) NSString *platform __attribute__((swift_name("platform")));
@end;

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MtopRequestContext")))
@interface SharedMtopRequestContext : SharedBase
- (instancetype)initWithApi:(NSString *)api version:(NSString *)version __attribute__((swift_name("init(api:version:)"))) __attribute__((objc_designated_initializer));
@property (readonly) NSString *api __attribute__((swift_name("api")));
@property NSDictionary<NSString *, NSString *> * _Nullable params __attribute__((swift_name("params")));
@property int32_t retryTimes __attribute__((swift_name("retryTimes")));
@property int32_t timeoutInSeconds __attribute__((swift_name("timeoutInSeconds")));
@property BOOL useHttpPost __attribute__((swift_name("useHttpPost")));
@property (readonly) NSString *version __attribute__((swift_name("version")));
@end;

__attribute__((swift_name("MtopRequestObserver")))
@protocol SharedMtopRequestObserver
@required
- (void)onFailedRequest:(SharedMtopRequestContext *)request errorCode:(NSString *)errorCode errorMsg:(NSString *)errorMsg __attribute__((swift_name("onFailed(request:errorCode:errorMsg:)")));
- (void)onStartedRequest:(SharedMtopRequestContext *)request __attribute__((swift_name("onStarted(request:)")));
- (void)onSucceedRequest:(SharedMtopRequestContext *)request response:(NSString * _Nullable)response __attribute__((swift_name("onSucceed(request:response:)")));
@end;

__attribute__((swift_name("MtopRequestToken")))
@protocol SharedMtopRequestToken
@required
- (void)cancel __attribute__((swift_name("cancel()")));
@property (readonly) BOOL isCancelled __attribute__((swift_name("isCancelled")));
@end;

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MtopService")))
@interface SharedMtopService : SharedBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)mtopService __attribute__((swift_name("init()")));
- (id<SharedMtopRequestToken> _Nullable)asyncCallRequestRequestContext:(SharedMtopRequestContext *)requestContext observer:(id<SharedMtopRequestObserver> _Nullable)observer startFilter:(NSString * _Nullable)startFilter __attribute__((swift_name("asyncCallRequest(requestContext:observer:startFilter:)")));
@end;

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("UtTracker")))
@interface SharedUtTracker : SharedBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)utTracker __attribute__((swift_name("init()")));
- (void)pageAppearPPageObject:(id)pPageObject __attribute__((swift_name("pageAppear(pPageObject:)")));
- (void)pageAppearPPageObject:(id)pPageObject pageName:(NSString * _Nullable)pageName __attribute__((swift_name("pageAppear(pPageObject:pageName:)")));
- (void)pageDisAppearPPageObject:(id)pPageObject __attribute__((swift_name("pageDisAppear(pPageObject:)")));
- (void)sendEventEventId:(int32_t)eventId pageName:(NSString *)pageName arg1:(NSString *)arg1 arg2:(NSString * _Nullable)arg2 arg3:(NSString * _Nullable)arg3 args:(NSDictionary<NSString *, NSString *> * _Nullable)args __attribute__((swift_name("sendEvent(eventId:pageName:arg1:arg2:arg3:args:)")));
- (void)setExposureView:(id<SharedViewType>)view block:(NSString *)block viewId:(NSString *)viewId args:(NSDictionary<NSString *, id> * _Nullable)args pageName:(NSString * _Nullable)pageName __attribute__((swift_name("setExposure(view:block:viewId:args:pageName:)")));
- (void)updateNextPageProperties:(NSDictionary<NSString *, NSString *> *)properties __attribute__((swift_name("updateNextPage(properties:)")));
- (void)updatePageNamePPageObject:(id)pPageObject pageName:(NSString *)pageName __attribute__((swift_name("updatePageName(pPageObject:pageName:)")));
- (void)updatePagePropertiesPPageObject:(id)pPageObject properties:(NSDictionary<NSString *, id> *)properties __attribute__((swift_name("updatePageProperties(pPageObject:properties:)")));
- (void)updatePageUrlPPageObject:(id)pPageObject url:(NSString *)url __attribute__((swift_name("updatePageUrl(pPageObject:url:)")));
@end;

__attribute__((swift_name("ViewType")))
@protocol SharedViewType
@required
@end;

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("OCUtil")))
@interface SharedOCUtil : SharedBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)oCUtil __attribute__((swift_name("init()")));
- (NSDictionary<id, id> *)castMap:(NSDictionary<NSString *, id> * _Nullable)map __attribute__((swift_name("cast(map:)")));
@end;

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("AccountInfo")))
@interface SharedAccountInfo : SharedBase
- (instancetype)initWithUserId:(NSString *)userId name:(NSString *)name avatar:(NSString * _Nullable)avatar __attribute__((swift_name("init(userId:name:avatar:)"))) __attribute__((objc_designated_initializer));
- (NSString *)component1 __attribute__((swift_name("component1()")));
- (NSString *)component2 __attribute__((swift_name("component2()")));
- (NSString * _Nullable)component3 __attribute__((swift_name("component3()")));
- (SharedAccountInfo *)doCopyUserId:(NSString *)userId name:(NSString *)name avatar:(NSString * _Nullable)avatar __attribute__((swift_name("doCopy(userId:name:avatar:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property (readonly) NSString * _Nullable avatar __attribute__((swift_name("avatar")));
@property (readonly) NSString *name __attribute__((swift_name("name")));
@property (readonly) NSString *userId __attribute__((swift_name("userId")));
@end;

__attribute__((swift_name("AccountLoginHandler")))
@protocol SharedAccountLoginHandler
@required
- (void)onCancel __attribute__((swift_name("onCancel()")));
- (void)onSuccessIsRegister:(BOOL)isRegister __attribute__((swift_name("onSuccess(isRegister:)")));
@end;

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("AccountProvider")))
@interface SharedAccountProvider : SharedBase
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
- (SharedAccountInfo * _Nullable)getAccountInfo __attribute__((swift_name("getAccountInfo()")));
- (BOOL)isLogin __attribute__((swift_name("isLogin()")));
- (void)loginLoginHandler:(id<SharedAccountLoginHandler>)loginHandler __attribute__((swift_name("login(loginHandler:)")));
@property NSString * _Nullable bizScene __attribute__((swift_name("bizScene")));
@property NSString * _Nullable spm __attribute__((swift_name("spm")));
@end;

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Navigator")))
@interface SharedNavigator : SharedBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)navigator __attribute__((swift_name("init()")));
- (BOOL)openUrl:(NSString * _Nullable)url target:(id _Nullable)target spm:(NSString * _Nullable)spm extraQueryInfo:(NSDictionary<NSString *, id> * _Nullable)extraQueryInfo nativeParams:(NSDictionary<NSString *, id> * _Nullable)nativeParams __attribute__((swift_name("open(url:target:spm:extraQueryInfo:nativeParams:)")));
@end;

__attribute__((swift_name("BaseContext")))
@interface SharedBaseContext : SharedBase
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
@property NSString *pageName __attribute__((swift_name("pageName")));
@property NSString *spm __attribute__((swift_name("spm")));
@end;

__attribute__((swift_name("BaseEntity")))
@interface SharedBaseEntity : SharedBase
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
@end;

__attribute__((swift_name("BaseService")))
@interface SharedBaseService : SharedBase
- (instancetype)initWithContext:(SharedBaseContext *)context __attribute__((swift_name("init(context:)"))) __attribute__((objc_designated_initializer));
- (void)onCreate __attribute__((swift_name("onCreate()")));
- (void)onDestroy __attribute__((swift_name("onDestroy()")));
@end;

__attribute__((swift_name("BaseRepository")))
@interface SharedBaseRepository : SharedBase
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
- (NSString *)getApiName __attribute__((swift_name("getApiName()")));
- (void)onFail __attribute__((swift_name("onFail()")));
- (void)onSucceed __attribute__((swift_name("onSucceed()")));
@end;

__attribute__((swift_name("LifeCycle")))
@protocol SharedLifeCycle
@required
- (void)onActive __attribute__((swift_name("onActive()")));
- (void)onBackground __attribute__((swift_name("onBackground()")));
- (void)onDestroy __attribute__((swift_name("onDestroy()")));
@end;

__attribute__((swift_name("LiveData")))
@interface SharedLiveData<T> : SharedBase
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
- (T _Nullable)getValue __attribute__((swift_name("getValue()")));
- (void)observeObserver:(SharedObserver<T> *)observer __attribute__((swift_name("observe(observer:)")));
- (void)setValueValue:(T _Nullable)value __attribute__((swift_name("setValue(value:)")));
@end;

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("MutableLiveData")))
@interface SharedMutableLiveData<T> : SharedLiveData<T>
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
- (void)setValueValue:(T _Nullable)value __attribute__((swift_name("setValue(value:)")));
@end;

__attribute__((swift_name("Observer")))
@interface SharedObserver<T> : SharedBase
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
- (void)onChangedT:(T _Nullable)t __attribute__((swift_name("onChanged(t:)")));
@end;

__attribute__((swift_name("ViewModel")))
@interface SharedViewModel : SharedBase
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
- (void)onCleared __attribute__((swift_name("onCleared()")));
@end;

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ViewModelProvider")))
@interface SharedViewModelProvider : SharedBase
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
@end;

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ViewModelProviders")))
@interface SharedViewModelProviders : SharedBase
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
@end;

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ViewModelProviders.Companion")))
@interface SharedViewModelProvidersCompanion : SharedBase
+ (instancetype)alloc __attribute__((unavailable));
+ (instancetype)allocWithZone:(struct _NSZone *)zone __attribute__((unavailable));
+ (instancetype)companion __attribute__((swift_name("init()")));
- (SharedViewModelProvider *)ofLifeCycle:(id<SharedLifeCycle>)lifeCycle __attribute__((swift_name("of(lifeCycle:)")));
@end;

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("ViewModelStore")))
@interface SharedViewModelStore : SharedBase
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
@end;

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("FollowContext")))
@interface SharedFollowContext : SharedBaseContext
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
@property NSString *tabName __attribute__((swift_name("tabName")));
@end;

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("FollowRepository")))
@interface SharedFollowRepository : SharedBaseRepository
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
- (void)followRequestScene:(NSString * _Nullable)scene followType:(int32_t)followType targetId:(NSString *)targetId pageName:(NSString * _Nullable)pageName tabName:(NSString * _Nullable)tabName extArgs:(NSString * _Nullable)extArgs callback:(id<SharedFollowRepositoryIRepositoryCallback>)callback __attribute__((swift_name("followRequest(scene:followType:targetId:pageName:tabName:extArgs:callback:)")));
- (NSString *)getApiName __attribute__((swift_name("getApiName()")));
- (void)unFollow __attribute__((swift_name("unFollow()")));
@end;

__attribute__((swift_name("FollowRepositoryIRepositoryCallback")))
@protocol SharedFollowRepositoryIRepositoryCallback
@required
- (void)onFailedErrorCode:(NSString * _Nullable)errorCode errorMsg:(NSString * _Nullable)errorMsg __attribute__((swift_name("onFailed(errorCode:errorMsg:)")));
- (void)onSuccessResult:(id _Nullable)result __attribute__((swift_name("onSuccess(result:)")));
@end;

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("FollowViewModel")))
@interface SharedFollowViewModel : SharedViewModel
- (instancetype)initWithMFollowContext:(SharedFollowContext *)mFollowContext __attribute__((swift_name("init(mFollowContext:)"))) __attribute__((objc_designated_initializer));
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
+ (instancetype)new __attribute__((unavailable));
- (SharedMutableLiveData<SharedFollowDataItem *> *)getRenderLiveData __attribute__((swift_name("getRenderLiveData()")));
- (void)onFollow __attribute__((swift_name("onFollow()")));
- (void)onUnFollow __attribute__((swift_name("onUnFollow()")));
- (void)setInitDataItem:(SharedFollowDataItem *)item __attribute__((swift_name("setInitData(item:)")));
@property (readonly) SharedFollowContext *mFollowContext __attribute__((swift_name("mFollowContext")));
@property SharedMutableLiveData<SharedFollowDataItem *> *mRenderEntityLiveData __attribute__((swift_name("mRenderEntityLiveData")));
@end;

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("FollowWidgetService")))
@interface SharedFollowWidgetService : SharedBaseService
- (instancetype)initWithFollowContext:(SharedFollowContext *)followContext __attribute__((swift_name("init(followContext:)"))) __attribute__((objc_designated_initializer));
- (instancetype)initWithContext:(SharedBaseContext *)context __attribute__((swift_name("init(context:)"))) __attribute__((objc_designated_initializer)) __attribute__((unavailable));
- (void)observerDataObserver:(SharedObserver<SharedFollowDataItem *> *)observer __attribute__((swift_name("observerData(observer:)")));
- (void)onClick __attribute__((swift_name("onClick()")));
- (void)setInitDataItem:(SharedFollowDataItem *)item __attribute__((swift_name("setInitData(item:)")));
- (void)updatePageUt __attribute__((swift_name("updatePageUt()")));
@property (readonly) SharedFollowContext *followContext __attribute__((swift_name("followContext")));
@end;

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("Atmosphere")))
@interface SharedAtmosphere : SharedBaseEntity
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
@end;

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("FeedBaseInfo")))
@interface SharedFeedBaseInfo : SharedBaseEntity
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
@property int32_t authorId __attribute__((swift_name("authorId")));
@property int32_t authorType __attribute__((swift_name("authorType")));
@property NSString *campaignId __attribute__((swift_name("campaignId")));
@property NSString *clickTrackInfo __attribute__((swift_name("clickTrackInfo")));
@property NSString *descriptionSummary __attribute__((swift_name("descriptionSummary")));
@property NSString *descriptionTitle __attribute__((swift_name("descriptionTitle")));
@property NSString *detailUrl __attribute__((swift_name("detailUrl")));
@property (readonly) int64_t feedID __attribute__((swift_name("feedID")));
@property NSString *feedLabel __attribute__((swift_name("feedLabel")));
@property int32_t feedType __attribute__((swift_name("feedType")));
@property NSString *followExtArgs __attribute__((swift_name("followExtArgs")));
@property NSString *landingPageTitle __attribute__((swift_name("landingPageTitle")));
@property NSString *landingViewUrl __attribute__((swift_name("landingViewUrl")));
@property NSString *productListTitle __attribute__((swift_name("productListTitle")));
@property int64_t publishTime __attribute__((swift_name("publishTime")));
@property int32_t renderType __attribute__((swift_name("renderType")));
@property NSString *scm __attribute__((swift_name("scm")));
@property BOOL supportReport __attribute__((swift_name("supportReport")));
@property int32_t templateType __attribute__((swift_name("templateType")));
@property NSString *trackInfo __attribute__((swift_name("trackInfo")));
@end;

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("FeedContentV1")))
@interface SharedFeedContentV1 : SharedBaseEntity
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
@end;

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("FeedContentV2")))
@interface SharedFeedContentV2 : SharedBaseEntity
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
@end;

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("FeedDividerInfo")))
@interface SharedFeedDividerInfo : SharedBaseEntity
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
@end;

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("FeedItemDataEntity")))
@interface SharedFeedItemDataEntity : SharedBaseEntity
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
@property SharedFeedBaseInfo *feedBaseInfo __attribute__((swift_name("feedBaseInfo")));
@property SharedFeedContentV1 *feedContent __attribute__((swift_name("feedContent")));
@property SharedFeedContentV2 *feedContentV2 __attribute__((swift_name("feedContentV2")));
@property SharedInteractiveInfo *interactiveInfo __attribute__((swift_name("interactiveInfo")));
@property BOOL isCache __attribute__((swift_name("isCache")));
@property BOOL isFollow __attribute__((swift_name("isFollow")));
@property NSString *showText __attribute__((swift_name("showText")));
@end;

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("FeedOperatorInfo")))
@interface SharedFeedOperatorInfo : SharedBaseEntity
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
@end;

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("InteractiveInfo")))
@interface SharedInteractiveInfo : SharedBaseEntity
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
@end;

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("KolUserInfo")))
@interface SharedKolUserInfo : SharedBase
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
@end;

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("SellerProfile")))
@interface SharedSellerProfile : SharedBaseEntity
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
@end;

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("StoreInfo")))
@interface SharedStoreInfo : SharedBaseEntity
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
@end;

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("FollowDataItem")))
@interface SharedFollowDataItem : SharedBase
- (instancetype)initWithIsFollow:(BOOL)isFollow __attribute__((swift_name("init(isFollow:)"))) __attribute__((objc_designated_initializer));
- (BOOL)component1 __attribute__((swift_name("component1()")));
- (SharedFollowDataItem *)doCopyIsFollow:(BOOL)isFollow __attribute__((swift_name("doCopy(isFollow:)")));
- (BOOL)isEqual:(id _Nullable)other __attribute__((swift_name("isEqual(_:)")));
- (NSUInteger)hash __attribute__((swift_name("hash()")));
- (BOOL)isKol __attribute__((swift_name("isKol()")));
- (BOOL)isStore __attribute__((swift_name("isStore()")));
- (BOOL)showFollow __attribute__((swift_name("showFollow()")));
- (NSString *)description __attribute__((swift_name("description()")));
@property NSString * _Nullable clickTrackInfo __attribute__((swift_name("clickTrackInfo")));
@property BOOL disableKolFollow __attribute__((swift_name("disableKolFollow")));
@property NSString * _Nullable followExtArgs __attribute__((swift_name("followExtArgs")));
@property NSString *followId __attribute__((swift_name("followId")));
@property int32_t followType __attribute__((swift_name("followType")));
@property BOOL isFollow __attribute__((swift_name("isFollow")));
@property BOOL isLoading __attribute__((swift_name("isLoading")));
@property NSString * _Nullable scm __attribute__((swift_name("scm")));
@property NSString *visitUrl __attribute__((swift_name("visitUrl")));
@end;

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("FollowRenderEntity")))
@interface SharedFollowRenderEntity : SharedBase
- (instancetype)init __attribute__((swift_name("init()"))) __attribute__((objc_designated_initializer));
+ (instancetype)new __attribute__((availability(swift, unavailable, message="use object initializers instead")));
@property BOOL isFollow __attribute__((swift_name("isFollow")));
@property NSString *showText __attribute__((swift_name("showText")));
@end;

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("UtTrackerKt")))
@interface SharedUtTrackerKt : SharedBase
@property (class, readonly) int32_t UT_EVENT_CLICK __attribute__((swift_name("UT_EVENT_CLICK")));
@property (class, readonly) int32_t UT_EVENT_CUSTOM __attribute__((swift_name("UT_EVENT_CUSTOM")));
@property (class, readonly) int32_t UT_EVENT_EXPOSE __attribute__((swift_name("UT_EVENT_EXPOSE")));
@property (class, readonly) int32_t UT_EVENT_PAGE __attribute__((swift_name("UT_EVENT_PAGE")));
@property (class, readonly) NSString *UT_KEY_SPM __attribute__((swift_name("UT_KEY_SPM")));
@end;

__attribute__((objc_subclassing_restricted))
__attribute__((swift_name("FollowDataItemKt")))
@interface SharedFollowDataItemKt : SharedBase
@property (class, readonly) int32_t USER_TYPE_KOL __attribute__((swift_name("USER_TYPE_KOL")));
@property (class, readonly) int32_t USER_TYPE_STORE __attribute__((swift_name("USER_TYPE_STORE")));
@end;

#pragma clang diagnostic pop
NS_ASSUME_NONNULL_END
