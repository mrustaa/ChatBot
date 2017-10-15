//
//  UIPlaceHolderTextView.h
//  Chat bot
//
//  Created by Admin on 15.10.17.
//
//

#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>
IB_DESIGNABLE
@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, retain) IBInspectable NSString *placeholder;
@property (nonatomic, retain) IBInspectable UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
