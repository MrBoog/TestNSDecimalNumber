//
//  main.m
//  TestNSDecimalNumber
//
//  Created by LH'sMacbook on 7/8/14.
//  Copyright (c) 2014 liuhuan. All rights reserved.
//

#import <Foundation/Foundation.h>

void cInterfaceDecimal()
{
    NSDecimal price1 = [[NSDecimalNumber decimalNumberWithString:@"15.99"] decimalValue];
    NSDecimal price2 = [[NSDecimalNumber decimalNumberWithString:@"29.99"] decimalValue];
    NSDecimal coupon = [[NSDecimalNumber decimalNumberWithString:@"5.00"] decimalValue];
    NSDecimal discount = [[NSDecimalNumber decimalNumberWithString:@".90"] decimalValue];
    NSDecimal numProducts = [[NSDecimalNumber decimalNumberWithString:@"2.0"] decimalValue];
    NSLocale *locale = [NSLocale currentLocale];
    NSDecimal result;
    
    //结果、参数1、参数2、四舍五入类型
    NSDecimalAdd(&result, &price1, &price2, NSRoundUp);
    NSLog(@"Subtotal: %@", NSDecimalString(&result, locale));
    NSDecimalSubtract(&result, &result, &coupon, NSRoundUp);
    NSLog(@"After coupon: %@", NSDecimalString(&result, locale));
    NSDecimalMultiply(&result, &result, &discount, NSRoundUp);
    NSLog(@"After discount: %@", NSDecimalString(&result, locale));
    NSDecimalDivide(&result, &result, &numProducts, NSRoundUp);
    NSLog(@"Average price per product: %@", NSDecimalString(&result, locale));
    NSDecimalPower(&result, &result, 2, NSRoundUp);
    NSLog(@"Average price squared: %@", NSDecimalString(&result, locale));
    
    
    
    //举例 处理异常
    NSDecimal a = [[NSDecimalNumber decimalNumberWithString:@"1.0"] decimalValue];
    NSDecimal b = [[NSDecimalNumber decimalNumberWithString:@"0.0"] decimalValue];
    NSDecimal result2;
    NSCalculationError success = NSDecimalDivide(&result2, &a, &b, NSRoundPlain);
    switch (success) {
        case NSCalculationNoError:
            NSLog(@"Operation successful");
            break;
        case NSCalculationLossOfPrecision:
            NSLog(@"Error: Operation resulted in loss of precision");
            break;
        case NSCalculationUnderflow:
            NSLog(@"Error: Operation resulted in underflow");
            break;
        case NSCalculationOverflow:
            NSLog(@"Error: Operation resulted in overflow");
            break;
        case NSCalculationDivideByZero:
            NSLog(@"Error: Tried to divide by zero !!!!!!!!");
            break;
        default:
            break;
    }
    
    
    //Comparing NSDecimal’s works exactly like the OOP interface, except you use the NSDecimalCompare() function replace compare:，
    NSDecimal discount1 = [[NSDecimalNumber decimalNumberWithString:@".85"] decimalValue];
    NSDecimal discount2 = [[NSDecimalNumber decimalNumberWithString:@".9"] decimalValue];
    NSComparisonResult result3 = NSDecimalCompare(&discount1, &discount2);
    if (result3 == NSOrderedAscending) {
        NSLog(@"85%% < 90%%");
    } else if (result3 == NSOrderedSame) {
        NSLog(@"85%% == 90%%");
    } else if (result3 == NSOrderedDescending) {
        NSLog(@"85%% > 90%%");
    }

}

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        // insert code here...

        NSDecimalNumber *price1 = [NSDecimalNumber decimalNumberWithString:@"15.99"];
        NSDecimalNumber *price2 = [NSDecimalNumber decimalNumberWithString:@"29.99"];
        NSDecimalNumber *coupon = [NSDecimalNumber decimalNumberWithString:@"5.00"];
        NSDecimalNumber *discount = [NSDecimalNumber decimalNumberWithString:@".90"];
        NSDecimalNumber *numProducts = [NSDecimalNumber decimalNumberWithString:@"2.0"];
        
        
        /*
         Arithmetic： add、subtract、multiply、divide、RaisingToPower
         */
        NSDecimalNumber *subtotal = [price1 decimalNumberByAdding:price2];
        NSDecimalNumber *afterCoupon = [subtotal decimalNumberBySubtracting:coupon];
        NSDecimalNumber *afterDiscount = [afterCoupon decimalNumberByMultiplyingBy:discount];
        NSDecimalNumber *average = [afterDiscount decimalNumberByDividingBy:numProducts];
        NSDecimalNumber *averageSquared = [average decimalNumberByRaisingToPower:2];
        
        NSLog(@"Subtotal: %@", subtotal);                    // 45.98
        NSLog(@"After coupon: %@", afterCoupon);             // 40.98
        NSLog((@"After discount: %@"), afterDiscount);       // 36.882
        NSLog(@"Average price per product: %@", average);    // 18.441
        NSLog(@"Average price squared: %@", averageSquared); // 340.070481
        
        
        
        /*
         round 四舍五入：
         scale 小数位数，
         the rest of parameter - 抛出异常处理
         */
        
        NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                           decimalNumberHandlerWithRoundingMode:NSRoundUp
                                           scale:2
                                           raiseOnExactness:NO
                                           raiseOnOverflow:NO
                                           raiseOnUnderflow:NO
                                           raiseOnDivideByZero:YES];
        
        NSDecimalNumber *subtotal2 = [NSDecimalNumber decimalNumberWithString:@"40.98"];
        NSDecimalNumber *discount2 = [NSDecimalNumber decimalNumberWithString:@".90"];
        
        NSDecimalNumber *total = [subtotal2 decimalNumberByMultiplyingBy:discount2 withBehavior:roundUp];
        NSLog(@"Rounded total: %@", total);
        
        
        /*
         compare
         */
        NSDecimalNumber *discount3 = [NSDecimalNumber decimalNumberWithString:@".85"];
        NSDecimalNumber *discount4 = [NSDecimalNumber decimalNumberWithString:@".9"];
        NSComparisonResult result = [discount3 compare:discount4];
        if (result == NSOrderedAscending) {
            NSLog(@"85%% < 90%%");
        } else if (result == NSOrderedSame) {
            NSLog(@"85%% == 90%%");
        } else if (result == NSOrderedDescending) {
            NSLog(@"85%% > 90%%");
        }
        
        
        /*
         the C interface is built around the NSDecimal struct...
         and the C interface uses functions like NSDecimalAdd(), NSDecimalSubtract(), etc.
         */
        NSDecimalNumber *price = [NSDecimalNumber decimalNumberWithString:@"15.99"];
        NSDecimal asStruct = [price decimalValue];
        NSDecimalNumber *asNewObject = [NSDecimalNumber decimalNumberWithDecimal:asStruct];
        
        // let's see Arithmetic of C:
        cInterfaceDecimal();
        
    }
    return 0;
}

