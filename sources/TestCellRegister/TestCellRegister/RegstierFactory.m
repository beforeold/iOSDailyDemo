//
//  RegstierFactory.m
//  TestCellRegister
//
//  Created by 席萍萍Brook.dinglan on 2021/12/31.
//

#import "RegstierFactory.h"

static id regis_ = nil;

id getRegis(void) {
    if (regis_) {
        return regis_;
    }
    __auto_type regis = [UICollectionViewCellRegistration registrationWithCellClass:[UICollectionViewCell class]
                                                               configurationHandler:^(__kindof UICollectionViewCell * _Nonnull cell, NSIndexPath * _Nonnull indexPath, id  _Nonnull item) {
        
    }];
    regis_ = regis;
    return regis;
}

@implementation UICollectionView (RegstierFactory)

- (UICollectionViewCell *)getRegisterFromIndexPath:(NSIndexPath *)indexPath
                                           ofArray:(NSArray *)array
                                              item:(id)item
{
    
    id regis = getRegis();
//    UICollectionViewCellRegistration *regis = array[indexPath.item];
    NSLog(@"id: %@", [regis performSelector:@selector(reuseIdentifier)]);
    return [self dequeueConfiguredReusableCellWithRegistration:regis forIndexPath:indexPath item:item];
}

@end

@implementation MyCollectionView

- (__kindof UICollectionViewCell *)dequeueConfiguredReusableCellWithRegistration:(UICollectionViewCellRegistration *)registration forIndexPath:(NSIndexPath *)indexPath item:(id)item {
    return [super dequeueConfiguredReusableCellWithRegistration:registration forIndexPath:indexPath item:item];
}


@end
