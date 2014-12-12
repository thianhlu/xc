//
//  xcode-practice-api.h
//  
//
//  Created by Thianh Lu on 11/11/14.
//
//

#import <Foundation/Foundation.h>

// Referencing variables
extern NSString *const DNAPIBaseURL;
extern NSString *const DNAPIStories;
extern NSString *const DNAPIComments;
extern NSString *const DNAPILogin;

@interface NSURLRequest (DNAPI)

// functions we'll need
+ (instancetype)requestWithPattern:(NSString *)string object:(id)object;
+ (instancetype)postRequest:(NSString *)string parameters:(NSDictionary *)parameters;
+ (instancetype)deleteRequest:(NSString *)string parameters:(NSDictionary *)parameters;
+ (instancetype)requestWithMethod:(NSString *)method
                              url:(NSString *)url
                       parameters:(NSDictionary *)parameters;

@end

@interface DNAPI : NSObject

+ (void)upvoteWithStory:(NSDictionary *)story;

@end

@interface DNUser : NSObject

+ (void)saveUpvoteWithStory:(NSDictionary *)story;
+ (void)isUpvotedWithStory:(NSDictionary *)story completion:(void (^)(BOOL succeed, NSError *error))completion;

@end
