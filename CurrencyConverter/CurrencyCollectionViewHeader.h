//
//  CurrencyCollectionViewHeader.h
//  CurrencyConverter
//
//  Created by Marcelo Fabri on 11/03/13.
//  Copyright (c) 2013 Marcelo Fabri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrencyCollectionViewHeader : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *sourceCurrencyValue;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;
@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;
@end
