#import <Foundation/Foundation.h>
 
@interface NSObject(Utils)
 
// Reflects about self.
// Format: [ClassName {prop1 = val1; prop2 = val2; }]., 
// SuperClass' properties included (until NSObject).
- (NSString *) autoDescription; // can be in real description or somewhere else
 
@end
