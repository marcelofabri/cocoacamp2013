//
//  CurrencyCollectionViewCell.h
//  CurrencyConverter
//
//  Created by Marcelo Fabri on 11/03/13.
//  Copyright (c) 2013 Marcelo Fabri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrencyCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;

@end
