//
//  AmountTextField.m
//  CurrencyConverter
//
//  Created by Marcelo Fabri on 24/03/13.
//  Copyright (c) 2013 Marcelo Fabri. All rights reserved.
//

#import "AmountTextField.h"

@implementation AmountTextField

- (void)awakeFromNib {
    [super awakeFromNib];
    self.background = [[UIImage imageNamed:@"textfield_backcground"] resizableImageWithCapInsets:UIEdgeInsetsMake(7, 4, 3, 4)];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 10);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 10);
}

@end
