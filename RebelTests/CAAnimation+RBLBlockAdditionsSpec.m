//
//  NSColor+RBLCGColorAdditionsSpec.m
//  Rebel
//
//  Created by Danny Greg on 2012-09-13.
//  Copyright (c) 2012 GitHub. All rights reserved.
//

#import <Nimble/Nimble.h>
#import <Quick/Quick.h>
#import <Rebel/Rebel.h>

QuickSpecBegin(CAAnimationRBLBlockAdditions)

__block CAAnimation *animation = nil;
__block BOOL completionExecuted = NO;
__block void (^completionBlock)(BOOL) = ^(BOOL finished) {
	completionExecuted = YES;
};

beforeEach(^{
	animation = [[CAAnimation alloc] init];
	animation.rbl_completionBlock = completionBlock;

	expect(animation).notTo(beNil());
});

it(@"Should have set a completion block", ^ {
	expect(animation.rbl_completionBlock).notTo(beNil());
	expect(animation.rbl_completionBlock).to(equal(completionBlock));
	if (animation.rbl_completionBlock != nil) animation.rbl_completionBlock(YES);
	expect(@(completionExecuted)).to(beTruthy());
});

it(@"Should not have a nil delegate", ^{
	expect(animation.delegate).notTo(beNil());
});

it(@"Should fire once animation is completed", ^{
	CALayer *layer = [CALayer layer];
	CABasicAnimation *sampleAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	__block BOOL fired = NO;
	sampleAnimation.rbl_completionBlock = ^(BOOL complete) {
		fired = YES;

	};
	sampleAnimation.duration = 0.0;
	[layer addAnimation:sampleAnimation forKey:@"opacity"];
	layer.opacity = 1.f;
	expect(@(fired)).toEventually(beTruthy());
});

it(@"Should return nil if no completion block has been set", ^{
	CAAnimation *animation = [CAAnimation animation];
	expect(animation.rbl_completionBlock).to(beNil());
});


QuickSpecEnd
