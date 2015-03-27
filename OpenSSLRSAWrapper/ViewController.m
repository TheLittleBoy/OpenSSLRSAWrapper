//
//  ViewController.m
//  OpenSSLRSAWrapper
//
//  Created by sban@netspectrum.com on 9/29/12.
//  Copyright (c) 2012 sban@netspectrum.com. All rights reserved.
//

#import "ViewController.h"
#import "OpenSSLRSAWrapper.h"

@interface ViewController ()
@property (nonatomic,strong) IBOutlet UITextView *tv;
@end

@implementation ViewController
@synthesize tv;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSMutableString *string = [NSMutableString stringWithCapacity:0];
    
    //test
    OpenSSLRSAWrapper *wrapper = [OpenSSLRSAWrapper shareInstance];
    [string appendString:@"Start generate key pair...\n"];
    self.tv.text = string;
    BOOL success;
    if ([OpenSSLRSAWrapper canImportRSAKeys]) {
        NSLog(@"密钥文件已存在");
        [string appendString:@"密钥文件已存在!\n\n"];
        self.tv.text = string;
        
        success = [wrapper importRSAKeyWithType:KeyTypePublic];
        success = success && [wrapper importRSAKeyWithType:KeyTypePrivate];
        
    }else
    {
        success = [wrapper generateRSAKeyPairWithKeySize:1024];
        
        [string appendString:@"Done!\n"];
        self.tv.text = string;
        [string appendString:@"Start export keys...\n"];
        
        [wrapper exportRSAKeys];
        self.tv.text = string;
    }
    
    if(success){
        
        [string appendString:@"Done!\n\n"];
        //self.tv.text = string;
        
        //public key
        [string appendString:@"public key \n------------------------------------------"];
        //self.tv.text = string;
        
        [string appendFormat:@"%@",wrapper.publicKeyBase64];
        //self.tv.text = string;
        
        [string appendString:@"------------------------------------------\n"];
        //self.tv.text = string;
        
        //private key
        [string appendString:@"private key \n------------------------------------------"];
        //self.tv.text = string;
        
        [string appendFormat:@"%@",wrapper.privateKeyBase64];
        //self.tv.text = string;
        
        [string appendString:@"------------------------------------------\n"];
        //self.tv.text = string;
        
//        NSLog(@"public key:\n%@\n",wrapper.publicKeyBase64);
//        NSLog(@"private key:\n%@\n",wrapper.privateKeyBase64);
        
        NSString *plainText = @"OpenSSLRSAWrapper+is+simple+and+useful.";
        
        [string appendFormat:@"\n\n\nStart encrypt plain text...\nContent :%@\n",plainText];
        //self.tv.text = string;
        
        //加密转换为Data类型
        NSData *encryptData = [wrapper encryptRSAKeyWithType:KeyTypePrivate paddingType:RSA_PADDING_TYPE_PKCS1 plainText:plainText usingEncoding:NSASCIIStringEncoding];
        
        
        [string appendString:@"Done!\n"];
        //self.tv.text = string;
        
        //将加密后的Data转换为base64格式
        NSString * encryptDatastring = [encryptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        [string appendFormat:@"encryptDatastring:%@ \n",encryptDatastring];
        //self.tv.text = string;
        
        [string appendString:@"Start decrypt...\n"];
        //self.tv.text = string;
        
        //将base64转换为Data并解密
        NSString *decryptString = [wrapper decryptRSAKeyWithType:KeyTypePublic paddingType:RSA_PADDING_TYPE_PKCS1 plainTextData:[[NSData alloc] initWithBase64Encoding:encryptDatastring] usingEncoding:NSASCIIStringEncoding];
        
        [string appendString:@"Done!\n"];
        //self.tv.text = string;
        
        [string appendFormat:@"The decrypted plain text is %@\n",decryptString];
        //self.tv.text = string;
        
        NSLog(@"plain text :%@",decryptString);
        
        //签名
        [string appendString:@"\n\n\nSign!\n"];
        NSString * sign =[wrapper signRSAKeyWithString:@"hello~~ sign string"];
        [string appendFormat:@"The sign text is %@\n",sign];
        
        
        //验证签名
        [string appendString:@"\n\n\nverify!\n"];
        
        BOOL verify = [wrapper verifyRSAKeyWithString:@"hello~~ ~sign string" withSign:sign];
        [string appendFormat:@"The verify result is %d\n",verify];
        
        self.tv.text = string;
    }
    
    [string appendString:@"\n\n\ntest long baseEncoding\n\n"];
    
    NSString * longString = @"long very long ,string ,every string is ok,do you want to try?";
    [string appendFormat:@"%@",[[longString dataUsingEncoding:NSUTF8StringEncoding] base64Encoding]];
    self.tv.text = string;
    
    [string appendString:@"\n\ntest short baseEncoding\n\n"];
    
    longString = @"short";
    [string appendFormat:@"%@",[[longString dataUsingEncoding:NSUTF8StringEncoding] base64Encoding]];
    self.tv.text = string;
    

}

@end
