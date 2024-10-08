#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <objc/message.h>

int main(int argc, char * argv[]) {
  @autoreleasepool {
    // 动态创建 AppDelegate 类
    NSString *appDelegateClassName = @"AppDelegate";
    Class AppDelegateClass = objc_allocateClassPair(objc_getClass("UIResponder"), [appDelegateClassName UTF8String], 0);
    class_addProtocol(AppDelegateClass, objc_getProtocol("UIApplicationDelegate"));

    // 为 AppDelegate 添加 window 属性
    objc_property_attribute_t type = { "T", "@\"UIWindow\"" };
    objc_property_attribute_t ownership = { "&", "" }; // strong
    objc_property_attribute_t nonatomic = { "N", "" }; // nonatomic
    objc_property_attribute_t backingivar  = { "V", "_window" };
    objc_property_attribute_t attrs[] = { type, ownership, nonatomic, backingivar };
    class_addIvar(AppDelegateClass, "_window", sizeof(id), log2(sizeof(id)), @encode(id));
    class_addProperty(AppDelegateClass, "window", attrs, 4);

    // 实现 application:didFinishLaunchingWithOptions:
    SEL didFinishLaunchingSEL = sel_registerName("application:didFinishLaunchingWithOptions:");
    IMP didFinishLaunchingIMP = imp_implementationWithBlock(^BOOL(id _self, UIApplication *application, NSDictionary *options){
      // 获取 UIWindow 类
      Class UIWindowClass = objc_getClass("UIWindow");
      // 创建窗口
      id window = ((id (*)(Class, SEL, CGRect))objc_msgSend)(UIWindowClass, sel_registerName("alloc"), CGRectZero);
      window = ((id (*)(id, SEL, CGRect))objc_msgSend)(window, sel_registerName("initWithFrame:"), [[UIScreen mainScreen] bounds]);
      // 设置 window 属性
      [_self setValue:window forKey:@"window"];

      // 创建 ViewController
      Class ViewControllerClass = objc_getClass("ViewController");
      if (!ViewControllerClass) {
        ViewControllerClass = objc_allocateClassPair(objc_getClass("UIViewController"), "ViewController", 0);

        // 添加 viewDidLoad 方法
        SEL viewDidLoadSEL = sel_registerName("viewDidLoad");
        IMP viewDidLoadIMP = imp_implementationWithBlock(^(id _self){
          // 调用父类的 viewDidLoad
          struct objc_super superInfo = {
            .receiver = _self,
            .super_class = class_getSuperclass([_self class])
          };
          ((void (*)(struct objc_super *, SEL))objc_msgSendSuper)(&superInfo, viewDidLoadSEL);

          // 设置背景颜色
          SEL setBackgroundColorSEL = sel_registerName("setBackgroundColor:");
          id whiteColor = ((id (*)(Class, SEL))objc_msgSend)(objc_getClass("UIColor"), sel_registerName("whiteColor"));
          ((void (*)(id, SEL, id))objc_msgSend)((id)((id (*)(id, SEL))objc_msgSend)(_self, sel_registerName("view")), setBackgroundColorSEL, whiteColor);

          // 添加 UI 元素
          // 创建 UILabel
          Class UILabelClass = objc_getClass("UILabel");
          id label = ((id (*)(Class, SEL))objc_msgSend)(UILabelClass, sel_registerName("alloc"));
          label = ((id (*)(id, SEL, CGRect))objc_msgSend)(label, sel_registerName("initWithFrame:"), (CGRect){50, 100, 300, 50});
          SEL setTextSEL = sel_registerName("setText:");
          ((void (*)(id, SEL, id))objc_msgSend)(label, setTextSEL, @"待办事项列表");
          ((void (*)(id, SEL, id))objc_msgSend)((id)((id (*)(id, SEL))objc_msgSend)(_self, sel_registerName("view")), sel_registerName("addSubview:"), label);

          // 创建 UIButton
          Class UIButtonClass = objc_getClass("UIButton");
          id button = ((id (*)(Class, SEL, NSInteger))objc_msgSend)(UIButtonClass, sel_registerName("buttonWithType:"), 0); // UIButtonTypeCustom = 0
          ((void (*)(id, SEL, CGRect))objc_msgSend)(button, sel_registerName("setFrame:"), (CGRect){50, 400, 200, 50});
          id blueColor = ((id (*)(Class, SEL))objc_msgSend)(objc_getClass("UIColor"), sel_registerName("blueColor"));
          ((void (*)(id, SEL, id))objc_msgSend)(button, setBackgroundColorSEL, blueColor);
          id buttonTitle = @"添加待办事项";
          ((void (*)(id, SEL, id, UIControlState))objc_msgSend)(button, sel_registerName("setTitle:forState:"), buttonTitle, 0);
          ((void (*)(id, SEL, id))objc_msgSend)((id)((id (*)(id, SEL))objc_msgSend)(_self, sel_registerName("view")), sel_registerName("addSubview:"), button);

          // 添加按钮点击事件
          SEL buttonActionSEL = sel_registerName("addTodoItem");
          IMP buttonActionIMP = imp_implementationWithBlock(^(id _self){
            // 实现按钮点击事件
            NSLog(@"按钮被点击");
          });
          class_addMethod([_self class], buttonActionSEL, buttonActionIMP, "v@:");
          UIControlEvents controlEventTouchUpInside = 1 << 6;
          ((void (*)(id, SEL, id, SEL, UIControlEvents))objc_msgSend)(button, sel_registerName("addTarget:action:forControlEvents:"), _self, buttonActionSEL, controlEventTouchUpInside);
        });
        class_addMethod(ViewControllerClass, viewDidLoadSEL, viewDidLoadIMP, "v@:");

        objc_registerClassPair(ViewControllerClass);
      }

      // 创建 ViewController 实例
      id viewController = ((id (*)(Class, SEL))objc_msgSend)(ViewControllerClass, sel_registerName("alloc"));
      viewController = ((id (*)(id, SEL))objc_msgSend)(viewController, sel_registerName("init"));
      // 设置根视图控制器
      SEL setRootViewControllerSEL = sel_registerName("setRootViewController:");
      ((void (*)(id, SEL, id))objc_msgSend)(window, setRootViewControllerSEL, viewController);
      // 显示窗口
      SEL makeKeyAndVisibleSEL = sel_registerName("makeKeyAndVisible");
      ((void (*)(id, SEL))objc_msgSend)(window, makeKeyAndVisibleSEL);

      return YES;
    });
    class_addMethod(AppDelegateClass, didFinishLaunchingSEL, didFinishLaunchingIMP, "B@:@@");

    objc_registerClassPair(AppDelegateClass);


    // 在 main.m 的 @autoreleasepool 中，继续添加

    // 动态创建 TodoItem 类
    Class TodoItemClass = objc_allocateClassPair(objc_getClass("NSObject"), "TodoItem", 0);

    // 添加 _title 实例变量
    class_addIvar(TodoItemClass, "_title", sizeof(id), log2(sizeof(id)), @encode(id));

    // 添加 title 属性
    objc_property_attribute_t type = { "T", "@\"NSString\"" };
    objc_property_attribute_t ownership = { "&", "" }; // strong
    objc_property_attribute_t nonatomic = { "N", "" }; // nonatomic
    objc_property_attribute_t backingivar  = { "V", "_title" };
    objc_property_attribute_t attrs[] = { type, ownership, nonatomic, backingivar };
    class_addProperty(TodoItemClass, "title", attrs, 4);

    // 添加 title 的 Getter 方法
    SEL titleGetterSEL = sel_registerName("title");
    IMP titleGetterIMP = imp_implementationWithBlock(^id(id _self){
        Ivar ivar = class_getInstanceVariable([_self class], "_title");
        return object_getIvar(_self, ivar);
    });
    class_addMethod(TodoItemClass, titleGetterSEL, titleGetterIMP, "@@:");

    // 添加 title 的 Setter 方法
    SEL titleSetterSEL = sel_registerName("setTitle:");
    IMP titleSetterIMP = imp_implementationWithBlock(^(id _self, id value){
        Ivar ivar = class_getInstanceVariable([_self class], "_title");
        object_setIvar(_self, ivar, value);
    });
    class_addMethod(TodoItemClass, titleSetterSEL, titleSetterIMP, "v@:@");

    objc_registerClassPair(TodoItemClass);



    // 启动应用程序
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
  }
}
